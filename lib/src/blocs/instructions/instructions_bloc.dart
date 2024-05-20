import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'instructions_event.dart';
part 'instructions_state.dart';
part 'instructions_bloc.g.dart';

class InstructionsBloc extends Bloc<InstructionsEvent, InstructionsState> {
  InstructionsBloc()
      : super(const InstructionsState(
            status: InstructionsStateStatus.introduction)) {
    Map<InstructionsStateStatus, (String, String)> data = {
      InstructionsStateStatus.introduction: (
        "Introduction",
        "Cinemadle is a movie-guessing game.\n\nThere is a hidden movie you must guess in 10 tries or fewer.\n\nEnter your guesses in the box"
      ),
      InstructionsStateStatus.overview: (
        "Introduction",
        "Upon entering a guess, nine clues appear below to help you figure out the hidden movie. Through elimination, you can learn pieces of information about the movie."
      ),
      InstructionsStateStatus.detail: (
        "Clues",
        "Each of the nine clues comes in a colored box.\n\nIf a box appears green, it means that information is the same as the hidden movie.\n\nIf a clue is yellow, it means that information is close to the hidden movie.\n\nIf it is grey, it means that it is incorrect."
      ),
      InstructionsStateStatus.userScoreDescription: (
        "User Score",
        "The user score is the movie's rating (out of 10) from users of TheMovieDB.org.\n\nIf the user score is yellow, it means the guessed movie's score is within one point (rounded to one decimal place) of the hidden movie's user rating."
      ),
      InstructionsStateStatus.mpaRatingDescription: (
        "MPA Rating",
        "The MPA rating is the movie's rating by the Motion Picture Association (G, PG, PG-13, etc.).\n\nIf the MPA rating is yellow, it means the guessed movie's rating is within one rating of the hidden movie's rating."
      ),
      InstructionsStateStatus.releaseDateDescription: (
        "Release Date",
        "The release date is when the movie was theatrically released.\n\nIf the release date is yellow, it means the guessed movie's release date is within five years of the hidden movie's release date."
      ),
      InstructionsStateStatus.revenueDescription: (
        "Revenue",
        "The revenue is how much money the movie made.\n\nIf the revenue is yellow, it means the guessed movie's revenue is within \$50m of the hidden movie's revenue."
      ),
      InstructionsStateStatus.runtimeDescription: (
        "Runtime",
        "The runtime shows how long the movie is in minutes.\n\nIf the runtime is yellow, it means the guessed movie's runtime is within 20 minutes of the hidden movie's runtime."
      ),
      InstructionsStateStatus.genreDescription: (
        "Genre",
        "The genre shows the top three genres for the movie (according to TheMovieDB.org).\n\nThe genre box will appear yellow if any of those three genres is the same as one of the target movie's three genres."
      ),
      InstructionsStateStatus.directorDescription: (
        "Director",
        "The director box shows the name of the director.\n\nThe director box will appear yellow if the director of the guessed movie is the same as the writer of the hidden movie."
      ),
      InstructionsStateStatus.writerDescription: (
        "Writer",
        "The writer box shows the name of the writer.\n\nThe writer box will appear yellow if the writer of the guessed movie is the same as the director of the hidden movie."
      ),
      InstructionsStateStatus.firstInCastDescription: (
        "First in Cast",
        "The first in cast box shows the name of the first-billed actor or actress in the movie.\n\nThe first in cast box will appear yellow if the first-billed actor or actress of the guessed movie is a member of the cast in the hidden movie."
      ),
    };

    final List<InstructionsStateStatus> instructionsList = [
      InstructionsStateStatus.initial,
      InstructionsStateStatus.introduction,
      InstructionsStateStatus.overview,
      InstructionsStateStatus.detail,
      InstructionsStateStatus.userScoreDescription,
      InstructionsStateStatus.mpaRatingDescription,
      InstructionsStateStatus.releaseDateDescription,
      InstructionsStateStatus.revenueDescription,
      InstructionsStateStatus.runtimeDescription,
      InstructionsStateStatus.genreDescription,
      InstructionsStateStatus.directorDescription,
      InstructionsStateStatus.writerDescription,
      InstructionsStateStatus.firstInCastDescription,
    ];

    on<NextInstructionRequested>((event, emit) {
      if (state.index >= instructionsList.length - 1) {
        emit(
          InstructionsState.completed,
        );
        return;
      }

      int newIndex = state.index + 1;
      InstructionsStateStatus newStatus = instructionsList[newIndex];
      (String, String)? instructionData = data[newStatus];

      bool canGoBack = newIndex > 1;

      emit(
        state.copyWith(
          status: newStatus,
          index: newIndex,
          title: instructionData?.$1 ?? "",
          content: instructionData?.$2 ?? "",
          canGoBack: canGoBack,
        ),
      );
    });

    on<PreviousInstructionRequested>((event, emit) {
      int newIndex = state.index - 1 <= 1 ? 1 : state.index - 1;
      InstructionsStateStatus newStatus = instructionsList[newIndex];
      (String, String)? instructionData = data[newStatus];

      bool canGoBack = newIndex > 1;

      emit(
        state.copyWith(
          status: newStatus,
          index: newIndex,
          title: instructionData?.$1 ?? "",
          content: instructionData?.$2 ?? "",
          canGoBack: canGoBack,
        ),
      );
    });

    on<SkipInstructionsRequested>((event, emit) {
      emit(
        InstructionsState.completed,
      );
    });
  }
}
