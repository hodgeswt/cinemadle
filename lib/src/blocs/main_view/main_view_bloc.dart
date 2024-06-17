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

        List<int> newGuessesIds =
            With.listCopyWith(state.userGuessesIds, event.id);

        int newRemainingGuesses =
            state.remainingGuesses - 1 >= 0 ? state.remainingGuesses - 1 : 0;

        Map<int, FlipCardController> newCardFlipControllers = With.mapCopyWith(
            state.cardFlipControllers, guess.id, FlipCardController());

        BlurredImage img = BlurredImageCreator.instance.create(BlurredImageData(
          imageUri: targetMovie.posterPath,
          blur: newRemainingGuesses >= 9 ? 100.0 : newRemainingGuesses * 2,
        ));

        Map<int, BlurredImage> newBlur =
            With.mapCopyWith(state.blur, guess.id, img);

        String newResults = state.results ?? "";

        MainViewStatus newStatus = state.status;

        if (newRemainingGuesses == 0 && guess.id != targetMovie.id) {
          newStatus = MainViewStatus.loss;
        } else if (guess.id == targetMovie.id) {
          newStatus = MainViewStatus.win;
        }

        TileStatus tileStatus = TileStatus.none;

        if (newStatus == MainViewStatus.win) {
          tileStatus = TileStatus.win;
        } else if (newStatus == MainViewStatus.loss) {
          tileStatus = TileStatus.loss;
        }

        TileCollection newGuess = TileCollection(
          guess,
          targetMovie,
          tileStatus == TileStatus.loss ? TileStatus.none : tileStatus,
          newRemainingGuesses <= 2 || targetMovie.id == guess.id,
        ).setTmdbRepository(_tmdbRepository);

        await newGuess.create();

        List<TileCollection> newGuesses = With.listCopyWith<TileCollection>(
          state.userGuesses,
          newGuess,
        );

        if (newStatus == MainViewStatus.loss) {
          TileCollection targetTile = TileCollection(
            targetMovie,
            targetMovie,
            tileStatus,
            true,
          ).setTmdbRepository(_tmdbRepository);

          await targetTile.create();
          newGuesses = newGuesses.prepend(targetTile);

          newGuessesIds = newGuessesIds.prepend(targetMovie.id);

          newBlur[targetMovie.id] = BlurredImageCreator.instance
              .create(BlurredImageData.zero(targetMovie.posterPath));
          newResults = _buildResults(newStatus, newGuesses);
        } else if (newStatus == MainViewStatus.win) {
          newBlur[targetMovie.id] = BlurredImageCreator.instance
              .create(BlurredImageData.zero(targetMovie.posterPath));

          newResults = _buildResults(newStatus, newGuesses);
        }

        emit(
          state.copyWith(
            userGuesses: newGuesses,
            status: newStatus,
            remainingGuesses: newRemainingGuesses,
            userGuessesIds: newGuessesIds,
            blur: newBlur,
            cardFlipControllers: newCardFlipControllers,
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

  String _buildResults(MainViewStatus status, List<TileCollection> guesses) {
    String results = "";

    for (int i = guesses.length - 1; i >= 0; i--) {
      results += guesses[i].results;
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
