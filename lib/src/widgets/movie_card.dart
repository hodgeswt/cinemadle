import 'package:cinemadle/src/blocs/main_view/main_view_bloc.dart';
import 'package:cinemadle/src/constants.dart';
import 'package:cinemadle/src/utilities.dart';
import 'package:cinemadle/src/widgets/text_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_repository/tmdb_repository.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({
    super.key,
    required this.movieData,
    required this.tileColors,
    required this.targetMovie,
  });

  final Movie movieData;
  final Movie targetMovie;
  final MovieTileColors tileColors;

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

  @override
  Widget build(BuildContext context) {
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
                  child: Text(
                    textAlign: TextAlign.center,
                    movieData.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const Divider(),
              Padding(
                padding: Constants.stdPad,
                child: GridView.count(
                  primary: true,
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  children: [
                    TextCard(
                      text: 'User Score:\n${movieData.voteAverage}',
                      color: tileColors.userScore,
                    ),
                    TextCard(
                      text: 'MPA Rating:\n${movieData.mpaRating}',
                      color: tileColors.mpaRating,
                    ),
                    TextCard(
                      text:
                          'Release Date:\n${Utilities.formatDate(movieData.releaseDate)}',
                      color: tileColors.releaseDate,
                    ),
                    TextCard(
                      text:
                          'Revenue:\n${Utilities.formatIntToDollars(movieData.revenue)}',
                      color: tileColors.revenue,
                    ),
                    TextCard(
                      text: 'Runtime:\n${movieData.runtime}',
                      color: tileColors.runtime,
                    ),
                    TextCard(
                      text: 'Genre:\n${movieData.genre.join(', ')}',
                      color: tileColors.genre,
                    ),
                    TextCard(
                        text: 'Director:\n${movieData.director}',
                        color: tileColors.director),
                    TextCard(
                      text: 'Writer:\n${movieData.writer}',
                      color: tileColors.writer,
                    ),
                    TextCard(
                      text: 'First in Cast:\n${movieData.lead}',
                      color: tileColors.firstInCast,
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
}
