import 'package:cinemadle/src/bloc_utilities/utilities.dart';
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

  bool get isTarget {
    return movieData.id == targetMovie.id;
  }

  Widget _getBackWidget() {
    return BlocBuilder<MainViewBloc, MainViewState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: Utilities.widthCalculator(MediaQuery.of(context).size.width),
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
                            fontSize: 32,
                          ),
                        ),
                      ),
                    ),
                  ),
                  state.blur?[movieData.id] ?? const Text("Image not found.")
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  RichText _titleBuilder(String title) {
    return RichText(
      textAlign: TextAlign.left,
      text: TextSpan(
        text: title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
        ),
      ),
    );
  }

  RichText _contentBuilder({
    String? content,
    List<String>? list,
    List<bool>? bold,
  }) {
    if (content?.isNotEmpty ?? false) {
      return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: content,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      );
    } else {
      if (list == null) {
        return RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
            text: "",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        );
      }

      double fontSize = list.length > 2 ? 14 : 16;

      return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: List.generate(list.length, (index) {
            bool isBold = bold?.getOrDefault(index, false) ?? false;
            String prefix = isBold ? "★ " : "";
            return TextSpan(
              text: index < list.length - 1
                  ? "$prefix${list[index]},\n"
                  : "$prefix${list[index]}",
              style: TextStyle(
                color: Colors.white,
                fontSize: isBold ? fontSize + 1 : fontSize,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
            );
          }),
        ),
      );
    }
  }

  AspectRatio _tileBuilder(int index) {
    double aspectRatio = Utilities.isMobile() ? 0.6 : 1.5;
    switch (index) {
      case 0:
        return AspectRatio(
          aspectRatio: aspectRatio,
          child: TextCard(
            title: _titleBuilder('Score'),
            content: _contentBuilder(
              content: movieData.voteAverage.toString(),
            ),
            arrow: tileData.userScoreArrow,
            color: tileData.userScore,
          ),
        );
      case 1:
        return AspectRatio(
          aspectRatio: aspectRatio,
          child: TextCard(
            title: _titleBuilder('Rating'),
            content: _contentBuilder(
              content: movieData.mpaRating,
            ),
            arrow: tileData.mpaRatingArrow,
            color: tileData.mpaRating,
          ),
        );
      case 2:
        return AspectRatio(
          aspectRatio: aspectRatio,
          child: TextCard(
            title: _titleBuilder('Year'),
            content: _contentBuilder(
              content: Utilities.formatDate(movieData.releaseDate),
            ),
            arrow: tileData.releaseDateArrow,
            color: tileData.releaseDate,
          ),
        );
      case 3:
        return AspectRatio(
          aspectRatio: aspectRatio,
          child: TextCard(
            title: _titleBuilder('Revenue'),
            content: _contentBuilder(
              content: Utilities.formatIntToDollars(movieData.revenue),
            ),
            arrow: tileData.revenueArrow,
            color: tileData.revenue,
          ),
        );
      case 4:
        return AspectRatio(
          aspectRatio: aspectRatio,
          child: TextCard(
            title: _titleBuilder('Runtime'),
            content: _contentBuilder(
              content: '${movieData.runtime} min',
            ),
            arrow: tileData.runtimeArrow,
            color: tileData.runtime,
          ),
        );
      case 5:
        return AspectRatio(
          aspectRatio: aspectRatio,
          child: TextCard(
            title: _titleBuilder('Genre'),
            content: _contentBuilder(
              list: movieData.genre,
              bold: tileData.boldGenre,
            ),
            color: tileData.genre,
          ),
        );
      case 6:
        return AspectRatio(
          aspectRatio: aspectRatio,
          child: TextCard(
            title: _titleBuilder('Director'),
            content: _contentBuilder(
              content: movieData.director,
            ),
            color: tileData.director,
          ),
        );
      case 7:
        return AspectRatio(
          aspectRatio: aspectRatio,
          child: TextCard(
            title: _titleBuilder('Writer'),
            content: _contentBuilder(
              content: movieData.writer,
            ),
            color: tileData.writer,
          ),
        );
      case 8:
        return AspectRatio(
          aspectRatio: aspectRatio,
          child: TextCard(
            title: _titleBuilder('Cast'),
            content: _contentBuilder(
              list: movieData.leads,
              bold: tileData.boldCast,
            ),
            color: tileData.firstInCast,
          ),
        );
      default:
        return AspectRatio(
          aspectRatio: aspectRatio,
          child: TextCard(
            title: _titleBuilder(''),
            content: _contentBuilder(
              content: '',
            ),
          ),
        );
    }
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
        child: RichText(
          textAlign: TextAlign.left,
          text: TextSpan(
            text: movieData.title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
              fontSize: 32,
            ),
            children: <TextSpan>[
              allowFlip
                  ? const TextSpan(
                      text: "\n(flip to see visual clue)",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    )
                  : const TextSpan(text: ""),
            ],
          ),
        ),
      ),
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
