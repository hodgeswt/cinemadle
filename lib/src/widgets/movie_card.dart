import 'package:cinemadle/src/blocs/main_view/main_view_bloc.dart';
import 'package:cinemadle/src/constants.dart';
import 'package:cinemadle/src/utilities.dart';
import 'package:cinemadle/src/widgets/text_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flip_card/controllers/flip_card_controllers.dart';
import 'package:flutter_flip_card/flipcard/flip_card.dart';
import 'package:flutter_flip_card/modal/flip_side.dart';
import 'package:tmdb_repository/tmdb_repository.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({
    super.key,
    required this.movieData,
    required this.tileData,
    required this.targetMovie,
    required this.allowFlip,
  });

  final Movie movieData;
  final Movie targetMovie;
  final MovieTileData tileData;
  final bool allowFlip;

  Color? _getCardColor(MainViewState state) {
    if (state.status == MainViewStatus.win && movieData.id == targetMovie.id) {
      return Constants.otherGreen;
    }

    return null;
  }

  RoundedRectangleBorder? _getCardOutline(MainViewState state) {
    if (state.status == MainViewStatus.playing ||
        movieData.id != targetMovie.id) {
      return null;
    }

    Color c = movieData.id == targetMovie.id
        ? Constants.lightGreen
        : Constants.lightRed;
    return RoundedRectangleBorder(
      side: BorderSide(color: c, width: 4.0),
      borderRadius: BorderRadius.circular(8.0),
    );
  }

  Widget _getBackWidget() {
    return BlocBuilder<MainViewBloc, MainViewState>(
      builder: (context, state) {
        return Card(
          shape: _getCardOutline(state),
          elevation: 3,
          color: _getCardColor(state),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: Constants.stdPad,
                child: Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    "Visual Clue",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const Divider(),
              state.blur?[movieData.id] ?? const Text("Image not found.")
            ],
          ),
        );
      },
    );
  }

  Widget _getFrontWidget() {
    return BlocBuilder<MainViewBloc, MainViewState>(
      builder: (context, state) {
        return Card(
          shape: _getCardOutline(state),
          elevation: 3,
          color: _getCardColor(state),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: Constants.stdPad,
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "",
                      children: <TextSpan>[
                        TextSpan(
                          text: "${movieData.title}${allowFlip ? "\n" : ""}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Constants.black,
                            fontSize: 24,
                          ),
                        ),
                        allowFlip
                            ? const TextSpan(
                                text: "(flip to see visual clue)",
                                style: TextStyle(
                                  color: Constants.black,
                                  fontSize: 12,
                                ),
                              )
                            : const TextSpan(text: ""),
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(),
              Padding(
                padding: Constants.stdPad,
                child: GridView.count(
                  primary: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  children: [
                    TextCard(
                      text: 'User Score:${movieData.voteAverage}',
                      color: tileData.userScore,
                      arrow: tileData.userScoreArrow,
                    ),
                    TextCard(
                      text: 'MPA Rating:${movieData.mpaRating}',
                      color: tileData.mpaRating,
                      arrow: tileData.mpaRatingArrow,
                    ),
                    TextCard(
                      text:
                          'Release Year:${Utilities.formatDate(movieData.releaseDate)}',
                      color: tileData.releaseDate,
                      arrow: tileData.releaseDateArrow,
                    ),
                    TextCard(
                      text:
                          'Revenue:${Utilities.formatIntToDollars(movieData.revenue)}',
                      color: tileData.revenue,
                      arrow: tileData.revenueArrow,
                    ),
                    TextCard(
                      text: 'Runtime:${movieData.runtime} min',
                      color: tileData.runtime,
                      arrow: tileData.runtimeArrow,
                    ),
                    TextCard(
                      text: 'Genre:${movieData.genre.join(', ')}',
                      color: tileData.genre,
                    ),
                    TextCard(
                        text: 'Director:${movieData.director}',
                        color: tileData.director),
                    TextCard(
                      text: 'Writer:${movieData.writer}',
                      color: tileData.writer,
                    ),
                    TextCard(
                      text: 'First in Cast:${movieData.lead}',
                      color: tileData.firstInCast,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainViewBloc, MainViewState>(
      builder: (context, state) {
        return FlipCard(
          key: Key("${movieData.id}"),
          controller:
              state.cardFlipControllers?[movieData.id] ?? FlipCardController(),
          onTapFlipping: allowFlip,
          frontWidget: _getFrontWidget(),
          backWidget: _getBackWidget(),
          rotateSide: RotateSide.bottom,
          animationDuration: const Duration(milliseconds: 500),
        );
      },
    );
  }
}
