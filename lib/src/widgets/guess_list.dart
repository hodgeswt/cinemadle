import 'package:cinemadle/src/blocs/main_view/main_view_bloc.dart';
import 'package:cinemadle/src/constants.dart';
import 'package:cinemadle/src/widgets/movie_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_repository/tmdb_repository.dart';

class GuessList extends StatefulWidget {
  const GuessList({
    super.key,
    required this.targetMovie,
    this.scrollController,
  });

  final Movie targetMovie;
  final ScrollController? scrollController;

  @override
  State<GuessList> createState() => _GuessListState();
}

class _GuessListState extends State<GuessList> {
  bool showBlurEffect = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController?.addListener(() {
      setState(() {
        showBlurEffect = (widget.scrollController?.offset ?? 0) > 0;
      });
    });
  }

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
                child: Stack(
                  children: [
                    ListView(
                      controller: widget.scrollController,
                      children: [
                        for (int i = 0;
                            i < (state.userGuesses ?? []).length;
                            i++)
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: MovieCard(
                              allowFlip: state.allowFlip?[i] ?? false,
                              movieData: state.userGuesses![i],
                              targetMovie: widget.targetMovie,
                              tileData:
                                  state.tileData?[state.userGuessesIds![i]] ??
                                      MovieTileData.all(color: null),
                            ),
                          )
                      ],
                    ),
                    if (showBlurEffect)
                      Positioned(
                        top: -5,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 40.0,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(25.0),
                              topRight: Radius.circular(25.0),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Constants.darkGrey,
                                Constants.darkGrey.withOpacity(0.0),
                              ],
                            ),
                          ),
                        ),
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
