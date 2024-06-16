import 'package:cinemadle/src/bloc_utilities/tile_data/tile_data.dart';
import 'package:cinemadle/src/bloc_utilities/utilities.dart';
import 'package:tmdb_repository/tmdb_repository.dart';

class DirectorCreator extends TileDataCreator<int> {
  DirectorCreator({
    required super.targetMovie,
  });

  @override
  Future<TileData> compute(Movie guessedMovie,
      {TileStatus status = TileStatus.none}) async {
    if (targetMovie.director == guessedMovie.director) {
      data = 2;
    } else if (targetMovie.writer == guessedMovie.director) {
      data = 1;
    } else {
      data = 0;
    }

    content = guessedMovie.director.split(' ').uniformPadding().join('\n');

    return super.compute(guessedMovie, status: status);
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

  @override
  String get title => 'Director';
}
