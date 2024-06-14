import 'package:cinemadle/src/bloc_utilities/blurred_image/blurred_image_creator.dart';
import 'package:cinemadle/src/bloc_utilities/blurred_image/blurred_image_data.dart';
import 'package:cinemadle/src/bloc_utilities/utilities.dart';
import 'package:cinemadle/src/converters/color_json_converter.dart';
import 'package:cinemadle/src/converters/blurred_image_json_converter.dart';
import 'package:cinemadle/src/converters/flip_card_controller_json_converter.dart';
import 'package:cinemadle/src/widgets/blurred_image.dart';
import 'package:cinemadle/src/bloc_utilities/tile_data/tile_data.dart';

import 'package:tmdb_repository/tmdb_repository.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_flip_card/controllers/flip_card_controllers.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

part 'main_view_event.dart';
part 'main_view_state.dart';
part 'main_view_bloc.g.dart';
part 'movie_tile_data.dart';

class MainViewBloc extends HydratedBloc<MainViewEvent, MainViewState> {
  final Movie targetMovie;
  final int uuid;

  final String singleUpArrow = "↑ ";
  final String doubleUpArrow = "↑↑ ";
  final String singleDownArrow = "↓ ";
  final String doubleDownArrow = "↓↓ ";

  final TmdbRepository _tmdbRepository;

  bool userFlippedCard = false;

  MainViewBloc(this.targetMovie, this.uuid, this._tmdbRepository)
      : super(MainViewState(status: MainViewStatus.playing, uuid: uuid)) {
    on<ResetRequested>((event, emit) {
      emit(MainViewState.empty);
    });

    on<ValidateCurrentRequested>((event, emit) async {
      if (event.uuid != state.uuid) {
        emit(MainViewState.empty);
      }
    });

    on<UserFlippedCard>((event, emit) {
      userFlippedCard = true;
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
        Movie guess = await _tmdbRepository.getMovie(event.id);

        List<Movie> newGuesses =
            With.listCopyWith<Movie>(state.userGuesses, guess);
        List<int> newGuessesIds =
            With.listCopyWith(state.userGuessesIds, event.id);

        MainViewStatus newStatus = state.status;
        int newRemainingGuesses =
            state.remainingGuesses - 1 >= 0 ? state.remainingGuesses - 1 : 0;

        MovieTileData tileColors = await _computeTileData(guess);

        Map<int, MovieTileData> newTileColors =
            With.mapCopyWith(state.tileData, guess.id, tileColors);

        Map<int, FlipCardController> newCardFlipControllers = With.mapCopyWith(
            state.cardFlipControllers, guess.id, FlipCardController());

        BlurredImage img = BlurredImageCreator.instance.create(BlurredImageData(
          imageUri: targetMovie.posterPath,
          blur: newRemainingGuesses >= 9 ? 100.0 : newRemainingGuesses * 2,
        ));
        Map<int, BlurredImage> newBlur =
            With.mapCopyWith(state.blur, guess.id, img);

        List<bool> newAllowFlip = List.filled(
                state.allowFlip?.length ?? 0, false)
            .prepend(newRemainingGuesses <= 2 || targetMovie.id == guess.id);

        String newResults = state.results ?? "";

        if (newRemainingGuesses == 0 && guess.id != targetMovie.id) {
          newStatus = MainViewStatus.loss;
          newResults = _buildResults(newTileColors.values, newStatus);
          newGuesses = newGuesses.prepend(targetMovie);

          newGuessesIds = newGuessesIds.prepend(targetMovie.id);
          newAllowFlip = List.filled(newAllowFlip.length, false).prepend(true);

          newBlur[targetMovie.id] = BlurredImageCreator.instance
              .create(BlurredImageData.zero(targetMovie.posterPath));

          MovieTileData targetColors = await _computeTileData(targetMovie);
          newTileColors[targetMovie.id] = targetColors;
        } else if (guess.id == targetMovie.id) {
          newStatus = MainViewStatus.win;
          newBlur[targetMovie.id] = BlurredImageCreator.instance
              .create(BlurredImageData.zero(targetMovie.posterPath));
          newResults = _buildResults(newTileColors.values, newStatus);
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
            results: newResults,
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
      return MovieTileData.all(color: TileColor.red);
    }

    if (movie.id == targetMovie.id) {
      return MovieTileData.all(color: TileColor.green);
    }

    CastCreator castCreator =
        CastCreator(targetMovie: targetMovie, tmdbRepository: _tmdbRepository);
    UserScoreCreator userScoreCreator =
        UserScoreCreator(targetMovie: targetMovie);
    MpaRatingCreator mpaRatingCreator =
        MpaRatingCreator(targetMovie: targetMovie);
    ReleaseDateCreator releaseDateCreator =
        ReleaseDateCreator(targetMovie: targetMovie);
    RevenueCreator revenueCreator = RevenueCreator(targetMovie: targetMovie);
    RuntimeCreator runtimeCreator = RuntimeCreator(targetMovie: targetMovie);
    DirectorCreator directorCreator = DirectorCreator(targetMovie: targetMovie);
    WriterCreator writerCreator = WriterCreator(targetMovie: targetMovie);
    GenreCreator genreCreator = GenreCreator(targetMovie: targetMovie);

    MovieTileData tileData = MovieTileData();

    await userScoreCreator.compute(movie);
    tileData.userScore = userScoreCreator.color;
    tileData.userScoreArrow = userScoreCreator.arrow;

    await mpaRatingCreator.compute(movie);
    tileData.mpaRating = mpaRatingCreator.color;
    tileData.mpaRatingArrow = mpaRatingCreator.arrow;

    await releaseDateCreator.compute(movie);
    tileData.releaseDate = releaseDateCreator.color;
    tileData.releaseDateArrow = releaseDateCreator.arrow;

    await revenueCreator.compute(movie);
    tileData.revenue = revenueCreator.color;
    tileData.revenueArrow = revenueCreator.arrow;

    await runtimeCreator.compute(movie);
    tileData.runtime = runtimeCreator.color;
    tileData.runtimeArrow = runtimeCreator.arrow;

    await directorCreator.compute(movie);
    tileData.director = directorCreator.color;

    await writerCreator.compute(movie);
    tileData.writer = writerCreator.color;

    await genreCreator.compute(movie);
    tileData.genre = genreCreator.color;
    tileData.boldGenre = genreCreator.bolded;

    await castCreator.compute(movie);
    tileData.firstInCast = castCreator.color;
    tileData.boldCast = castCreator.bolded;

    return tileData;
  }

  String _buildResults(
      Iterable<MovieTileData> tileColors, MainViewStatus status) {
    String results = "";
    for (MovieTileData x in tileColors) {
      List<TileColor?> colors = [
        x.userScore,
        x.mpaRating,
        x.releaseDate,
        x.revenue,
        x.runtime,
        x.genre,
        x.director,
        x.writer,
        x.firstInCast,
      ];

      String row = "";
      for (TileColor? color in colors) {
        row += resultsColorMap[color ?? TileColor.grey] ?? "⬛";
      }

      row += "\n";
      results += row;
    }

    if (status == MainViewStatus.win) {
      results += userFlippedCard ? "\n" : "No Visual Clues 👑\n\n";
    } else {
      results += "❌❌❌❌❌❌❌❌❌\n\n";
    }

    results += "Play at\ncinemadle.hodgeswill.com";

    return results;
  }

  @override
  MainViewState? fromJson(Map<String, dynamic> json) {
    return MainViewState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(MainViewState state) {
    return state.toJson();
  }
}
