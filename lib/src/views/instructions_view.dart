import 'package:cinemadle/src/constants.dart';
import 'package:cinemadle/src/widgets/cinemadle_app_bar.dart';
import 'package:cinemadle/src/widgets/drawer.dart';
import 'package:cinemadle/src/widgets/instructions_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class InstructionsView extends StatelessWidget {
  InstructionsView({
    super.key,
  });

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  final List<InstructionsCard> instructions = [
    const InstructionsCard(
        title: "Introduction (1 of 12)",
        text:
            "Cinemadle is a movie-guessing game.\n\nThere is a hidden movie you must guess in 10 tries or fewer.\n\nEnter your guesses in the box. Upon entering a guess, nine clues appear in a card below to help you figure out the hidden movie. Through elimination, you can learn pieces of information about the movie."),
    const InstructionsCard(
        title: "Clues (2 of 12)",
        text:
            "Each of the nine clues comes in a colored box.\n\nIf a box appears green, it means that information is the same as the hidden movie.\n\nIf a clue is yellow, it means that information is close to the hidden movie.\n\nIf it is grey, it means that it is incorrect.\n\nArrows may appear that indicate how far off the goal you are.\n\nOn your last three guesses, you will receive a visual clue by flipping the card."),
    const InstructionsCard(
        title: "User Score (3 of 12)",
        text:
            "The user score is the movie's rating (out of 10) from users of TheMovieDB.org.\n\nIf the user score is yellow, it means the guessed movie's score is within one point (rounded to one decimal place) of the hidden movie's user rating.\n\nAn arrow upwards means your guess was below the score, and an arrow downwards means your guess was above the score."),
    const InstructionsCard(
        title: "MPA Rating (4 of 12)",
        text:
            "The MPA rating is the movie's rating by the Motion Picture Association (G, PG, PG-12, etc.).\n\nIf the MPA rating is yellow, it means the guessed movie's rating is within one rating of the hidden movie's rating.\n\nThe MPA rating will never have an arrow."),
    const InstructionsCard(
        title: "Release Year (5 of 12)",
        text:
            "The release year is the year when the movie was theatrically released.\n\nIf the release year is yellow, it means the guessed movie's release date is within five years of the hidden movie's release date.\n\nOne down arrow means your movie came out ten or fewer years before the goal. Two down arrows means your movie came out more than ten years before the goal. Up arrows have the same range but indicate your movie came after the goal."),
    const InstructionsCard(
        title: "Revenue (6 of 12)",
        text:
            "The revenue is how much money the movie made.\n\nIf the revenue is yellow, it means the guessed movie's revenue is within \$50m of the hidden movie's revenue.\n\nOne up arrow means your movie is less than \$50m below the goal revenue and two means your movie is more then \$50m below the goal. Down arrows have the same range but indicate your movie earned more than the goal."),
    const InstructionsCard(
        title: "Runtime (7 of 12)",
        text:
            "The runtime shows how long the movie is in minutes.\n\nIf the runtime is yellow, it means the guessed movie's runtime is within 20 minutes of the hidden movie's runtime.\n\nOne down arrow means your movie is 40 or fewer minutes shorter than the goal. Two down arrows means your movie is more than 40 minutes shorter than the goal. Down arrows have the same ranges but mean your movie is longer than the goal."),
    const InstructionsCard(
        title: "Genre (8 of 12)",
        text:
            "The genre shows the top three genres for the movie (according to TheMovieDB.org).\n\nThe genre box will appear yellow if any of those three genres is the same as one of the target movie's three genres.\n\nThe genre box will never have arrows."),
    const InstructionsCard(
        title: "Director (9 of 12)",
        text:
            "The director box shows the name of the director.\n\nThe director box will appear yellow if the director of the guessed movie is the same as the writer of the hidden movie.\n\nThe director box will never have arrows."),
    const InstructionsCard(
        title: "Writer (10 of 12)",
        text:
            "The writer box shows the name of the writer.\n\nThe writer box will appear yellow if the writer of the guessed movie is the same as the director of the hidden movie.\n\nThe writer box will never have an arrow."),
    const InstructionsCard(
        title: "Cast (11 of 12)",
        text:
            "The cast box shows the name of the first-billed actor or actress in the movie.\n\nThe first in cast box will appear yellow if the first-billed actor or actress of the guessed movie is a member of the cast in the hidden movie.\n\nThe cast box will never have arrows."),
    const InstructionsCard(
        title: "Cast (12 of 12)",
        text:
            "The cast box shows the name of the first-billed actor or actress in the movie.\n\nThe first in cast box will appear yellow if the first-billed actor or actress of the guessed movie is a member of the cast in the hidden movie.\n\nThe cast box will never have arrows.")
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: Constants.darkGradientBox(hasBorderRadius: false),
          child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.transparent,
            appBar: CinemadleAppBar(
              scaffoldKey: _scaffoldKey,
            ),
            endDrawer: drawer(context, Views.instructions),
            body: _buildBody(),
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return CardSwiper(
      cardBuilder: (context, index, percentThresholdX, percentThresholdY) =>
          instructions[index],
      cardsCount: instructions.length,
      backCardOffset: const Offset(50, 25),
      numberOfCardsDisplayed: 3,
    );
  }
}
