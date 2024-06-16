import 'package:cinemadle/src/bloc_utilities/tile_data/tile_data.dart';
import 'package:cinemadle/src/utilities.dart';
import 'package:tmdb_repository/tmdb_repository.dart';

class MpaRatingCreator extends TileDataCreator<int> {
  MpaRatingCreator({
    required super.targetMovie,
  });

  @override
  Future<TileData> compute(Movie guessedMovie,
      {TileStatus status = TileStatus.none}) async {
    int target = Utilities.mapMpaRatingToInt(targetMovie.mpaRating);
    int guessed = Utilities.mapMpaRatingToInt(guessedMovie.mpaRating);

    data = target - guessed;

    content = guessedMovie.mpaRating;

    return super.compute(guessedMovie, status: status);
  }

  @override
  bool greenCondition(int value) {
    return value == 0;
  }

  @override
  bool yellowCondition(int value) {
    return value.abs() <= 1;
  }

  @override
  bool singleDownArrowCondition(int value) {
    // Never show single down arrow
    return false;
  }

  @override
  bool doubleDownArrowCondition(int value) {
    // Never show double down arrow
    return false;
  }

  @override
  bool singleUpArrowCondition(int value) {
    // Never show single up arrow
    return false;
  }

  @override
  bool doubleUpArrowCondition(int value) {
    // Never show double up arrow
    return false;
  }

  @override
  String get title => 'Rating';
}
