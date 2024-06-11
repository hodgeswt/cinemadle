import 'package:cinemadle/src/bloc_utilities/tile_data/tile_data.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:tmdb_repository/tmdb_repository.dart';

import '../../../test_utilities.dart';

void main() {
  group('RevenueCreator', () {
    test('constructor', () {
      Movie targetMovie = TestUtilities.movie();

      RevenueCreator creator = RevenueCreator(targetMovie: targetMovie);

      expect(creator.targetMovie, targetMovie);
    });

    group('compute', () {
      test('revenue match', () {
        Movie targetMovie = TestUtilities.movie(revenue: 100000000);
        Movie guessedMovie = TestUtilities.movie(revenue: 100000000);

        RevenueCreator creator = RevenueCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);

        expect(creator.data, 0);
        expect(creator.isComputed, true);
      });

      test('revenue negative', () {
        Movie targetMovie = TestUtilities.movie(revenue: 50000000);
        Movie guessedMovie = TestUtilities.movie(revenue: 100000000);

        RevenueCreator creator = RevenueCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);

        expect(creator.data, -50000000);
        expect(creator.isComputed, true);
      });

      test('revenue positive', () {
        Movie targetMovie = TestUtilities.movie(revenue: 100000000);
        Movie guessedMovie = TestUtilities.movie(revenue: 50000000);

        RevenueCreator creator = RevenueCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);

        expect(creator.data, 50000000);
        expect(creator.isComputed, true);
      });
    });

    group('colors', () {
      test('green condition', () {
        Movie targetMovie = TestUtilities.movie();

        RevenueCreator creator = RevenueCreator(targetMovie: targetMovie);

        expect(creator.greenCondition(0), true);
        expect(creator.greenCondition(1), false);
        expect(creator.greenCondition(2), false);
        expect(creator.greenCondition(-2), false);
        expect(creator.greenCondition(-1), false);
      });

      test('yellow condition', () {
        Movie targetMovie = TestUtilities.movie();

        RevenueCreator creator = RevenueCreator(targetMovie: targetMovie);

        expect(creator.yellowCondition(0), true);
        expect(creator.yellowCondition(1), true);
        expect(creator.yellowCondition(2), true);
        expect(creator.yellowCondition(50000000), true);
        expect(creator.yellowCondition(50000001), false);
        expect(creator.yellowCondition(-50000000), true);
        expect(creator.yellowCondition(-50000001), false);
        expect(creator.yellowCondition(-100000000), false);
        expect(creator.yellowCondition(100000000), false);
      });
    });

    group('arrows', () {
      test('single down arrow condition', () {
        Movie targetMovie = TestUtilities.movie();

        RevenueCreator creator = RevenueCreator(targetMovie: targetMovie);

        expect(creator.singleDownArrowCondition(0), false);
        expect(creator.singleDownArrowCondition(1), false);
        expect(creator.singleDownArrowCondition(2), false);
        expect(creator.singleDownArrowCondition(50000000), false);
        expect(creator.singleDownArrowCondition(-50000000), true);
        expect(creator.singleDownArrowCondition(-25000000), true);
        expect(creator.singleDownArrowCondition(-1), true);
        expect(creator.singleDownArrowCondition(-50000001), false);
      });

      test('double down arrow condition', () {
        Movie targetMovie = TestUtilities.movie();

        RevenueCreator creator = RevenueCreator(targetMovie: targetMovie);

        expect(creator.doubleDownArrowCondition(0), false);
        expect(creator.doubleDownArrowCondition(1), false);
        expect(creator.doubleDownArrowCondition(2), false);
        expect(creator.doubleDownArrowCondition(50000000), false);
        expect(creator.doubleDownArrowCondition(-50000000), false);
        expect(creator.doubleDownArrowCondition(-50000001), true);
        expect(creator.doubleDownArrowCondition(-100000000), true);
      });

      test('single up arrow condition', () {
        Movie targetMovie = TestUtilities.movie();

        RevenueCreator creator = RevenueCreator(targetMovie: targetMovie);

        expect(creator.singleUpArrowCondition(0), false);
        expect(creator.singleUpArrowCondition(1), true);
        expect(creator.singleUpArrowCondition(2), true);
        expect(creator.singleUpArrowCondition(50000000), true);
        expect(creator.singleUpArrowCondition(50000001), false);
        expect(creator.singleUpArrowCondition(100000000), false);
        expect(creator.singleUpArrowCondition(-50000000), false);
        expect(creator.singleUpArrowCondition(-25000000), false);
        expect(creator.singleUpArrowCondition(-1), false);
      });

      test('double up arrow condition', () {
        Movie targetMovie = TestUtilities.movie();

        RevenueCreator creator = RevenueCreator(targetMovie: targetMovie);

        expect(creator.doubleUpArrowCondition(0), false);
        expect(creator.doubleUpArrowCondition(1), false);
        expect(creator.doubleUpArrowCondition(2), false);
        expect(creator.doubleUpArrowCondition(-50000000), false);
        expect(creator.doubleUpArrowCondition(50000000), false);
        expect(creator.doubleUpArrowCondition(50000001), true);
        expect(creator.doubleUpArrowCondition(100000000), true);
      });
    });

    group('getters', () {
      test('color: green', () {
        Movie targetMovie = TestUtilities.movie(revenue: 50000000);
        Movie guessedMovie = TestUtilities.movie(revenue: 50000000);

        RevenueCreator creator = RevenueCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);
        expect(creator.color, TileColor.green);
      });

      test('color: yellow', () {
        Movie targetMovie = TestUtilities.movie(revenue: 100000000);
        Movie guessedMovie = TestUtilities.movie(revenue: 50000000);

        RevenueCreator creator = RevenueCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);
        expect(creator.color, TileColor.yellow);

        targetMovie = TestUtilities.movie(revenue: 100000000);
        guessedMovie = TestUtilities.movie(revenue: 150000000);
        creator = RevenueCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);
        expect(creator.color, TileColor.yellow);
      });

      test('color: grey', () {
        Movie targetMovie = TestUtilities.movie(revenue: 100000000);
        Movie guessedMovie = TestUtilities.movie(revenue: 20);

        RevenueCreator creator = RevenueCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);
        expect(creator.color, TileColor.grey);

        targetMovie = TestUtilities.movie(revenue: 100000000);
        guessedMovie = TestUtilities.movie(revenue: 1500000000);
        creator = RevenueCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);
        expect(creator.color, TileColor.grey);
      });

      test('arrow: not computed', () {
        Movie targetMovie = TestUtilities.movie();

        RevenueCreator creator = RevenueCreator(targetMovie: targetMovie);

        expect(creator.arrow, '');
      });

      test('arrow: computed', () {
        Movie targetMovie = TestUtilities.movie(revenue: 100000000);
        Movie guessedMovie = TestUtilities.movie(revenue: 50000000);

        RevenueCreator creator = RevenueCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);
        expect(creator.arrow, '↑');

        targetMovie = TestUtilities.movie(revenue: 100000000);
        guessedMovie = TestUtilities.movie(revenue: 150000000);
        creator = RevenueCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);
        expect(creator.arrow, '↓');

        targetMovie = TestUtilities.movie(revenue: 100000000);
        guessedMovie = TestUtilities.movie(revenue: 100000000);
        creator = RevenueCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);
        expect(creator.arrow, '');

        targetMovie = TestUtilities.movie(revenue: 100000000);
        guessedMovie = TestUtilities.movie(revenue: 500000000);
        creator = RevenueCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);
        expect(creator.arrow, '↓↓');

        targetMovie = TestUtilities.movie(revenue: 500000000);
        guessedMovie = TestUtilities.movie(revenue: 100000000);
        creator = RevenueCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);
        expect(creator.arrow, '↑↑');
      });
    });

    group('sequences', () {
      Movie targetMovie = TestUtilities.movie(revenue: 100000000);

      test('two yellows then green', () {
        Movie guessedMovie = TestUtilities.movie(revenue: 50000000);

        RevenueCreator creator = RevenueCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);
        expect(creator.color, TileColor.yellow);
        expect(creator.arrow, '↑');

        guessedMovie = TestUtilities.movie(revenue: 150000000);
        creator.compute(guessedMovie);
        expect(creator.color, TileColor.yellow);
        expect(creator.arrow, '↓');

        guessedMovie = TestUtilities.movie(revenue: 100000000);
        creator.compute(guessedMovie);
        expect(creator.color, TileColor.green);
        expect(creator.arrow, '');
      });

      test('two yellows then grey', () {
        Movie guessedMovie = TestUtilities.movie(revenue: 50000000);

        RevenueCreator creator = RevenueCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);
        expect(creator.color, TileColor.yellow);
        expect(creator.arrow, '↑');

        guessedMovie = TestUtilities.movie(revenue: 1500000000);
        creator.compute(guessedMovie);
        expect(creator.color, TileColor.grey);
        expect(creator.arrow, '↓↓');
      });

      test('two yellows then grey then green', () {
        Movie guessedMovie = TestUtilities.movie(revenue: 50000000);

        RevenueCreator creator = RevenueCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);
        expect(creator.color, TileColor.yellow);
        expect(creator.arrow, '↑');

        guessedMovie = TestUtilities.movie(revenue: 1500000000);
        creator.compute(guessedMovie);
        expect(creator.color, TileColor.grey);
        expect(creator.arrow, '↓↓');

        guessedMovie = TestUtilities.movie(revenue: 100000000);
        creator.compute(guessedMovie);
        expect(creator.color, TileColor.green);
        expect(creator.arrow, '');
      });

      test('two greens then grey then yellow', () {
        Movie guessedMovie = TestUtilities.movie(revenue: 100000000);

        RevenueCreator creator = RevenueCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);
        expect(creator.color, TileColor.green);
        expect(creator.arrow, '');

        guessedMovie = TestUtilities.movie(revenue: 100000000);
        creator.compute(guessedMovie);
        expect(creator.color, TileColor.green);
        expect(creator.arrow, '');

        guessedMovie = TestUtilities.movie(revenue: 1500000000);
        creator.compute(guessedMovie);
        expect(creator.color, TileColor.grey);
        expect(creator.arrow, '↓↓');

        guessedMovie = TestUtilities.movie(revenue: 100000025);
        creator.compute(guessedMovie);
        expect(creator.color, TileColor.yellow);
        expect(creator.arrow, '↓');
      });
    });
  });
}
