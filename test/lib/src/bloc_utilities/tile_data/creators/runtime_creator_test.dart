import 'package:cinemadle/src/bloc_utilities/tile_data/tile_data.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:tmdb_repository/tmdb_repository.dart';

import '../../../test_utilities.dart';

void main() {
  group('RuntimeCreator', () {
    test('constructor', () {
      Movie targetMovie = TestUtilities.movie();

      RuntimeCreator creator = RuntimeCreator(targetMovie: targetMovie);

      expect(creator.targetMovie, targetMovie);
    });

    group('compute', () {
      test('revenue match', () {
        Movie targetMovie = TestUtilities.movie(runtime: 120);
        Movie guessedMovie = TestUtilities.movie(runtime: 120);

        RuntimeCreator creator = RuntimeCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);

        expect(creator.data, 0);
        expect(creator.isComputed, true);
      });

      test('revenue negative', () {
        Movie targetMovie = TestUtilities.movie(runtime: 100);
        Movie guessedMovie = TestUtilities.movie(runtime: 120);

        RuntimeCreator creator = RuntimeCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);

        expect(creator.data, -20);
        expect(creator.isComputed, true);
      });

      test('revenue positive', () {
        Movie targetMovie = TestUtilities.movie(runtime: 120);
        Movie guessedMovie = TestUtilities.movie(runtime: 100);

        RuntimeCreator creator = RuntimeCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);

        expect(creator.data, 20);
        expect(creator.isComputed, true);
      });
    });

    group('colors', () {
      test('green condition', () {
        Movie targetMovie = TestUtilities.movie();

        RuntimeCreator creator = RuntimeCreator(targetMovie: targetMovie);

        expect(creator.greenCondition(0), true);
        expect(creator.greenCondition(1), false);
        expect(creator.greenCondition(2), false);
        expect(creator.greenCondition(-2), false);
        expect(creator.greenCondition(-1), false);
      });

      test('yellow condition', () {
        Movie targetMovie = TestUtilities.movie();

        RuntimeCreator creator = RuntimeCreator(targetMovie: targetMovie);

        expect(creator.yellowCondition(0), true);
        expect(creator.yellowCondition(1), true);
        expect(creator.yellowCondition(2), true);
        expect(creator.yellowCondition(20), true);
        expect(creator.yellowCondition(21), false);
        expect(creator.yellowCondition(100), false);
        expect(creator.yellowCondition(-1), true);
        expect(creator.yellowCondition(-2), true);
        expect(creator.yellowCondition(-20), true);
        expect(creator.yellowCondition(-21), false);
        expect(creator.yellowCondition(-100), false);
      });
    });

    group('arrows', () {
      test('single down arrow condition', () {
        Movie targetMovie = TestUtilities.movie();

        RuntimeCreator creator = RuntimeCreator(targetMovie: targetMovie);

        expect(creator.singleDownArrowCondition(0), false);
        expect(creator.singleDownArrowCondition(1), false);
        expect(creator.singleDownArrowCondition(2), false);
        expect(creator.singleDownArrowCondition(10), false);
        expect(creator.singleDownArrowCondition(-10), true);
        expect(creator.singleDownArrowCondition(-5), true);
        expect(creator.singleDownArrowCondition(-11), true);
        expect(creator.singleDownArrowCondition(-20), true);
        expect(creator.singleDownArrowCondition(-21), false);
        expect(creator.singleDownArrowCondition(-120), false);
      });

      test('double down arrow condition', () {
        Movie targetMovie = TestUtilities.movie();

        RuntimeCreator creator = RuntimeCreator(targetMovie: targetMovie);

        expect(creator.doubleDownArrowCondition(0), false);
        expect(creator.doubleDownArrowCondition(1), false);
        expect(creator.doubleDownArrowCondition(2), false);
        expect(creator.doubleDownArrowCondition(10), false);
        expect(creator.doubleDownArrowCondition(-10), false);
        expect(creator.doubleDownArrowCondition(-20), false);
        expect(creator.doubleDownArrowCondition(-11), false);
        expect(creator.doubleDownArrowCondition(-21), true);
        expect(creator.doubleDownArrowCondition(-120), true);
      });

      test('single up arrow condition', () {
        Movie targetMovie = TestUtilities.movie();

        RuntimeCreator creator = RuntimeCreator(targetMovie: targetMovie);

        expect(creator.singleUpArrowCondition(0), false);
        expect(creator.singleUpArrowCondition(1), true);
        expect(creator.singleUpArrowCondition(2), true);
        expect(creator.singleUpArrowCondition(10), true);
        expect(creator.singleUpArrowCondition(19), true);
        expect(creator.singleUpArrowCondition(20), true);
        expect(creator.singleUpArrowCondition(21), false);
        expect(creator.singleUpArrowCondition(-10), false);
        expect(creator.singleUpArrowCondition(-5), false);
        expect(creator.singleUpArrowCondition(-11), false);
        expect(creator.singleUpArrowCondition(-20), false);
        expect(creator.singleUpArrowCondition(-21), false);
        expect(creator.singleUpArrowCondition(-120), false);
      });

      test('double up arrow condition', () {
        Movie targetMovie = TestUtilities.movie();

        RuntimeCreator creator = RuntimeCreator(targetMovie: targetMovie);

        expect(creator.doubleUpArrowCondition(0), false);
        expect(creator.doubleUpArrowCondition(1), false);
        expect(creator.doubleUpArrowCondition(2), false);
        expect(creator.doubleUpArrowCondition(10), false);
        expect(creator.doubleUpArrowCondition(19), false);
        expect(creator.doubleUpArrowCondition(20), false);
        expect(creator.doubleUpArrowCondition(21), true);
        expect(creator.doubleUpArrowCondition(40), true);
        expect(creator.doubleUpArrowCondition(400), true);
        expect(creator.doubleUpArrowCondition(-10), false);
        expect(creator.doubleUpArrowCondition(-20), false);
        expect(creator.doubleUpArrowCondition(-11), false);
        expect(creator.doubleUpArrowCondition(-21), false);
        expect(creator.doubleUpArrowCondition(-120), false);
      });
    });

    group('getters', () {
      test('color: green', () {
        Movie targetMovie = TestUtilities.movie(runtime: 100);
        Movie guessedMovie = TestUtilities.movie(runtime: 100);

        RuntimeCreator creator = RuntimeCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);
        expect(creator.color, TileColor.green);
      });

      test('color: yellow', () {
        Movie targetMovie = TestUtilities.movie(runtime: 120);
        Movie guessedMovie = TestUtilities.movie(runtime: 100);

        RuntimeCreator creator = RuntimeCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);
        expect(creator.color, TileColor.yellow);

        targetMovie = TestUtilities.movie(runtime: 120);
        guessedMovie = TestUtilities.movie(runtime: 130);
        creator = RuntimeCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);
        expect(creator.color, TileColor.yellow);
      });

      test('color: grey', () {
        Movie targetMovie = TestUtilities.movie(runtime: 120);
        Movie guessedMovie = TestUtilities.movie(runtime: 20);

        RuntimeCreator creator = RuntimeCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);
        expect(creator.color, TileColor.grey);

        targetMovie = TestUtilities.movie(runtime: 120);
        guessedMovie = TestUtilities.movie(runtime: 145);
        creator = RuntimeCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);
        expect(creator.color, TileColor.grey);
      });

      test('arrow: not computed', () {
        Movie targetMovie = TestUtilities.movie();

        RuntimeCreator creator = RuntimeCreator(targetMovie: targetMovie);

        expect(creator.arrow, '');
      });

      test('arrow: computed', () {
        Movie targetMovie = TestUtilities.movie(runtime: 120);
        Movie guessedMovie = TestUtilities.movie(runtime: 100);

        RuntimeCreator creator = RuntimeCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);
        expect(creator.arrow, '↑');

        targetMovie = TestUtilities.movie(runtime: 120);
        guessedMovie = TestUtilities.movie(runtime: 130);
        creator = RuntimeCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);
        expect(creator.arrow, '↓');

        targetMovie = TestUtilities.movie(runtime: 120);
        guessedMovie = TestUtilities.movie(runtime: 120);
        creator = RuntimeCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);
        expect(creator.arrow, '');

        targetMovie = TestUtilities.movie(runtime: 120);
        guessedMovie = TestUtilities.movie(runtime: 145);
        creator = RuntimeCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);
        expect(creator.arrow, '↓↓');

        targetMovie = TestUtilities.movie(runtime: 120);
        guessedMovie = TestUtilities.movie(runtime: 99);
        creator = RuntimeCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);
        expect(creator.arrow, '↑↑');
      });
    });

    group('sequences', () {
      Movie targetMovie = TestUtilities.movie(runtime: 120);

      test('two yellows then green', () {
        Movie guessedMovie = TestUtilities.movie(runtime: 100);

        RuntimeCreator creator = RuntimeCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);
        expect(creator.color, TileColor.yellow);
        expect(creator.arrow, '↑');

        guessedMovie = TestUtilities.movie(runtime: 130);
        creator.compute(guessedMovie);
        expect(creator.color, TileColor.yellow);
        expect(creator.arrow, '↓');

        guessedMovie = TestUtilities.movie(runtime: 120);
        creator.compute(guessedMovie);
        expect(creator.color, TileColor.green);
        expect(creator.arrow, '');
      });

      test('two yellows then grey', () {
        Movie guessedMovie = TestUtilities.movie(runtime: 100);

        RuntimeCreator creator = RuntimeCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);
        expect(creator.color, TileColor.yellow);
        expect(creator.arrow, '↑');

        guessedMovie = TestUtilities.movie(runtime: 130);
        creator.compute(guessedMovie);
        expect(creator.color, TileColor.yellow);
        expect(creator.arrow, '↓');

        guessedMovie = TestUtilities.movie(runtime: 145);
        creator.compute(guessedMovie);
        expect(creator.color, TileColor.grey);
        expect(creator.arrow, '↓↓');
      });

      test('two greys then yellow then green', () {
        Movie guessedMovie = TestUtilities.movie(runtime: 20);

        RuntimeCreator creator = RuntimeCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);
        expect(creator.color, TileColor.grey);
        expect(creator.arrow, '↑↑');

        guessedMovie = TestUtilities.movie(runtime: 145);
        creator.compute(guessedMovie);
        expect(creator.color, TileColor.grey);
        expect(creator.arrow, '↓↓');

        guessedMovie = TestUtilities.movie(runtime: 100);
        creator.compute(guessedMovie);
        expect(creator.color, TileColor.yellow);
        expect(creator.arrow, '↑');

        guessedMovie = TestUtilities.movie(runtime: 120);
        creator.compute(guessedMovie);
        expect(creator.color, TileColor.green);
        expect(creator.arrow, '');
      });

      test('two greens then grey then yellow', () {
        Movie guessedMovie = TestUtilities.movie(runtime: 120);

        RuntimeCreator creator = RuntimeCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);
        expect(creator.color, TileColor.green);
        expect(creator.arrow, '');

        guessedMovie = TestUtilities.movie(runtime: 120);
        creator.compute(guessedMovie);
        expect(creator.color, TileColor.green);
        expect(creator.arrow, '');

        guessedMovie = TestUtilities.movie(runtime: 145);
        creator.compute(guessedMovie);
        expect(creator.color, TileColor.grey);
        expect(creator.arrow, '↓↓');

        guessedMovie = TestUtilities.movie(runtime: 100);
        creator.compute(guessedMovie);
        expect(creator.color, TileColor.yellow);
        expect(creator.arrow, '↑');
      });
    });
  });
}
