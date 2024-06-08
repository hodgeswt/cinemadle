import 'package:cinemadle/src/bloc_utilities/tile_data/tile_data_creator.dart';
import 'package:tmdb_repository/tmdb_repository.dart';

class UserScoreCreator extends TileDataCreator<double> {
  UserScoreCreator({
    required super.targetMovie,
  });

  @override
  compute(Movie guessedMovie) async {
    double target = double.parse(targetMovie.voteAverage.toStringAsFixed(1));
    double guessed = double.parse(guessedMovie.voteAverage.toStringAsFixed(1));

    data = target - guessed;

    super.compute(guessedMovie);
  }

  @override
  bool greenCondition(double value) {
    return value == 0;
  }

  @override
  bool yellowCondition(double value) {
    return value.abs() <= 1;
  }

  @override
  bool singleDownArrowCondition(double value) {
    //
    // Example:
    // Target movie: 7.8
    // Guessed Movie: 9.0
    // compute() = -1.2
    //
    return value < 0;
  }

  @override
  bool doubleDownArrowCondition(double value) {
    // Never show double down arrow
    return false;
  }

  @override
  bool singleUpArrowCondition(double value) {
    //
    // Example:
    // Target movie: 7.8
    // Guessed Movie: 6.0
    // compute() = 1.8
    //
    return value > 0;
  }

  @override
  bool doubleUpArrowCondition(double value) {
    // Never show double up arrow
    return false;
  }
}
