import 'package:bloc/bloc.dart';
import 'package:cinemadle/src/color_json_converter.dart';
import 'package:cinemadle/src/constants.dart';
import 'package:cinemadle/src/utilities.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tmdb_repository/tmdb_repository.dart';
import 'package:flutter/material.dart';

part 'main_view_event.dart';
part 'main_view_state.dart';
part 'main_view_bloc.g.dart';
part 'movie_tile_colors.dart';

class MainViewBloc extends Bloc<MainViewEvent, MainViewState> {
  final Movie targetMovie;

  MainViewBloc(this.targetMovie)
      : super(const MainViewState(status: MainViewStatus.playing)) {
    on<ResetRequested>((event, emit) {
      emit(MainViewState.empty);
    });
    on<UserGuessAdded>((event, emit) async {
      if (state.userGuessesIds?.contains(event.id) ?? false) {
        return;
      }

      try {
        Movie guess = await TmdbRepository().getMovie(event.id);

        List<Movie> newGuesses = [guess, ...state.userGuesses ?? []];
        List<int> newGuessesIds = [event.id, ...state.userGuessesIds ?? []];
        MainViewStatus newStatus = state.status;
        int newRemainingGuesses =
            state.remainingGuesses - 1 >= 0 ? state.remainingGuesses - 1 : 0;

        MovieTileColors tileColors = await _computeTileColors(guess);
        Map<int, MovieTileColors> newTileColors = {};
        newTileColors.addAll(state.tileColors ?? {});
        newTileColors[guess.id] = tileColors;

        if (newRemainingGuesses == 0 && guess.id != targetMovie.id) {
          newStatus = MainViewStatus.loss;
          newGuesses = [targetMovie, ...newGuesses];
          newGuessesIds = [targetMovie.id, ...newGuessesIds];

          MovieTileColors targetColors = await _computeTileColors(targetMovie);
          newTileColors[targetMovie.id] = targetColors;
        } else if (guess.id == targetMovie.id) {
          newStatus = MainViewStatus.win;
        }

        emit(
          state.copyWith(
            userGuesses: newGuesses,
            status: newStatus,
            remainingGuesses: newRemainingGuesses,
            userGuessesIds: newGuessesIds,
            tileColors: newTileColors,
          ),
        );
      } catch (err) {
        emit(
          state.copyWith(status: MainViewStatus.guessNotFound),
        );
      }
    });

    on<GuessNotFoundPopupDismissed>((event, emit) {
      emit(
        state.copyWith(status: MainViewStatus.playing),
      );
    });
  }

  Future<MovieTileColors> _computeTileColors(Movie movie) async {
    if (state.status == MainViewStatus.loss) {
      return MovieTileColors.all(color: Constants.lightRed);
    }

    if (movie.id == targetMovie.id) {
      return MovieTileColors.all(color: Constants.lightGreen);
    }

    MovieTileColors tileColors = MovieTileColors();

    double voteDiff = (double.parse(movie.voteAverage.toStringAsFixed(1)) -
            double.parse(targetMovie.voteAverage.toStringAsFixed(1)))
        .abs();
    Color? userScore = voteDiff == 0
        ? Constants.lightGreen
        : (voteDiff <= 1 ? Constants.goldYellow : null);
    tileColors.userScore = userScore;

    int mpaDiff = (Utilities.mapMpaRatingToInt(movie.mpaRating) -
            Utilities.mapMpaRatingToInt(targetMovie.mpaRating))
        .abs();
    Color? mpaRating = mpaDiff == 0
        ? Constants.lightGreen
        : (mpaDiff <= 1 ? Constants.goldYellow : null);
    tileColors.mpaRating = mpaRating;

    Duration dateDiff = Utilities.parseDate(movie.releaseDate)
        .difference(Utilities.parseDate(targetMovie.releaseDate))
        .abs();
    int yellowDateDiff = (Utilities.parseDate(movie.releaseDate).year -
            Utilities.parseDate(targetMovie.releaseDate).year)
        .abs();
    Color? releaseDate = dateDiff.inDays == 0
        ? Constants.lightGreen
        : (yellowDateDiff <= 5 ? Constants.goldYellow : null);
    tileColors.releaseDate = releaseDate;

    int revenueDiff = (movie.revenue - targetMovie.revenue).abs();
    Color? revenue = revenueDiff == 0
        ? Constants.lightGreen
        : (revenueDiff <= 50000000 ? Constants.goldYellow : null);
    tileColors.revenue = revenue;

    int runtimeDiff = (movie.runtime - targetMovie.runtime).abs();
    Color? runtime = runtimeDiff == 0
        ? Constants.lightGreen
        : (runtimeDiff <= 20 ? Constants.goldYellow : null);
    tileColors.runtime = runtime;

    Color? director = movie.director == targetMovie.director
        ? Constants.lightGreen
        : (movie.director == targetMovie.writer ? Constants.goldYellow : null);
    tileColors.director = director;

    Color? writer = movie.writer == targetMovie.writer
        ? Constants.lightGreen
        : (movie.writer == targetMovie.director ? Constants.goldYellow : null);
    tileColors.writer = writer;

    Color? lead = movie.lead == targetMovie.lead
        ? Constants.lightGreen
        : (await _isGuessedLeadInTargetCast(movie.lead)
            ? Constants.goldYellow
            : null);
    tileColors.firstInCast = lead;

    return tileColors;
  }

  Future<bool> _isGuessedLeadInTargetCast(String? lead) async {
    if (lead == null) {
      return false;
    }

    return await TmdbRepository().isActorInMovie(lead, targetMovie.id);
  }
}
