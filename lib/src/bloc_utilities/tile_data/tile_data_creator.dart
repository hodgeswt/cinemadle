import 'package:cinemadle/src/bloc_utilities/tile_data/tile_color.dart';
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

  bool isComputed = false;

  Future<void> compute(Movie guessedMovie) async {
    isComputed = true;
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
