import 'package:cinemadle/src/bloc_utilities/tile_data/tile_data.dart';
import 'package:cinemadle/src/bloc_utilities/utilities.dart';
import 'package:tmdb_repository/tmdb_repository.dart';

class CastCreator extends TileDataCreator<int> {
  CastCreator({
    required super.targetMovie,
    required this.tmdbRepository,
  });

  final TmdbRepository tmdbRepository;

  @override
  Future<TileData> compute(Movie guessedMovie,
      {TileStatus status = TileStatus.none}) async {
    emphasized.clear();

    if (guessedMovie.leads.equals(targetMovie.leads)) {
      data = 2;
    } else {
      bool hit = false;
      for (String actor in guessedMovie.leads) {
        if (await tmdbRepository.isActorInMovie(actor, targetMovie.id)) {
          data = 1;
          hit = true;
          emphasized.add(true);
        } else {
          emphasized.add(false);
        }
      }

      if (!hit) {
        data = 0;
      }
    }

    List<String> names = [];

    for (int i = 0; i < guessedMovie.leads.length; i++) {
      if (emphasized.getOrDefault(i, false)) {
        names.add('★ ${guessedMovie.leads[i]}');
      } else {
        names.add(guessedMovie.leads[i]);
      }
    }

    content = names.uniformPadding().join('\n');

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
  String get title => 'Cast';
}
