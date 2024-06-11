import 'package:cinemadle/src/bloc_utilities/tile_data/tile_data_creator.dart';
import 'package:tmdb_repository/tmdb_repository.dart';

class WriterCreator extends TileDataCreator<int> {
  WriterCreator({
    required super.targetMovie,
  });

  @override
  compute(Movie guessedMovie) async {
    if (targetMovie.writer == guessedMovie.writer) {
      data = 2;
    } else if (targetMovie.director == guessedMovie.writer) {
      data = 1;
    } else {
      data = 0;
    }

    super.compute(guessedMovie);
  }

  @override
  bool greenCondition(int value) {
    return value == 2;
  }

  @override
  bool yellowCondition(int value) {
    return value == 1;
  }

  @override
  bool singleDownArrowCondition(int value) {
    // Never show arrow
    return false;
  }

  @override
  bool doubleDownArrowCondition(int value) {
    // Never show arrow
    return false;
  }

  @override
  bool singleUpArrowCondition(int value) {
    // Never show arrow
    return false;
  }

  @override
  bool doubleUpArrowCondition(int value) {
    // Never show arrow
    return false;
  }

  @override
  String get arrow {
    // Never show an arrow
    return '';
  }
}