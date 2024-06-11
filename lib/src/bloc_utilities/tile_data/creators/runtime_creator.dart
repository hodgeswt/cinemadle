import 'package:cinemadle/src/bloc_utilities/tile_data/tile_data_creator.dart';
import 'package:tmdb_repository/tmdb_repository.dart';

class RuntimeCreator extends TileDataCreator<int> {
  RuntimeCreator({
    required super.targetMovie,
  });

  @override
  compute(Movie guessedMovie) async {
    data = targetMovie.runtime - guessedMovie.runtime;

    super.compute(guessedMovie);
  }

  @override
  bool greenCondition(int value) {
    return value == 0;
  }

  @override
  bool yellowCondition(int value) {
    return value.abs() <= 20;
  }

  @override
  bool singleDownArrowCondition(int value) {
    //
    // Example:
    // Target: 90 min
    // Guessed: 100 min
    // Result: 90 min - 100 min = -10 min
    // Show single down arrow
    //
    return value < 0 && value >= -20;
  }

  @override
  bool doubleDownArrowCondition(int value) {
    //
    // Example:
    // Target: 90 min
    // Guessed: 120 min
    // Result: 90 min - 120 min = -30 min
    // Show double down arrow
    //
    return value < -20;
  }

  @override
  bool singleUpArrowCondition(int value) {
    //
    // Example
    // Target: 100 min
    // Guessed: 90 min
    // Result: 100 min - 90 min = 10 min
    // Show single up arrow
    //
    return value > 0 && value <= 20;
  }

  @override
  bool doubleUpArrowCondition(int value) {
    //
    // Example
    // Target: 120 min
    // Guessed: 90 min
    // Result: 120 min - 90 min = 30 min
    // Show double up arrow
    //
    return value > 20;
  }
}
