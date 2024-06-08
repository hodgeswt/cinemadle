import 'package:cinemadle/src/bloc_utilities/tile_data/tile_data_creator.dart';
import 'package:cinemadle/src/bloc_utilities/utilities.dart';
import 'package:tmdb_repository/tmdb_repository.dart';

class CastCreator extends TileDataCreator<int> {
  CastCreator({
    required super.targetMovie,
    required this.tmdbRepository,
  });

  final TmdbRepository tmdbRepository;

  final List<bool> _bolded = [];

  @override
  compute(Movie guessedMovie) async {
    _bolded.clear();

    if (guessedMovie.leads.equals(targetMovie.leads)) {
      data = 2;
    } else {
      bool hit = false;
      for (String actor in guessedMovie.leads) {
        if (await tmdbRepository.isActorInMovie(actor, targetMovie.id)) {
          data = 1;
          hit = true;
          _bolded.add(true);
        } else {
          _bolded.add(false);
        }
      }

      if (!hit) {
        data = 0;
      }
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

  List<bool> get bolded {
    return _bolded;
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
