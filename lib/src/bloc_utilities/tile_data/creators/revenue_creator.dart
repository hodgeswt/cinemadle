import 'package:cinemadle/src/bloc_utilities/tile_data/tile_data_creator.dart';
import 'package:tmdb_repository/tmdb_repository.dart';

class RevenueCreator extends TileDataCreator<int> {
  RevenueCreator({
    required super.targetMovie,
  });

  @override
  compute(Movie guessedMovie) async {
    data = targetMovie.revenue - guessedMovie.revenue;

    super.compute(guessedMovie);
  }

  @override
  bool greenCondition(int value) {
    return value == 0;
  }

  @override
  bool yellowCondition(int value) {
    return value.abs() <= 50000000;
  }

  @override
  bool singleDownArrowCondition(int value) {
    //
    // Example:
    // Target: $100,000,000
    // Guessed: $125,000,000
    // Result: $100,000,000 - $125,000,000 = -$25,000,000
    // Show single down arrow
    //
    return value < 0 && value >= -50000000;
  }

  @override
  bool doubleDownArrowCondition(int value) {
    //
    // Example:
    // Target: $100,000,000
    // Guessed: $500,000,000
    // Result: $100,000,000 - $500,000,000 = -$400,000,000
    // Show double down arrow
    //
    return value < -50000000;
  }

  @override
  bool singleUpArrowCondition(int value) {
    //
    // Example
    // Target: $125,000,000
    // Guessed: $100,000,000
    // Result: $125,000,000 - $100,000,000 = $25,000,000
    // Show single up arrow
    //
    return value > 0 && value <= 50000000;
  }

  @override
  bool doubleUpArrowCondition(int value) {
    //
    // Example
    // Target: $500,000,000
    // Guessed: $100,000,000
    // Result: $500,000,000 - $100,000,000 = $400,000,000
    // Show double up arrow
    //
    return value > 50000000;
  }
}
