import 'package:bloc/bloc.dart';
import 'package:cinemadle/src/color_json_converter.dart';
import 'package:cinemadle/src/constants.dart';
import 'package:cinemadle/src/converters/blurred_image_json_converter.dart';
import 'package:cinemadle/src/converters/flip_card_controller_json_converter.dart';
import 'package:cinemadle/src/utilities.dart';
import 'package:cinemadle/src/widgets/blurred_image.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_flip_card/controllers/flip_card_controllers.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tmdb_repository/tmdb_repository.dart';
import 'package:flutter/material.dart';

part 'main_view_event.dart';
part 'main_view_state.dart';
part 'main_view_bloc.g.dart';
part 'movie_tile_data.dart';

class MainViewBloc extends Bloc<MainViewEvent, MainViewState> {
  final Movie targetMovie;

  final String singleUpArrow = "↑ ";
  final String doubleUpArrow = "↑↑ ";
  final String singleDownArrow = "↓ ";
  final String doubleDownArrow = "↓↓ ";

  MainViewBloc(this.targetMovie)
      : super(const MainViewState(status: MainViewStatus.playing)) {
    on<ResetRequested>((event, emit) {
      emit(MainViewState.empty);
    });

    on<FlipAllRequested>((event, emit) async {
      emit(state.copyWith(status: MainViewStatus.guessLoading));
      await _flipAll(state.cardFlipControllers ?? {});
      emit(state.copyWith(status: MainViewStatus.playing));
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

        MovieTileData tileColors = await _computeTileData(guess);
        Map<int, MovieTileData> newTileColors = {};
        newTileColors.addAll(state.tileData ?? {});
        newTileColors[guess.id] = tileColors;

        Map<int, FlipCardController> newCardFlipControllers = {};
        newCardFlipControllers.addAll(state.cardFlipControllers ?? {});
        newCardFlipControllers[guess.id] = FlipCardController();

        Map<int, BlurredImage> newBlur = {};
        newBlur.addAll(state.blur ?? {});
        newBlur[guess.id] = BlurredImage(
          imageBlur: newRemainingGuesses >= 9 ? 100.0 : newRemainingGuesses * 2,
          imagePath: targetMovie.posterPath,
        );

        List<bool> newAllowFlip = [
          newRemainingGuesses <= 2,
          ...List.filled(state.allowFlip?.length ?? 0, false)
        ];

        if (newRemainingGuesses == 0 && guess.id != targetMovie.id) {
          newStatus = MainViewStatus.loss;
          newGuesses = [targetMovie, ...newGuesses];
          newGuessesIds = [targetMovie.id, ...newGuessesIds];
          newAllowFlip = [true, ...List.filled(newAllowFlip.length, false)];
          newBlur[targetMovie.id] = BlurredImage(
            imageBlur: 0.0,
            imagePath: targetMovie.posterPath,
          );

          MovieTileData targetColors = await _computeTileData(targetMovie);
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
            tileData: newTileColors,
            blur: newBlur,
            cardFlipControllers: newCardFlipControllers,
            allowFlip: newAllowFlip,
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

  _flipAll(Map<int, FlipCardController> controllers) async {
    for (MapEntry<int, FlipCardController> x in controllers.entries) {
      if (!(x.value.state?.isFront ?? false)) {
        await x.value.flipcard();
      }
    }
  }

  Future<MovieTileData> _computeTileData(Movie movie) async {
    if (state.status == MainViewStatus.loss) {
      return MovieTileData.all(color: Constants.lightRed);
    }

    if (movie.id == targetMovie.id) {
      return MovieTileData.all(color: Constants.lightGreen);
    }

    MovieTileData tileData = MovieTileData();

    double userScoreDiff = (double.parse(movie.voteAverage.toStringAsFixed(1)) -
        double.parse(targetMovie.voteAverage.toStringAsFixed(1)));
    Color? userScore = userScoreDiff == 0
        ? Constants.lightGreen
        : (userScoreDiff.abs() <= 1 ? Constants.goldYellow : null);
    tileData.userScore = userScore;

    tileData.userScoreArrow = userScoreDiff > 0
        ? singleDownArrow
        : (userScoreDiff < 0 ? singleUpArrow : null);

    int mpaDiff = (Utilities.mapMpaRatingToInt(movie.mpaRating) -
        Utilities.mapMpaRatingToInt(targetMovie.mpaRating));
    Color? mpaRating = mpaDiff == 0
        ? Constants.lightGreen
        : (mpaDiff.abs() <= 1 ? Constants.goldYellow : null);
    tileData.mpaRating = mpaRating;

    int dateDiff = (Utilities.parseDate(movie.releaseDate).year -
        Utilities.parseDate(targetMovie.releaseDate).year);
    Color? releaseDate = dateDiff == 0
        ? Constants.lightGreen
        : (dateDiff.abs() <= 5 ? Constants.goldYellow : null);
    tileData.releaseDate = releaseDate;

    if (dateDiff != 0) {
      if (dateDiff < 0) {
        if (dateDiff > -10) {
          tileData.releaseDateArrow = singleUpArrow;
        } else if (dateDiff <= 10) {
          tileData.releaseDateArrow = doubleUpArrow;
        }
      }

      if (dateDiff > 0) {
        if (dateDiff < 10) {
          tileData.releaseDateArrow = singleDownArrow;
        } else if (dateDiff >= 10) {
          tileData.releaseDateArrow = doubleDownArrow;
        }
      }
    }

    int revenueDiff = (movie.revenue - targetMovie.revenue);
    Color? revenue = revenueDiff.abs() == 0
        ? Constants.lightGreen
        : (revenueDiff.abs() <= 50000000 ? Constants.goldYellow : null);
    tileData.revenue = revenue;

    if (revenueDiff > 0) {
      if (revenueDiff <= 50000000) {
        tileData.revenueArrow = singleDownArrow;
      } else {
        tileData.revenueArrow = doubleDownArrow;
      }
    }

    if (revenueDiff < 0) {
      if (revenueDiff >= -50000000) {
        tileData.revenueArrow = singleUpArrow;
      } else {
        tileData.revenueArrow = doubleUpArrow;
      }
    }

    int runtimeDiff = (movie.runtime - targetMovie.runtime).abs();
    Color? runtime = runtimeDiff == 0
        ? Constants.lightGreen
        : (runtimeDiff <= 20 ? Constants.goldYellow : null);
    tileData.runtime = runtime;

    if (runtimeDiff > 0) {
      if (runtimeDiff <= 40) {
        tileData.runtimeArrow = singleDownArrow;
      } else {
        tileData.runtimeArrow = doubleDownArrow;
      }
    }

    if (runtimeDiff < 0) {
      if (runtimeDiff >= -40) {
        tileData.runtimeArrow = singleUpArrow;
      } else {
        tileData.runtimeArrow = doubleUpArrow;
      }
    }

    Color? director = movie.director == targetMovie.director
        ? Constants.lightGreen
        : (movie.director == targetMovie.writer ? Constants.goldYellow : null);
    tileData.director = director;

    Color? writer = movie.writer == targetMovie.writer
        ? Constants.lightGreen
        : (movie.writer == targetMovie.director ? Constants.goldYellow : null);
    tileData.writer = writer;

    Color? genres;
    for (String genre in movie.genre) {
      if (targetMovie.genre.contains(genre)) {
        genres = Constants.goldYellow;
        break;
      }
    }
    tileData.genre = genres;

    Color? lead = movie.lead == targetMovie.lead
        ? Constants.lightGreen
        : (await _isGuessedLeadInTargetCast(movie.lead)
            ? Constants.goldYellow
            : null);
    tileData.firstInCast = lead;

    return tileData;
  }

  Future<bool> _isGuessedLeadInTargetCast(String? lead) async {
    if (lead == null) {
      return false;
    }

    return await TmdbRepository().isActorInMovie(lead, targetMovie.id);
  }
}
