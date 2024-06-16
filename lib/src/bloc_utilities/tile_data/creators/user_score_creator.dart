import 'package:cinemadle/src/bloc_utilities/tile_data/tile_data.dart';
import 'package:tmdb_repository/tmdb_repository.dart';

class UserScoreCreator extends TileDataCreator<double> {
  UserScoreCreator({
    required super.targetMovie,
  });

  double _round(double x) {
    int y = (x * 10).round();

    return y.toDouble() / 10;
  }

  @override
  Future<TileData> compute(Movie guessedMovie,
      {TileStatus status = TileStatus.none}) async {
    // Normal conversion functions were acting
    // weird, so I wrote my own. Rounds to the nearest
    // tenth.
    double target = _round(targetMovie.voteAverage);
    double guessed = _round(guessedMovie.voteAverage);

    // Dart has weird floating point errors
    // kind of often, so keep our diff to the
    // same sig figs
    data = _round(target - guessed);

    content = guessedMovie.voteAverage.toString();

    return super.compute(guessedMovie, status: status);
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

  @override
  String get title => 'Score';
}
