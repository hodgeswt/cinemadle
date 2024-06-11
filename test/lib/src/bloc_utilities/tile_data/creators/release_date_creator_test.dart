import 'package:cinemadle/src/bloc_utilities/tile_data/tile_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tmdb_repository/tmdb_repository.dart';

import '../../../test_utilities.dart';

void main() {
  group('ReleaseDateCreator', () {
    test('compute', () {
      List<TestData<String, int>> data = [
        TestData<String, int>(
          expected: 0,
          input1: '2021-01-01',
          input2: '2021-01-01',
        ),
        TestData<String, int>(
          expected: 0,
          input1: '2021-02-01',
          input2: '2021-01-01',
        ),
        TestData<String, int>(
          expected: 0,
          input1: '2021-01-01',
          input2: '2021-12-01',
        ),
        TestData<String, int>(
          expected: 1,
          input1: '2022-01-01',
          input2: '2021-12-31',
        ),
        TestData<String, int>(
          expected: 1,
          input1: '2022-01-01',
          input2: '2021-03-07',
        ),
        TestData<String, int>(
          expected: -1,
          input1: '2021-12-31',
          input2: '2022-01-01',
        ),
        TestData<String, int>(
          expected: -1,
          input1: '2021-03-07',
          input2: '2022-01-01',
        ),
        TestData<String, int>(
          expected: -2,
          input1: '2021-03-07',
          input2: '2023-01-01',
        ),
        TestData<String, int>(
          expected: 2,
          input1: '2023-01-01',
          input2: '2021-03-07',
        ),
        TestData<String, int>(
          expected: -21,
          input1: '2000-01-01',
          input2: '2021-01-01',
        ),
        TestData<String, int>(
          expected: 21,
          input1: '2021-01-01',
          input2: '2000-01-01',
        ),
        TestData<String, int>(
          expected: -21,
          input1: '2000-01-01',
          input2: '2021-01-01',
        ),
      ];

      for (TestData<String, int> item in data) {
        ReleaseDateCreator creator = ReleaseDateCreator(
            targetMovie: TestUtilities.movie(releaseDate: item.input1));

        Movie guessedMovie = TestUtilities.movie(releaseDate: item.input2);

        creator.compute(guessedMovie);

        expect(creator.data, item.expected, reason: item.toString());
        expect(creator.isComputed, true, reason: item.toString());
      }
    });

    group('getters', () {
      group('colors', () {
        test('green condition', () {
          ReleaseDateCreator creator = ReleaseDateCreator(
              targetMovie: TestUtilities.movie(releaseDate: '2021-01-01'));

          Movie guessedMovie = TestUtilities.movie(releaseDate: '2021-03-01');

          creator.compute(guessedMovie);

          expect(creator.color, TileColor.green);
          expect(creator.isComputed, true);

          guessedMovie = TestUtilities.movie(releaseDate: '2021-11-01');

          creator.compute(guessedMovie);

          expect(creator.color, TileColor.green);
          expect(creator.isComputed, true);
        });

        test('yellow condition', () {
          ReleaseDateCreator creator = ReleaseDateCreator(
              targetMovie: TestUtilities.movie(releaseDate: '2021-01-01'));

          Movie guessedMovie = TestUtilities.movie(releaseDate: '2023-01-06');

          creator.compute(guessedMovie);

          expect(creator.color, TileColor.yellow);
          expect(creator.isComputed, true);

          guessedMovie = TestUtilities.movie(releaseDate: '2019-12-31');

          creator.compute(guessedMovie);

          expect(creator.color, TileColor.yellow);
          expect(creator.isComputed, true);
        });
      });

      group('arrows', () {
        test('arrow: not computed', () {
          Movie targetMovie = TestUtilities.movie();

          ReleaseDateCreator creator =
              ReleaseDateCreator(targetMovie: targetMovie);

          expect(creator.arrow, '');
        });

        test('arrow: computed', () {
          List<TestData<String, String>> data = [
            TestData<String, String>(
              expected: '',
              input1: '2021-01-01',
              input2: '2021-01-01',
            ),
            TestData<String, String>(
              expected: '↑',
              input1: '2021-01-01',
              input2: '2020-01-01',
            ),
            TestData<String, String>(
              expected: '↓',
              input1: '2021-01-01',
              input2: '2022-01-01',
            ),
            TestData<String, String>(
              expected: '↓↓',
              input1: '2000-01-01',
              input2: '2023-01-01',
            ),
            TestData<String, String>(
              expected: '↑↑',
              input1: '2023-01-01',
              input2: '2000-01-01',
            ),
          ];

          for (TestData<String, String> item in data) {
            ReleaseDateCreator creator = ReleaseDateCreator(
                targetMovie: TestUtilities.movie(releaseDate: item.input1));

            Movie guessedMovie = TestUtilities.movie(releaseDate: item.input2);

            creator.compute(guessedMovie);

            expect(creator.arrow, item.expected, reason: item.toString());
          }
        });
      });
    });
  });
}
