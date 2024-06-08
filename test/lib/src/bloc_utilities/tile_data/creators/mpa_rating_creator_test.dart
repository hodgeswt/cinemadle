import 'package:cinemadle/src/bloc_utilities/tile_data/tile_data.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:tmdb_repository/tmdb_repository.dart';

import '../../../test_utilities.dart';

void main() {
  group('MpaRatingCreator', () {
    test('constructor', () {
      Movie targetMovie = TestUtilities.movie();

      MpaRatingCreator creator = MpaRatingCreator(targetMovie: targetMovie);

      expect(creator.targetMovie, targetMovie);
    });

    group('compute', () {
      test('ratings', () {
        List<TestData> data = [
          TestData<String, int>(expected: 0, input1: 'G', input2: 'G'),
          TestData<String, int>(expected: 0, input1: 'PG', input2: 'PG'),
          TestData<String, int>(expected: 0, input1: 'PG-13', input2: 'PG-13'),
          TestData<String, int>(expected: 0, input1: 'R', input2: 'R'),
          TestData<String, int>(expected: 0, input1: 'NC-17', input2: 'NC-17'),
          TestData<String, int>(expected: 0, input1: 'NR', input2: 'NR'),
          TestData<String, int>(expected: 0, input1: '', input2: ''),
          TestData<String, int>(expected: -1, input1: 'G', input2: 'PG'),
          TestData<String, int>(expected: -1, input1: 'PG', input2: 'PG-13'),
          TestData<String, int>(expected: -1, input1: 'PG-13', input2: 'R'),
          TestData<String, int>(expected: -1, input1: 'R', input2: 'NC-17'),
          TestData<String, int>(expected: -1, input1: 'NC-17', input2: 'NR'),
          TestData<String, int>(expected: -2, input1: 'G', input2: 'PG-13'),
          TestData<String, int>(expected: -2, input1: 'PG', input2: 'R'),
          TestData<String, int>(expected: -2, input1: 'PG-13', input2: 'NC-17'),
          TestData<String, int>(expected: -2, input1: 'R', input2: 'NR'),
          TestData<String, int>(expected: -3, input1: 'G', input2: 'R'),
          TestData<String, int>(expected: -3, input1: 'PG', input2: 'NC-17'),
          TestData<String, int>(expected: -3, input1: 'PG-13', input2: 'NR'),
          TestData<String, int>(expected: -4, input1: 'G', input2: 'NC-17'),
          TestData<String, int>(expected: -4, input1: 'PG', input2: 'NR'),
          TestData<String, int>(expected: -5, input1: 'G', input2: 'NR'),
          TestData<String, int>(expected: 1, input1: 'PG', input2: 'G'),
          TestData<String, int>(expected: 1, input1: 'PG-13', input2: 'PG'),
          TestData<String, int>(expected: 1, input1: 'R', input2: 'PG-13'),
          TestData<String, int>(expected: 1, input1: 'NC-17', input2: 'R'),
          TestData<String, int>(expected: 1, input1: 'NR', input2: 'NC-17'),
          TestData<String, int>(expected: 2, input1: 'PG-13', input2: 'G'),
          TestData<String, int>(expected: 2, input1: 'R', input2: 'PG'),
          TestData<String, int>(expected: 2, input1: 'NC-17', input2: 'PG-13'),
          TestData<String, int>(expected: 2, input1: 'NR', input2: 'R'),
          TestData<String, int>(expected: 3, input1: 'R', input2: 'G'),
          TestData<String, int>(expected: 3, input1: 'NC-17', input2: 'PG'),
          TestData<String, int>(expected: 3, input1: 'NR', input2: 'PG-13'),
          TestData<String, int>(expected: 4, input1: 'NC-17', input2: 'G'),
          TestData<String, int>(expected: 4, input1: 'NR', input2: 'PG'),
          TestData<String, int>(expected: 5, input1: 'NR', input2: 'G'),
        ];

        for (TestData testData in data) {
          Movie targetMovie = TestUtilities.movie(mpaRating: testData.input1);
          Movie guessedMovie = TestUtilities.movie(mpaRating: testData.input2);

          MpaRatingCreator creator = MpaRatingCreator(targetMovie: targetMovie);

          creator.compute(guessedMovie);

          expect(creator.data, testData.expected, reason: testData.toString());
          expect(creator.isComputed, true, reason: testData.toString());
        }
      });
    });

    group('colors', () {
      test('greenCondition', () {
        Movie targetMovie = TestUtilities.movie();

        MpaRatingCreator creator = MpaRatingCreator(targetMovie: targetMovie);

        expect(creator.greenCondition(-5), false);
        expect(creator.greenCondition(-4), false);
        expect(creator.greenCondition(-3), false);
        expect(creator.greenCondition(-2), false);
        expect(creator.greenCondition(-1), false);
        expect(creator.greenCondition(0), true);
        expect(creator.greenCondition(1), false);
        expect(creator.greenCondition(2), false);
        expect(creator.greenCondition(3), false);
        expect(creator.greenCondition(4), false);
        expect(creator.greenCondition(5), false);
      });

      test('yellowCondition', () {
        Movie targetMovie = TestUtilities.movie();

        MpaRatingCreator creator = MpaRatingCreator(targetMovie: targetMovie);

        expect(creator.yellowCondition(-5), false);
        expect(creator.yellowCondition(-4), false);
        expect(creator.yellowCondition(-3), false);
        expect(creator.yellowCondition(-2), false);
        expect(creator.yellowCondition(-1), true);
        expect(creator.yellowCondition(0), true);
        expect(creator.yellowCondition(1), true);
        expect(creator.yellowCondition(2), false);
        expect(creator.yellowCondition(3), false);
        expect(creator.yellowCondition(4), false);
        expect(creator.yellowCondition(5), false);
      });
    });

    group('arrows', () {
      test('singleDownArrowCondition', () {
        Movie targetMovie = TestUtilities.movie();

        MpaRatingCreator creator = MpaRatingCreator(targetMovie: targetMovie);

        expect(creator.singleDownArrowCondition(-5), false);
        expect(creator.singleDownArrowCondition(-4), false);
        expect(creator.singleDownArrowCondition(-3), false);
        expect(creator.singleDownArrowCondition(-2), false);
        expect(creator.singleDownArrowCondition(-1), false);
        expect(creator.singleDownArrowCondition(0), false);
        expect(creator.singleDownArrowCondition(1), false);
        expect(creator.singleDownArrowCondition(2), false);
        expect(creator.singleDownArrowCondition(3), false);
        expect(creator.singleDownArrowCondition(4), false);
        expect(creator.singleDownArrowCondition(5), false);
      });

      test('doubleDownArrowCondition', () {
        Movie targetMovie = TestUtilities.movie();

        MpaRatingCreator creator = MpaRatingCreator(targetMovie: targetMovie);

        expect(creator.doubleDownArrowCondition(-5), false);
        expect(creator.doubleDownArrowCondition(-4), false);
        expect(creator.doubleDownArrowCondition(-3), false);
        expect(creator.doubleDownArrowCondition(-2), false);
        expect(creator.doubleDownArrowCondition(-1), false);
        expect(creator.doubleDownArrowCondition(0), false);
        expect(creator.doubleDownArrowCondition(1), false);
        expect(creator.doubleDownArrowCondition(2), false);
        expect(creator.doubleDownArrowCondition(3), false);
        expect(creator.doubleDownArrowCondition(4), false);
        expect(creator.doubleDownArrowCondition(5), false);
      });

      test('singleUpArrowCondition', () {
        Movie targetMovie = TestUtilities.movie();

        MpaRatingCreator creator = MpaRatingCreator(targetMovie: targetMovie);

        expect(creator.singleUpArrowCondition(-5), false);
        expect(creator.singleUpArrowCondition(-4), false);
        expect(creator.singleUpArrowCondition(-3), false);
        expect(creator.singleUpArrowCondition(-2), false);
        expect(creator.singleUpArrowCondition(-1), false);
        expect(creator.singleUpArrowCondition(0), false);
        expect(creator.singleUpArrowCondition(1), false);
        expect(creator.singleUpArrowCondition(2), false);
        expect(creator.singleUpArrowCondition(3), false);
        expect(creator.singleUpArrowCondition(4), false);
        expect(creator.singleUpArrowCondition(5), false);
      });

      test('doubleUpArrowCondition', () {
        Movie targetMovie = TestUtilities.movie();

        MpaRatingCreator creator = MpaRatingCreator(targetMovie: targetMovie);

        expect(creator.doubleUpArrowCondition(-5), false);
        expect(creator.doubleUpArrowCondition(-4), false);
        expect(creator.doubleUpArrowCondition(-3), false);
        expect(creator.doubleUpArrowCondition(-2), false);
        expect(creator.doubleUpArrowCondition(-1), false);
        expect(creator.doubleUpArrowCondition(0), false);
        expect(creator.doubleUpArrowCondition(1), false);
        expect(creator.doubleUpArrowCondition(2), false);
        expect(creator.doubleUpArrowCondition(3), false);
        expect(creator.doubleUpArrowCondition(4), false);
        expect(creator.doubleUpArrowCondition(5), false);
      });

      test('arrow', () {
        Movie targetMovie = TestUtilities.movie();

        MpaRatingCreator creator = MpaRatingCreator(targetMovie: targetMovie);

        expect(creator.arrow, '');
      });
    });

    group('getters', () {
      group('colors', () {
        test('color: green', () {
          List<TestData<String, TileColor>> data = [
            TestData<String, TileColor>(
              expected: TileColor.green,
              input1: 'G',
              input2: 'G',
            ),
            TestData<String, TileColor>(
              expected: TileColor.green,
              input1: 'PG',
              input2: 'PG',
            ),
            TestData<String, TileColor>(
              expected: TileColor.green,
              input1: 'PG-13',
              input2: 'PG-13',
            ),
            TestData<String, TileColor>(
              expected: TileColor.green,
              input1: 'R',
              input2: 'R',
            ),
            TestData<String, TileColor>(
              expected: TileColor.green,
              input1: 'NC-17',
              input2: 'NC-17',
            ),
            TestData<String, TileColor>(
              expected: TileColor.green,
              input1: 'NR',
              input2: 'NR',
            ),
          ];

          for (TestData testData in data) {
            Movie targetMovie = TestUtilities.movie(mpaRating: testData.input1);
            Movie guessedMovie =
                TestUtilities.movie(mpaRating: testData.input2);

            MpaRatingCreator creator =
                MpaRatingCreator(targetMovie: targetMovie);

            creator.compute(guessedMovie);

            expect(creator.color, testData.expected,
                reason: testData.toString());
          }
        });

        test('color: yellow', () {
          List<TestData<String, TileColor>> data = [
            TestData<String, TileColor>(
              expected: TileColor.yellow,
              input1: 'G',
              input2: 'PG',
            ),
            TestData<String, TileColor>(
              expected: TileColor.yellow,
              input1: 'PG',
              input2: 'PG-13',
            ),
            TestData<String, TileColor>(
              expected: TileColor.yellow,
              input1: 'PG-13',
              input2: 'R',
            ),
            TestData<String, TileColor>(
              expected: TileColor.yellow,
              input1: 'R',
              input2: 'NC-17',
            ),
            TestData<String, TileColor>(
              expected: TileColor.yellow,
              input1: 'NC-17',
              input2: 'NR',
            ),
            TestData<String, TileColor>(
              expected: TileColor.yellow,
              input1: 'PG',
              input2: 'G',
            ),
            TestData<String, TileColor>(
              expected: TileColor.yellow,
              input1: 'PG-13',
              input2: 'PG',
            ),
            TestData<String, TileColor>(
              expected: TileColor.yellow,
              input1: 'R',
              input2: 'PG-13',
            ),
            TestData<String, TileColor>(
              expected: TileColor.yellow,
              input1: 'NC-17',
              input2: 'R',
            ),
            TestData<String, TileColor>(
              expected: TileColor.yellow,
              input1: 'NR',
              input2: 'NC-17',
            ),
          ];

          for (TestData testData in data) {
            Movie targetMovie = TestUtilities.movie(mpaRating: testData.input1);
            Movie guessedMovie =
                TestUtilities.movie(mpaRating: testData.input2);

            MpaRatingCreator creator =
                MpaRatingCreator(targetMovie: targetMovie);

            creator.compute(guessedMovie);

            expect(creator.color, testData.expected,
                reason: testData.toString());
          }
        });

        test('color: grey', () {
          List<TestData<String, TileColor>> data = [
            TestData<String, TileColor>(
              expected: TileColor.grey,
              input1: 'G',
              input2: 'R',
            ),
            TestData<String, TileColor>(
              expected: TileColor.grey,
              input1: 'PG',
              input2: 'NC-17',
            ),
            TestData<String, TileColor>(
              expected: TileColor.grey,
              input1: 'PG-13',
              input2: 'NR',
            ),
            TestData<String, TileColor>(
              expected: TileColor.grey,
              input1: 'R',
              input2: 'G',
            ),
            TestData<String, TileColor>(
              expected: TileColor.grey,
              input1: 'NC-17',
              input2: 'PG',
            ),
            TestData<String, TileColor>(
              expected: TileColor.grey,
              input1: 'NR',
              input2: 'PG-13',
            ),
            TestData<String, TileColor>(
              expected: TileColor.grey,
              input1: 'G',
              input2: 'NR',
            ),
            TestData<String, TileColor>(
              expected: TileColor.grey,
              input1: 'PG',
              input2: 'NC-17',
            ),
            TestData<String, TileColor>(
              expected: TileColor.grey,
              input1: 'PG-13',
              input2: 'G',
            ),
            TestData<String, TileColor>(
              expected: TileColor.grey,
              input1: 'R',
              input2: 'G',
            ),
            TestData<String, TileColor>(
              expected: TileColor.grey,
              input1: 'NC-17',
              input2: 'PG',
            ),
            TestData<String, TileColor>(
              expected: TileColor.grey,
              input1: 'NR',
              input2: 'PG-13',
            ),
          ];

          for (TestData testData in data) {
            Movie targetMovie = TestUtilities.movie(mpaRating: testData.input1);
            Movie guessedMovie =
                TestUtilities.movie(mpaRating: testData.input2);

            MpaRatingCreator creator =
                MpaRatingCreator(targetMovie: targetMovie);

            creator.compute(guessedMovie);

            expect(creator.color, testData.expected,
                reason: testData.toString());
          }
        });
      });

      group('arrows', () {
        test('arrow: not computed', () {
          Movie targetMovie = TestUtilities.movie();

          MpaRatingCreator creator = MpaRatingCreator(targetMovie: targetMovie);

          expect(creator.arrow, '');
        });

        test('arrow: computed', () {
          Movie targetMovie = TestUtilities.movie(mpaRating: 'G');
          Movie guessedMovie = TestUtilities.movie(mpaRating: 'R');

          MpaRatingCreator creator = MpaRatingCreator(targetMovie: targetMovie);

          creator.compute(guessedMovie);
          expect(creator.arrow, '');
        });
      });
    });
  });
}
