import 'package:cinemadle/src/bloc_utilities/tile_data/tile_data.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:tmdb_repository/tmdb_repository.dart';

import '../../../test_utilities.dart';

void main() {
  group('UserScoreCreator', () {
    test('constructor', () {
      Movie targetMovie = TestUtilities.movie();

      UserScoreCreator creator = UserScoreCreator(targetMovie: targetMovie);

      expect(creator.targetMovie, targetMovie);
    });

    group('compute', () {
      test('revenue match', () {
        Movie targetMovie = TestUtilities.movie(voteAverage: 7.85);
        Movie guessedMovie = TestUtilities.movie(voteAverage: 7.85);

        UserScoreCreator creator = UserScoreCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);

        expect(creator.data, 0);
        expect(creator.isComputed, true);
      });

      test('revenue negative', () {
        Movie targetMovie = TestUtilities.movie(voteAverage: 6.50);
        Movie guessedMovie = TestUtilities.movie(voteAverage: 7.85);

        UserScoreCreator creator = UserScoreCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);

        expect(creator.data, -1.4);
        expect(creator.isComputed, true);
      });

      test('revenue positive', () {
        Movie targetMovie = TestUtilities.movie(voteAverage: 7.85);
        Movie guessedMovie = TestUtilities.movie(voteAverage: 6.50);

        UserScoreCreator creator = UserScoreCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);

        expect(creator.data, 1.4);
        expect(creator.isComputed, true);
      });
    });

    group('colors', () {
      test('green condition', () {
        Movie targetMovie = TestUtilities.movie();

        UserScoreCreator creator = UserScoreCreator(targetMovie: targetMovie);

        expect(creator.greenCondition(0), true);
        expect(creator.greenCondition(1), false);
        expect(creator.greenCondition(2), false);
        expect(creator.greenCondition(-2), false);
        expect(creator.greenCondition(-1), false);
      });

      test('yellow condition', () {
        Movie targetMovie = TestUtilities.movie();

        UserScoreCreator creator = UserScoreCreator(targetMovie: targetMovie);

        expect(creator.yellowCondition(0), true);
        expect(creator.yellowCondition(0.5), true);
        expect(creator.yellowCondition(1), true);
        expect(creator.yellowCondition(2), false);
        expect(creator.yellowCondition(-0.5), true);
        expect(creator.yellowCondition(1.9), false);
        expect(creator.yellowCondition(-1), true);
        expect(creator.yellowCondition(-2), false);
        expect(creator.yellowCondition(-1.9), false);
      });
    });

    group('arrows', () {
      test('single down arrow condition', () {
        Movie targetMovie = TestUtilities.movie();

        UserScoreCreator creator = UserScoreCreator(targetMovie: targetMovie);

        expect(creator.singleDownArrowCondition(0), false);
        expect(creator.singleDownArrowCondition(0.1), false);
        expect(creator.singleDownArrowCondition(1), false);
        expect(creator.singleDownArrowCondition(2), false);
        expect(creator.singleDownArrowCondition(-0.1), true);
        expect(creator.singleDownArrowCondition(-1), true);
        expect(creator.singleDownArrowCondition(-2), true);
      });

      test('double down arrow condition', () {
        Movie targetMovie = TestUtilities.movie();

        UserScoreCreator creator = UserScoreCreator(targetMovie: targetMovie);

        expect(creator.doubleDownArrowCondition(0), false);
        expect(creator.doubleDownArrowCondition(0.1), false);
        expect(creator.doubleDownArrowCondition(1), false);
        expect(creator.doubleDownArrowCondition(2), false);
        expect(creator.doubleDownArrowCondition(5), false);
        expect(creator.doubleDownArrowCondition(-0.1), false);
        expect(creator.doubleDownArrowCondition(-1), false);
        expect(creator.doubleDownArrowCondition(-2), false);
        expect(creator.doubleDownArrowCondition(-5), false);
      });

      test('single up arrow condition', () {
        Movie targetMovie = TestUtilities.movie();

        UserScoreCreator creator = UserScoreCreator(targetMovie: targetMovie);

        expect(creator.singleUpArrowCondition(0), false);
        expect(creator.singleUpArrowCondition(0.1), true);
        expect(creator.singleUpArrowCondition(1), true);
        expect(creator.singleUpArrowCondition(2), true);
        expect(creator.singleUpArrowCondition(-0.1), false);
        expect(creator.singleUpArrowCondition(-1), false);
        expect(creator.singleUpArrowCondition(-2), false);
      });

      test('double up arrow condition', () {
        Movie targetMovie = TestUtilities.movie();

        UserScoreCreator creator = UserScoreCreator(targetMovie: targetMovie);

        expect(creator.doubleUpArrowCondition(0), false);
        expect(creator.doubleUpArrowCondition(0.1), false);
        expect(creator.doubleUpArrowCondition(1), false);
        expect(creator.doubleUpArrowCondition(2), false);
        expect(creator.doubleUpArrowCondition(5), false);
        expect(creator.doubleUpArrowCondition(-0.1), false);
        expect(creator.doubleUpArrowCondition(-1), false);
        expect(creator.doubleUpArrowCondition(-2), false);
        expect(creator.doubleUpArrowCondition(-5), false);
      });
    });

    group('getters', () {
      test('color: green', () {
        Movie targetMovie = TestUtilities.movie(voteAverage: 6.50);
        Movie guessedMovie = TestUtilities.movie(voteAverage: 6.50);

        UserScoreCreator creator = UserScoreCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);
        expect(creator.color, TileColor.green);
      });

      test('color: yellow', () {
        Movie targetMovie = TestUtilities.movie(voteAverage: 7.85);
        Movie guessedMovie = TestUtilities.movie(voteAverage: 6.85);

        UserScoreCreator creator = UserScoreCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);
        expect(creator.color, TileColor.yellow);

        targetMovie = TestUtilities.movie(voteAverage: 7.85);
        guessedMovie = TestUtilities.movie(voteAverage: 8.9);
        creator = UserScoreCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);
        expect(creator.color, TileColor.yellow);
      });

      test('color: grey', () {
        Movie targetMovie = TestUtilities.movie(voteAverage: 7.85);
        Movie guessedMovie = TestUtilities.movie(voteAverage: 6.80);

        UserScoreCreator creator = UserScoreCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);
        expect(creator.color, TileColor.grey);

        targetMovie = TestUtilities.movie(voteAverage: 7.85);
        guessedMovie = TestUtilities.movie(voteAverage: 9.0);
        creator = UserScoreCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);
        expect(creator.color, TileColor.grey);
      });

      test('arrow: not computed', () {
        Movie targetMovie = TestUtilities.movie();

        UserScoreCreator creator = UserScoreCreator(targetMovie: targetMovie);

        expect(creator.arrow, '');
      });

      test('arrow: computed', () {
        Movie targetMovie = TestUtilities.movie(voteAverage: 7.85);
        Movie guessedMovie = TestUtilities.movie(voteAverage: 6.9);

        UserScoreCreator creator = UserScoreCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);
        expect(creator.arrow, '↑');

        targetMovie = TestUtilities.movie(voteAverage: 7.85);
        guessedMovie = TestUtilities.movie(voteAverage: 8.5);
        creator = UserScoreCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);
        expect(creator.arrow, '↓');

        targetMovie = TestUtilities.movie(voteAverage: 7.85);
        guessedMovie = TestUtilities.movie(voteAverage: 7.85);
        creator = UserScoreCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);
        expect(creator.arrow, '');

        targetMovie = TestUtilities.movie(voteAverage: 7.85);
        guessedMovie = TestUtilities.movie(voteAverage: 9.5);
        creator = UserScoreCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);
        expect(creator.arrow, '↓');

        targetMovie = TestUtilities.movie(voteAverage: 7.85);
        guessedMovie = TestUtilities.movie(voteAverage: 3.1);
        creator = UserScoreCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);
        expect(creator.arrow, '↑');
      });
    });

    group('sequences', () {
      Movie targetMovie = TestUtilities.movie(voteAverage: 7.85);

      test('two yellows then green', () {
        Movie guessedMovie = TestUtilities.movie(voteAverage: 6.9);

        UserScoreCreator creator = UserScoreCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);
        expect(creator.color, TileColor.yellow);
        expect(creator.arrow, '↑');

        guessedMovie = TestUtilities.movie(voteAverage: 8.5);
        creator.compute(guessedMovie);
        expect(creator.color, TileColor.yellow);
        expect(creator.arrow, '↓');

        guessedMovie = TestUtilities.movie(voteAverage: 7.85);
        creator.compute(guessedMovie);
        expect(creator.color, TileColor.green);
        expect(creator.arrow, '');
      });

      test('two yellows then grey', () {
        Movie guessedMovie = TestUtilities.movie(voteAverage: 6.9);

        UserScoreCreator creator = UserScoreCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);
        expect(creator.color, TileColor.yellow);
        expect(creator.arrow, '↑');

        guessedMovie = TestUtilities.movie(voteAverage: 8.5);
        creator.compute(guessedMovie);
        expect(creator.color, TileColor.yellow);
        expect(creator.arrow, '↓');

        guessedMovie = TestUtilities.movie(voteAverage: 10.0);
        creator.compute(guessedMovie);
        expect(creator.color, TileColor.grey);
        expect(creator.arrow, '↓');
      });

      test('two greys then yellow then green', () {
        Movie guessedMovie = TestUtilities.movie(voteAverage: 3.2);

        UserScoreCreator creator = UserScoreCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);
        expect(creator.color, TileColor.grey);
        expect(creator.arrow, '↑');

        guessedMovie = TestUtilities.movie(voteAverage: 10.0);
        creator.compute(guessedMovie);
        expect(creator.color, TileColor.grey);
        expect(creator.arrow, '↓');

        guessedMovie = TestUtilities.movie(voteAverage: 7.8);
        creator.compute(guessedMovie);
        expect(creator.color, TileColor.yellow);
        expect(creator.arrow, '↑');

        guessedMovie = TestUtilities.movie(voteAverage: 7.85);
        creator.compute(guessedMovie);
        expect(creator.color, TileColor.green);
        expect(creator.arrow, '');
      });

      test('two greens then grey then yellow', () {
        Movie guessedMovie = TestUtilities.movie(voteAverage: 7.85);

        UserScoreCreator creator = UserScoreCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);
        expect(creator.color, TileColor.green);
        expect(creator.arrow, '');

        guessedMovie = TestUtilities.movie(voteAverage: 7.85);
        creator.compute(guessedMovie);
        expect(creator.color, TileColor.green);
        expect(creator.arrow, '');

        guessedMovie = TestUtilities.movie(voteAverage: 9.6);
        creator.compute(guessedMovie);
        expect(creator.color, TileColor.grey);
        expect(creator.arrow, '↓');

        guessedMovie = TestUtilities.movie(voteAverage: 6.9);
        creator.compute(guessedMovie);
        expect(creator.color, TileColor.yellow);
        expect(creator.arrow, '↑');
      });
    });
  });
}
