import 'package:bloc_test/bloc_test.dart';
import 'package:cinemadle/src/blocs/target_movie/target_movie_bloc.dart';
import 'package:cinemadle/src/utilities.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tmdb_repository/tmdb_repository.dart';

import '../../test_utilities.dart';

@GenerateNiceMocks([MockSpec<TmdbRepository>()])
import 'target_movie_bloc_test.mocks.dart';

void main() {
  group(TargetMovieBloc, () {
    late TargetMovieBloc bloc;
    late MockTmdbRepository tmdbRepository;

    setUp(() {
      initHydratedStorage();

      tmdbRepository = MockTmdbRepository();
      bloc = TargetMovieBloc(tmdbRepository);
    });

    test('toJson', () {
      expect(
        bloc.toJson(bloc.state),
        bloc.state.toJson(),
      );
    });

    test('fromJson', () {
      expect(
        bloc.fromJson(bloc.state.toJson()),
        bloc.state,
      );
    });

    test('initial state is correct', () {
      expect(bloc.state.status, TargetMovieStatus.initial);
      expect(bloc.state.movie, null);
      expect(bloc.state.uuid, null);
    });

    blocTest(
      'emits [loading, loaded] when repository call succeeds',
      build: () => bloc,
      setUp: () {
        when(tmdbRepository.getMovieFromPage(any, any))
            .thenAnswer((_) => Future.value(TestUtilities.movie()));
      },
      act: (b) => b.add(const TargetMovieLoadInitiated()),
      expect: () => [
        TargetMovieState(
          status: TargetMovieStatus.loading,
          uuid: Utilities.getUuid(),
        ),
        TargetMovieState(
          status: TargetMovieStatus.loaded,
          movie: TestUtilities.movie(),
          uuid: Utilities.getUuid(),
        ),
      ],
      verify: (_) {
        verify(tmdbRepository.getMovieFromPage(any, any)).called(1);
      },
    );

    blocTest(
      'emits [loading, failed] when repository call throws',
      build: () => bloc,
      setUp: () {
        when(tmdbRepository.getMovieFromPage(any, any))
            .thenThrow(Exception('error'));
      },
      act: (b) => b.add(const TargetMovieLoadInitiated()),
      expect: () => [
        TargetMovieState(
          status: TargetMovieStatus.loading,
          uuid: Utilities.getUuid(),
        ),
        TargetMovieState(
          status: TargetMovieStatus.failed,
          uuid: Utilities.getUuid(),
        ),
      ],
      verify: (_) {
        verify(tmdbRepository.getMovieFromPage(any, any)).called(1);
      },
    );

    blocTest(
      'emits nothing when pre-loaded',
      build: () => bloc,
      setUp: () {
        when(tmdbRepository.getMovieFromPage(any, any))
            .thenAnswer((_) => Future.value(TestUtilities.movie()));
      },
      act: (b) {
        b.add(const TargetMovieLoadInitiated());
        b.add(const TargetMovieLoadInitiated());
      },
      expect: () => [
        TargetMovieState(
          status: TargetMovieStatus.loading,
          uuid: Utilities.getUuid(),
        ),
        TargetMovieState(
          status: TargetMovieStatus.loaded,
          movie: TestUtilities.movie(),
          uuid: Utilities.getUuid(),
        )
      ],
      verify: (_) {
        verify(tmdbRepository.getMovieFromPage(any, any)).called(1);
      },
    );
  });
}
