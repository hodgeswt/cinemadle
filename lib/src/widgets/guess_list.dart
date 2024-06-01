import 'package:cinemadle/src/blocs/main_view/main_view_bloc.dart';
import 'package:cinemadle/src/constants.dart';
import 'package:cinemadle/src/widgets/movie_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_repository/tmdb_repository.dart';

class GuessList extends StatelessWidget {
  const GuessList({
    super.key,
    required this.targetMovie,
    this.scrollController,
  });

  final Movie targetMovie;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainViewBloc, MainViewState>(
      buildWhen: (previous, current) {
        return previous.cardFlipControllers != current.cardFlipControllers;
      },
      builder: (context, state) {
        return Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    for (int i = 0; i < (state.userGuesses ?? []).length; i++)
                      Padding(
                        padding: Constants.stdPad,
                        child: MovieCard(
                          allowFlip: state.allowFlip?[i] ?? false,
                          movieData: state.userGuesses![i],
                          targetMovie: targetMovie,
                          tileData: state.tileData?[state.userGuessesIds![i]] ??
                              MovieTileData.all(color: null),
                        ),
                      )
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
