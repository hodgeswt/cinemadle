import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'instructions_event.dart';
part 'instructions_state.dart';
part 'instructions_bloc.g.dart';

class InstructionsBloc
    extends HydratedBloc<InstructionsEvent, InstructionsState> {
  Map<InstructionsStateStatus, (String, String)> data = {
    InstructionsStateStatus.introduction: (
      "Introduction",
      "Cinemadle is a movie-guessing game.\n\nThere is a hidden movie you must guess in 10 tries or fewer.\n\nEnter your guesses in the box"
    ),
    InstructionsStateStatus.overview: (
      "Introduction",
      "Upon entering a guess, nine clues appear in a card below to help you figure out the hidden movie. Through elimination, you can learn pieces of information about the movie."
    ),
    InstructionsStateStatus.detail: (
      "Clues",
      "Each of the nine clues comes in a colored box.\n\nIf a box appears green, it means that information is the same as the hidden movie.\n\nIf a clue is yellow, it means that information is close to the hidden movie.\n\nIf it is grey, it means that it is incorrect.\n\nArrows may appear that indicate how far off the goal you are.\n\nOn your last three guesses, you will receive a visual clue by flipping the card."
    ),
    InstructionsStateStatus.userScoreDescription: (
      "User Score",
      "The user score is the movie's rating (out of 10) from users of TheMovieDB.org.\n\nIf the user score is yellow, it means the guessed movie's score is within one point (rounded to one decimal place) of the hidden movie's user rating.\n\nAn arrow upwards means your guess was below the score, and an arrow downwards means your guess was above the score."
    ),
    InstructionsStateStatus.mpaRatingDescription: (
      "MPA Rating",
      "The MPA rating is the movie's rating by the Motion Picture Association (G, PG, PG-13, etc.).\n\nIf the MPA rating is yellow, it means the guessed movie's rating is within one rating of the hidden movie's rating.\n\nThe MPA rating will never have an arrow."
    ),
    InstructionsStateStatus.releaseDateDescription: (
      "Release Year",
      "The release year is the year when the movie was theatrically released.\n\nIf the release year is yellow, it means the guessed movie's release date is within five years of the hidden movie's release date.\n\nOne down arrow means your movie came out ten or fewer years before the goal. Two down arrows means your movie came out more than ten years before the goal. Up arrows have the same range but indicate your movie came after the goal."
    ),
    InstructionsStateStatus.revenueDescription: (
      "Revenue",
      "The revenue is how much money the movie made.\n\nIf the revenue is yellow, it means the guessed movie's revenue is within \$50m of the hidden movie's revenue.\n\nOne up arrow means your movie is less than \$50m below the goal revenue and two means your movie is more then \$50m below the goal. Down arrows have the same range but indicate your movie earned more than the goal."
    ),
    InstructionsStateStatus.runtimeDescription: (
      "Runtime",
      "The runtime shows how long the movie is in minutes.\n\nIf the runtime is yellow, it means the guessed movie's runtime is within 20 minutes of the hidden movie's runtime.\n\nOne down arrow means your movie is 40 or fewer minutes shorter than the goal. Two down arrows means your movie is more than 40 minutes shorter than the goal. Down arrows have the same ranges but mean your movie is longer than the goal."
    ),
    InstructionsStateStatus.genreDescription: (
      "Genre",
      "The genre shows the top three genres for the movie (according to TheMovieDB.org).\n\nThe genre box will appear yellow if any of those three genres is the same as one of the target movie's three genres.\n\nThe genre box will never have arrows."
    ),
    InstructionsStateStatus.directorDescription: (
      "Director",
      "The director box shows the name of the director.\n\nThe director box will appear yellow if the director of the guessed movie is the same as the writer of the hidden movie.\n\nThe director box will never have arrows."
    ),
    InstructionsStateStatus.writerDescription: (
      "Writer",
      "The writer box shows the name of the writer.\n\nThe writer box will appear yellow if the writer of the guessed movie is the same as the director of the hidden movie.\n\nThe writer box will never have an arrow."
    ),
    InstructionsStateStatus.firstInCastDescription: (
      "First in Cast",
      "The first in cast box shows the name of the first-billed actor or actress in the movie.\n\nThe first in cast box will appear yellow if the first-billed actor or actress of the guessed movie is a member of the cast in the hidden movie.\n\nThe first in cast box will never have arrows."
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

  InstructionsBloc()
      : super(
            const InstructionsState(status: InstructionsStateStatus.initial)) {
    on<InitialLoadRequested>((event, emit) {
      if (state.status == InstructionsStateStatus.initial) {
        _nextInstructionRequested(event, emit);
      }
    });

    on<NextInstructionRequested>((event, emit) {
      _nextInstructionRequested(event, emit);
    });

    on<PreviousInstructionRequested>((event, emit) {
      int newIndex = state.index - 1 <= 1 ? 1 : state.index - 1;
      InstructionsStateStatus newStatus = instructionsList[newIndex];
      (String, String)? instructionData = data[newStatus];

      bool canGoBack = newIndex > 1;
      bool canGoForward = newIndex < instructionsList.length - 1;

      emit(
        state.copyWith(
          status: newStatus,
          index: newIndex,
          title: instructionData?.$1 ?? "",
          content: instructionData?.$2 ?? "",
          canGoBack: canGoBack,
          canGoForward: canGoForward,
        ),
      );
    });
  }

  _nextInstructionRequested(dynamic event, dynamic emit) {
    if (state.index == instructionsList.length - 1) {
      return;
    }

    int newIndex = state.index + 1;
    InstructionsStateStatus newStatus = instructionsList[newIndex];
    (String, String)? instructionData = data[newStatus];

    bool canGoBack = newIndex > 1;
    bool canGoForward = newIndex < instructionsList.length - 1;

    emit(
      state.copyWith(
        status: newStatus,
        index: newIndex,
        title: instructionData?.$1 ?? "",
        content: instructionData?.$2 ?? "",
        canGoBack: canGoBack,
        canGoForward: canGoForward,
      ),
    );
  }

  @override
  InstructionsState? fromJson(Map<String, dynamic> json) {
    return InstructionsState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(InstructionsState state) {
    return state.toJson();
  }
}
