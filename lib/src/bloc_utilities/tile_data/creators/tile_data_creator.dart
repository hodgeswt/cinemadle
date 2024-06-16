import 'package:cinemadle/src/bloc_utilities/tile_data/tile_data.dart';
import 'package:tmdb_repository/tmdb_repository.dart';

abstract class TileDataCreator<T> {
  TileDataCreator({
    required this.targetMovie,
  });

  final Movie targetMovie;

  bool yellowCondition(T value);
  bool greenCondition(T value);
  bool singleDownArrowCondition(T value);
  bool doubleDownArrowCondition(T value);
  bool singleUpArrowCondition(T value);
  bool doubleUpArrowCondition(T value);

  String get title;

  bool isComputed = false;
  String content = '';

  final List<bool> emphasized = [];

  Future<TileData> compute(
    Movie guessedMovie, {
    TileStatus status = TileStatus.none,
  }) async {
    isComputed = true;

    TileColor c;

    switch (status) {
      case TileStatus.none:
        c = color;
        break;
      case TileStatus.win:
        c = TileColor.green;
        break;
      case TileStatus.loss:
        c = TileColor.red;
        break;
    }

    return TileData(
      arrow: arrow,
      color: c,
      emphasized: emphasized,
      title: title,
      content: content,
    );
  }

  late T data;

  TileColor get color {
    if (!isComputed) {
      return TileColor.grey;
    }

    if (greenCondition(data)) {
      return TileColor.green;
    }

    if (yellowCondition(data)) {
      return TileColor.yellow;
    }

    return TileColor.grey;
  }

  String get arrow {
    if (!isComputed) {
      return '';
    }

    if (singleDownArrowCondition(data)) {
      return '↓';
    }

    if (doubleDownArrowCondition(data)) {
      return '↓↓';
    }

    if (singleUpArrowCondition(data)) {
      return '↑';
    }

    if (doubleUpArrowCondition(data)) {
      return '↑↑';
    }

    return '';
  }
}
