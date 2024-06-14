import 'package:cinemadle/src/blocs/target_movie/target_movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tmdb_repository/tmdb_repository.dart';

import '../../test_utilities.dart';

void main() {
  group(TargetMovieState, () {
    test('copyWith no status', () {
      Movie movie = TestUtilities.movie();

      const state = TargetMovieState(
        movie: null,
        uuid: 0,
        status: TargetMovieStatus.initial,
      );

      final copy = state.copyWith(
        movie: movie,
        uuid: 3,
      );

      expect(copy.movie, movie);
      expect(copy.uuid, 3);
      expect(copy.status, state.status);
    });

    test('fromJson with movie', () {
      final movie = TestUtilities.movie();

      final state = TargetMovieState.fromJson({
        'movie': movie.toJson(),
        'uuid': 42,
        'status': 'initial',
      });

      expect(state.movie, movie);
      expect(state.uuid, 42);
      expect(state.status, TargetMovieStatus.initial);
    });
  });
}
