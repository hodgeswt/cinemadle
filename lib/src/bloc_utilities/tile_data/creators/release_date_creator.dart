import 'package:cinemadle/src/bloc_utilities/tile_data/tile_data.dart';
import 'package:cinemadle/src/utilities.dart';
import 'package:tmdb_repository/tmdb_repository.dart';

class ReleaseDateCreator extends TileDataCreator<int> {
  ReleaseDateCreator({
    required super.targetMovie,
  });

  @override
  Future<TileData> compute(Movie guessedMovie,
      {TileStatus status = TileStatus.none}) async {
    int target = Utilities.parseDate(targetMovie.releaseDate).year;
    int guessed = Utilities.parseDate(guessedMovie.releaseDate).year;

    data = target - guessed;

    content = Utilities.formatDate(guessedMovie.releaseDate);

    return super.compute(guessedMovie, status: status);
  }

  @override
  bool greenCondition(int value) {
    return value == 0;
  }

  @override
  bool yellowCondition(int value) {
    return value.abs() <= 5;
  }

  @override
  bool singleDownArrowCondition(int value) {
    //
    // Example:
    // Target: 2019
    // Guessed: 2021
    // Result: 2019 - 2021 = -2
    // Show single down arrow
    //
    return value < 0 && value > -10 && value >= -5;
  }

  @override
  bool doubleDownArrowCondition(int value) {
    //
    // Example:
    // Target: 2000
    // Guessed: 2021
    // Result: 2000 - 2021 = -21
    // Show double down arrow
    //
    return value < -5;
  }

  @override
  bool singleUpArrowCondition(int value) {
    //
    // Example
    // Target: 2023
    // Guessed: 2021
    // Result: 2023 - 2021 = 2
    // Show single up arrow
    //
    return value > 0 && value <= 5;
  }

  @override
  bool doubleUpArrowCondition(int value) {
    //
    // Example
    // Target: 2023
    // Guessed: 2000
    // Result: 2023 - 2000 = 23
    // Show double up arrow
    //
    return value > 5;
  }

  @override
  String get title => 'Year';
}
