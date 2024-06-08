import 'package:cinemadle/src/bloc_utilities/tile_data/tile_data.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tmdb_repository/tmdb_repository.dart';

import '../../../test_utilities.dart';

@GenerateNiceMocks([MockSpec<TmdbRepository>()])
import 'cast_creator_test.mocks.dart';

void main() {
  group('CastCreator', () {
    MockTmdbRepository tmdbRepository = MockTmdbRepository();

    test('constructor', () {
      Movie targetMovie = TestUtilities.movie();

      CastCreator creator = CastCreator(
        targetMovie: targetMovie,
        tmdbRepository: tmdbRepository,
      );

      expect(creator.targetMovie, targetMovie);
      expect(creator.tmdbRepository, tmdbRepository);
    });

    group('compute', () {
      test('no match', () async {
        Movie targetMovie = TestUtilities.movie(
            leads: ["Harrison Ford", "Sally Field", "Kevin Costner"]);
        Movie guessedMovie = TestUtilities.movie(
            leads: ["Michael B. Jordan", "Uma Thurman", "Anthony Hopkins"]);

        when(tmdbRepository.isActorInMovie(any, any))
            .thenAnswer((_) => Future.value(false));

        CastCreator creator = CastCreator(
          targetMovie: targetMovie,
          tmdbRepository: tmdbRepository,
        );

        await creator.compute(guessedMovie);

        verify(tmdbRepository.isActorInMovie(any, any)).called(3);
        expect(creator.data, 0);
        expect(creator.isComputed, true);
      });

      test('one match', () async {
        Movie targetMovie = TestUtilities.movie(
            leads: ["Harrison Ford", "Sally Field", "Kevin Costner"]);
        Movie guessedMovie = TestUtilities.movie(
            leads: ["Harrison Ford", "Uma Thurman", "Anthony Hopkins"]);

        when(tmdbRepository.isActorInMovie("Harrison Ford", any))
            .thenAnswer((_) => Future.value(true));
        when(tmdbRepository.isActorInMovie("Uma Thurman", any))
            .thenAnswer((_) => Future.value(false));
        when(tmdbRepository.isActorInMovie("Anthony Hopkins", any))
            .thenAnswer((_) => Future.value(false));

        CastCreator creator = CastCreator(
          targetMovie: targetMovie,
          tmdbRepository: tmdbRepository,
        );

        await creator.compute(guessedMovie);

        verify(tmdbRepository.isActorInMovie(any, any)).called(3);
        expect(creator.data, 1);
        expect(creator.isComputed, true);
      });

      test('two match', () async {
        Movie targetMovie = TestUtilities.movie(
            leads: ["Harrison Ford", "Sally Field", "Kevin Costner"]);
        Movie guessedMovie = TestUtilities.movie(
            leads: ["Harrison Ford", "Sally Field", "Anthony Hopkins"]);

        when(tmdbRepository.isActorInMovie("Harrison Ford", any))
            .thenAnswer((_) => Future.value(true));
        when(tmdbRepository.isActorInMovie("Sally Field", any))
            .thenAnswer((_) => Future.value(true));
        when(tmdbRepository.isActorInMovie("Anthony Hopkins", any))
            .thenAnswer((_) => Future.value(false));

        CastCreator creator = CastCreator(
          targetMovie: targetMovie,
          tmdbRepository: tmdbRepository,
        );

        await creator.compute(guessedMovie);

        verify(tmdbRepository.isActorInMovie(any, any)).called(3);
        expect(creator.data, 1);
        expect(creator.isComputed, true);
      });

      test('three match', () async {
        Movie targetMovie = TestUtilities.movie(
            leads: ["Harrison Ford", "Sally Field", "Kevin Costner"]);
        Movie guessedMovie = TestUtilities.movie(
            leads: ["Harrison Ford", "Sally Field", "Kevin Costner"]);

        CastCreator creator = CastCreator(
          targetMovie: targetMovie,
          tmdbRepository: tmdbRepository,
        );

        await creator.compute(guessedMovie);

        verifyNever(tmdbRepository.isActorInMovie(any, any));
        expect(creator.data, 2);
        expect(creator.isComputed, true);
      });
    });

    group('colors', () {
      test('greenCondition', () {
        Movie targetMovie = TestUtilities.movie();

        CastCreator creator = CastCreator(
          targetMovie: targetMovie,
          tmdbRepository: tmdbRepository,
        );

        expect(creator.greenCondition(0), false);
        expect(creator.greenCondition(1), false);
        expect(creator.greenCondition(2), true);
      });

      test('yellowCondition', () {
        Movie targetMovie = TestUtilities.movie();

        CastCreator creator = CastCreator(
          targetMovie: targetMovie,
          tmdbRepository: tmdbRepository,
        );

        expect(creator.yellowCondition(0), false);
        expect(creator.yellowCondition(1), true);
        expect(creator.yellowCondition(2), false);
      });
    });

    group('arrows', () {
      test('singleDownArrowCondition', () {
        Movie targetMovie = TestUtilities.movie();

        CastCreator creator = CastCreator(
          targetMovie: targetMovie,
          tmdbRepository: tmdbRepository,
        );

        expect(creator.singleDownArrowCondition(0), false);
        expect(creator.singleDownArrowCondition(1), false);
        expect(creator.singleDownArrowCondition(2), false);
      });

      test('doubleDownArrowCondition', () {
        Movie targetMovie = TestUtilities.movie();

        CastCreator creator = CastCreator(
          targetMovie: targetMovie,
          tmdbRepository: tmdbRepository,
        );

        expect(creator.doubleDownArrowCondition(0), false);
        expect(creator.doubleDownArrowCondition(1), false);
        expect(creator.doubleDownArrowCondition(2), false);
      });

      test('singleUpArrowCondition', () {
        Movie targetMovie = TestUtilities.movie();

        CastCreator creator = CastCreator(
          targetMovie: targetMovie,
          tmdbRepository: tmdbRepository,
        );

        expect(creator.singleUpArrowCondition(0), false);
        expect(creator.singleUpArrowCondition(1), false);
        expect(creator.singleUpArrowCondition(2), false);
      });

      test('doubleUpArrowCondition', () {
        Movie targetMovie = TestUtilities.movie();

        CastCreator creator = CastCreator(
          targetMovie: targetMovie,
          tmdbRepository: tmdbRepository,
        );

        expect(creator.doubleUpArrowCondition(0), false);
        expect(creator.doubleUpArrowCondition(1), false);
        expect(creator.doubleUpArrowCondition(2), false);
      });

      test('arrow', () {
        Movie targetMovie = TestUtilities.movie();

        CastCreator creator = CastCreator(
          targetMovie: targetMovie,
          tmdbRepository: tmdbRepository,
        );

        expect(creator.arrow, '');
      });
    });

    group('getters', () {
      group('colors', () {
        test('color: green', () async {
          Movie targetMovie = TestUtilities.movie(
              leads: ["Harrison Ford", "Sally Field", "Kevin Costner"]);
          Movie guessedMovie = TestUtilities.movie(
              leads: ["Harrison Ford", "Sally Field", "Kevin Costner"]);

          CastCreator creator = CastCreator(
            targetMovie: targetMovie,
            tmdbRepository: tmdbRepository,
          );

          await creator.compute(guessedMovie);

          verifyNever(tmdbRepository.isActorInMovie(any, any));
          expect(creator.color, TileColor.green);
        });

        test('color: yellow (1)', () async {
          Movie targetMovie = TestUtilities.movie(
              leads: ["Harrison Ford", "Sally Field", "Kevin Costner"]);
          Movie guessedMovie = TestUtilities.movie(leads: [
            "Harrison Ford",
            "Leonardo DiCaprio",
            "Samuel L. Jackson"
          ]);

          CastCreator creator = CastCreator(
            targetMovie: targetMovie,
            tmdbRepository: tmdbRepository,
          );

          when(tmdbRepository.isActorInMovie("Harrison Ford", any))
              .thenAnswer((_) => Future.value(true));
          when(tmdbRepository.isActorInMovie("Leonardo DiCaprio", any))
              .thenAnswer((_) => Future.value(false));
          when(tmdbRepository.isActorInMovie("Samuel L. Jackson", any))
              .thenAnswer((_) => Future.value(false));

          await creator.compute(guessedMovie);
          verify(tmdbRepository.isActorInMovie(any, any)).called(3);
          expect(creator.color, TileColor.yellow);
        });

        test('color: yellow (2)', () async {
          Movie targetMovie = TestUtilities.movie(
              leads: ["Harrison Ford", "Sally Field", "Kevin Costner"]);
          Movie guessedMovie = TestUtilities.movie(
              leads: ["Harrison Ford", "Sally Field", "Samuel L. Jackson"]);

          CastCreator creator = CastCreator(
            targetMovie: targetMovie,
            tmdbRepository: tmdbRepository,
          );

          when(tmdbRepository.isActorInMovie("Harrison Ford", any))
              .thenAnswer((_) => Future.value(true));
          when(tmdbRepository.isActorInMovie("Sally Field", any))
              .thenAnswer((_) => Future.value(true));
          when(tmdbRepository.isActorInMovie("Samuel L. Jackson", any))
              .thenAnswer((_) => Future.value(false));

          await creator.compute(guessedMovie);
          verify(tmdbRepository.isActorInMovie(any, any)).called(3);
          expect(creator.color, TileColor.yellow);
        });

        test('color: grey', () async {
          Movie targetMovie = TestUtilities.movie(
              leads: ["Harrison Ford", "Sally Field", "Kevin Costner"]);
          Movie guessedMovie = TestUtilities.movie(
              leads: ["Matt Damon", "Bill Paxton", "Samuel L. Jackson"]);

          CastCreator creator = CastCreator(
            targetMovie: targetMovie,
            tmdbRepository: tmdbRepository,
          );

          when(tmdbRepository.isActorInMovie(any, any))
              .thenAnswer((_) => Future.value(false));

          await creator.compute(guessedMovie);
          verify(tmdbRepository.isActorInMovie(any, any)).called(3);
          expect(creator.color, TileColor.grey);
        });
      });

      group('arrows', () {
        test('arrow: not computed', () {
          Movie targetMovie = TestUtilities.movie();

          CastCreator creator = CastCreator(
            targetMovie: targetMovie,
            tmdbRepository: tmdbRepository,
          );

          expect(creator.arrow, '');
        });

        test('arrow: computed', () async {
          Movie targetMovie =
              TestUtilities.movie(genre: ["Action", "Adventure", "Comedy"]);
          Movie guessedMovie =
              TestUtilities.movie(genre: ["Sci-Fi", "Horror", "Romance"]);

          CastCreator creator = CastCreator(
            targetMovie: targetMovie,
            tmdbRepository: tmdbRepository,
          );

          await creator.compute(guessedMovie);
          expect(creator.arrow, '');
        });
      });

      group('bolded', () {
        test('bolded: not computed', () {
          Movie targetMovie = TestUtilities.movie();

          CastCreator creator = CastCreator(
            targetMovie: targetMovie,
            tmdbRepository: tmdbRepository,
          );

          expect(creator.bolded, isEmpty);
        });

        test('bolded: 0', () async {
          Movie targetMovie = TestUtilities.movie(
              leads: ["Harrison Ford", "Sally Field", "Kevin Costner"]);
          Movie guessedMovie = TestUtilities.movie(
              leads: ["Michael B. Jordan", "Uma Thurman", "Anthony Hopkins"]);

          when(tmdbRepository.isActorInMovie(any, any))
              .thenAnswer((_) => Future.value(false));

          CastCreator creator = CastCreator(
            targetMovie: targetMovie,
            tmdbRepository: tmdbRepository,
          );

          await creator.compute(guessedMovie);

          verify(tmdbRepository.isActorInMovie(any, any)).called(3);
          expect(creator.bolded, [false, false, false]);
        });

        test('bolded: 1 (first)', () async {
          Movie targetMovie = TestUtilities.movie(
              leads: ["Harrison Ford", "Steve Carrell", "Kevin Costner"]);
          Movie guessedMovie = TestUtilities.movie(
              leads: ["Harrison Ford", "Sally Field", "Samuel L. Jackson"]);

          CastCreator creator = CastCreator(
            targetMovie: targetMovie,
            tmdbRepository: tmdbRepository,
          );

          when(tmdbRepository.isActorInMovie("Harrison Ford", any))
              .thenAnswer((_) => Future.value(true));
          when(tmdbRepository.isActorInMovie("Sally Field", any))
              .thenAnswer((_) => Future.value(false));
          when(tmdbRepository.isActorInMovie("Samuel L. Jackson", any))
              .thenAnswer((_) => Future.value(false));

          await creator.compute(guessedMovie);

          verify(tmdbRepository.isActorInMovie(any, any)).called(3);
          expect(creator.bolded, [true, false, false]);
        });

        test('bolded: 1 (second)', () async {
          Movie targetMovie = TestUtilities.movie(
              leads: ["Harrison Ford", "Sally Field", "Kevin Costner"]);
          Movie guessedMovie = TestUtilities.movie(
              leads: ["Steve Carrell", "Sally Field", "Samuel L. Jackson"]);

          CastCreator creator = CastCreator(
            targetMovie: targetMovie,
            tmdbRepository: tmdbRepository,
          );

          when(tmdbRepository.isActorInMovie("Steve Carrell", any))
              .thenAnswer((_) => Future.value(false));
          when(tmdbRepository.isActorInMovie("Sally Field", any))
              .thenAnswer((_) => Future.value(true));
          when(tmdbRepository.isActorInMovie("Samuel L. Jackson", any))
              .thenAnswer((_) => Future.value(false));

          await creator.compute(guessedMovie);

          verify(tmdbRepository.isActorInMovie(any, any)).called(3);
          expect(creator.bolded, [false, true, false]);
        });

        test('bolded: 1 (third)', () async {
          Movie targetMovie = TestUtilities.movie(
              leads: ["Harrison Ford", "Kevin Costner", "Sally Field"]);
          Movie guessedMovie = TestUtilities.movie(
              leads: ["Steve Carrell", "Samuel L. Jackson", "Sally Field"]);

          CastCreator creator = CastCreator(
            targetMovie: targetMovie,
            tmdbRepository: tmdbRepository,
          );

          when(tmdbRepository.isActorInMovie("Steve Carrell", any))
              .thenAnswer((_) => Future.value(false));
          when(tmdbRepository.isActorInMovie("Samuel L. Jackson", any))
              .thenAnswer((_) => Future.value(false));
          when(tmdbRepository.isActorInMovie("Sally Field", any))
              .thenAnswer((_) => Future.value(true));

          await creator.compute(guessedMovie);

          verify(tmdbRepository.isActorInMovie(any, any)).called(3);
          expect(creator.bolded, [false, false, true]);
        });

        test('bolded: 2 (first two)', () async {
          Movie targetMovie = TestUtilities.movie(
              leads: ["Harrison Ford", "Sally Field", "Kevin Costner"]);
          Movie guessedMovie = TestUtilities.movie(
              leads: ["Harrison Ford", "Sally Field", "Samuel L. Jackson"]);

          CastCreator creator = CastCreator(
            targetMovie: targetMovie,
            tmdbRepository: tmdbRepository,
          );

          when(tmdbRepository.isActorInMovie("Harrison Ford", any))
              .thenAnswer((_) => Future.value(true));
          when(tmdbRepository.isActorInMovie("Sally Field", any))
              .thenAnswer((_) => Future.value(true));
          when(tmdbRepository.isActorInMovie("Samuel L. Jackson", any))
              .thenAnswer((_) => Future.value(false));

          await creator.compute(guessedMovie);

          verify(tmdbRepository.isActorInMovie(any, any)).called(3);
          expect(creator.bolded, [true, true, false]);
        });

        test('bolded: 2 (last two)', () async {
          Movie targetMovie = TestUtilities.movie(
              leads: ["Harrison Ford", "Sally Field", "Kevin Costner"]);
          Movie guessedMovie = TestUtilities.movie(
              leads: ["Steve Carrell", "Sally Field", "Kevin Costner"]);

          CastCreator creator = CastCreator(
            targetMovie: targetMovie,
            tmdbRepository: tmdbRepository,
          );

          when(tmdbRepository.isActorInMovie("Steve Carrell", any))
              .thenAnswer((_) => Future.value(false));
          when(tmdbRepository.isActorInMovie("Sally Field", any))
              .thenAnswer((_) => Future.value(true));
          when(tmdbRepository.isActorInMovie("Kevin Costner", any))
              .thenAnswer((_) => Future.value(true));

          await creator.compute(guessedMovie);

          verify(tmdbRepository.isActorInMovie(any, any)).called(3);
          expect(creator.bolded, [false, true, true]);
        });

        test('bolded: 2 (first and last)', () async {
          Movie targetMovie = TestUtilities.movie(
              leads: ["Harrison Ford", "Sally Field", "Kevin Costner"]);
          Movie guessedMovie = TestUtilities.movie(
              leads: ["Harrison Ford", "Samuel L. Jackson", "Kevin Costner"]);

          CastCreator creator = CastCreator(
            targetMovie: targetMovie,
            tmdbRepository: tmdbRepository,
          );

          when(tmdbRepository.isActorInMovie("Harrison Ford", any))
              .thenAnswer((_) => Future.value(true));
          when(tmdbRepository.isActorInMovie("Samuel L. Jackson", any))
              .thenAnswer((_) => Future.value(false));
          when(tmdbRepository.isActorInMovie("Kevin Costner", any))
              .thenAnswer((_) => Future.value(true));

          await creator.compute(guessedMovie);

          verify(tmdbRepository.isActorInMovie(any, any)).called(3);
          expect(creator.bolded, [true, false, true]);
        });

        test('bolded: 3', () async {
          Movie targetMovie = TestUtilities.movie(
              leads: ["Harrison Ford", "Sally Field", "Kevin Costner"]);
          Movie guessedMovie = TestUtilities.movie(
              leads: ["Harrison Ford", "Sally Field", "Kevin Costner"]);

          CastCreator creator = CastCreator(
            targetMovie: targetMovie,
            tmdbRepository: tmdbRepository,
          );

          await creator.compute(guessedMovie);

          verifyNever(tmdbRepository.isActorInMovie(any, any));
          expect(creator.bolded, isEmpty);
        });
      });
    });
  });
}
