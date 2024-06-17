import 'package:cinemadle/src/bloc_utilities/tile_data/tile_data.dart';
import 'package:cinemadle/src/blocs/main_view/main_view_bloc.dart';
import 'package:cinemadle/src/constants.dart';
import 'package:cinemadle/src/utilities.dart';
import 'package:cinemadle/src/widgets/text_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flip_card/controllers/flip_card_controllers.dart';
import 'package:flutter_flip_card/flipcard/flip_card.dart';
import 'package:flutter_flip_card/modal/flip_side.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({
    super.key,
    required this.movieData,
  });

  final TileCollection movieData;

  bool get isTarget => movieData.movie.id == movieData.targetMovie.id;

  Widget _getBackWidget() {
    return BlocBuilder<MainViewBloc, MainViewState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: Constants.mediumGradientBox(
              hasBorder: isTarget,
              isWin: state.status,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: const TextSpan(
                          text: "Visual Clue",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: Constants.bigFont,
                          ),
                        ),
                      ),
                    ),
                  ),
                  state.blur?[movieData.movie.id] ??
                      const Text("Image not found.")
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Text _titleBuilder(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Constants.lightGrey,
        fontSize: Constants.tinyFont,
      ),
    );
  }

  List<Widget> _contentBuilder({
    required TileData tileData,
  }) {
    List<String> splits = tileData.content.split(", ");
    List<Widget> children = [];

    for (int i = 0; i < splits.length; i++) {
      children.add(
        Text(
          i < splits.length - 1 ? "${splits[i]}," : splits[i],
          textAlign: TextAlign.justify,
          style: const TextStyle(
            color: Colors.white,
            fontSize: Constants.mediumFont,
          ),
        ),
      );
    }

    if (tileData.arrow.isNotEmpty) {
      children.add(
        Text(
          tileData.arrow,
          style: const TextStyle(
            color: Colors.white,
            fontSize: Constants.bigFont,
          ),
        ),
      );
    }

    return children;
  }

  AspectRatio _tileBuilder(int index) {
    double aspectRatio = Utilities.isMobile() ? 1.0 : 1.5;
    TileData data = movieData.tiles[index].tileData;

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: TextCard(
        title: _titleBuilder(data.title),
        content: _contentBuilder(
          tileData: data,
        ),
        arrow: data.arrow,
        color: data.color,
      ),
    );
  }

  Widget _getFrontWidget() {
    return BlocBuilder<MainViewBloc, MainViewState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: Constants.mediumGradientBox(
              hasBorder: isTarget,
              isWin: state.status,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _getCardTitle(),
                  LayoutGrid(
                    gridFit: GridFit.passthrough,
                    columnSizes: [3.fr, 3.fr, 3.fr],
                    rowSizes: const [auto, auto, auto],
                    rowGap: 8,
                    columnGap: 8,
                    children: List.generate(9, (index) {
                      return _tileBuilder(index);
                    }),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Padding _getCardTitle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                movieData.movie.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: Constants.bigFont,
                ),
              ),
            ),
            if (movieData.allowFlip)
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'flip for visual clue',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Constants.smallFont,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainViewBloc, MainViewState>(
      builder: (context, state) {
        return FlipCard(
          key: Key("${movieData.movie.id}"),
          controller: state.cardFlipControllers?[movieData.movie.id] ??
              FlipCardController(),
          onTapFlipping: movieData.allowFlip,
          frontWidget: _getFrontWidget(),
          backWidget: _getBackWidget(),
          rotateSide: RotateSide.bottom,
          animationDuration: const Duration(milliseconds: 500),
          onFlipCallback: () {
            if (state.status == MainViewStatus.playing) {
              context.read<MainViewBloc>().add(const UserFlippedCard());
            }
          },
        );
      },
    );
  }
}
