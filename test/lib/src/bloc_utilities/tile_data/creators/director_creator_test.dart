import 'package:cinemadle/src/bloc_utilities/tile_data/tile_data.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:tmdb_repository/tmdb_repository.dart';

import '../../../test_utilities.dart';

void main() {
  group('DirectorCreator', () {
    test('constructor', () {
      Movie targetMovie = TestUtilities.movie();

      DirectorCreator creator = DirectorCreator(targetMovie: targetMovie);

      expect(creator.targetMovie, targetMovie);
    });

    group('compute', () {
      test('directorMatch', () {
        Movie targetMovie = TestUtilities.movie(director: "James Cameron");
        Movie guessedMovie = TestUtilities.movie(director: "James Cameron");

        DirectorCreator creator = DirectorCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);

        expect(creator.data, 2);
        expect(creator.isComputed, true);
      });

      test('writerMatch', () {
        Movie targetMovie = TestUtilities.movie(writer: "James Cameron");
        Movie guessedMovie = TestUtilities.movie(director: "James Cameron");

        DirectorCreator creator = DirectorCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);

        expect(creator.data, 1);
        expect(creator.isComputed, true);
      });

      test('noMatch', () {
        Movie targetMovie = TestUtilities.movie(director: "James Cameron");
        Movie guessedMovie = TestUtilities.movie(director: "Steven Spielberg");

        DirectorCreator creator = DirectorCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);

        expect(creator.data, 0);
        expect(creator.isComputed, true);
      });
    });

    group('colors', () {
      test('green condition', () {
        Movie targetMovie = TestUtilities.movie();

        DirectorCreator creator = DirectorCreator(targetMovie: targetMovie);

        expect(creator.greenCondition(0), false);
        expect(creator.greenCondition(1), false);
        expect(creator.greenCondition(2), true);
      });

      test('yellow condition', () {
        Movie targetMovie = TestUtilities.movie();

        DirectorCreator creator = DirectorCreator(targetMovie: targetMovie);

        expect(creator.yellowCondition(0), false);
        expect(creator.yellowCondition(1), true);
        expect(creator.yellowCondition(2), false);
      });
    });

    group('arrows', () {
      test('single down arrow condition', () {
        Movie targetMovie = TestUtilities.movie();

        DirectorCreator creator = DirectorCreator(targetMovie: targetMovie);

        expect(creator.singleDownArrowCondition(0), false);
        expect(creator.singleDownArrowCondition(1), false);
        expect(creator.singleDownArrowCondition(2), false);
      });

      test('double down arrow condition', () {
        Movie targetMovie = TestUtilities.movie();

        DirectorCreator creator = DirectorCreator(targetMovie: targetMovie);

        expect(creator.doubleDownArrowCondition(0), false);
        expect(creator.doubleDownArrowCondition(1), false);
        expect(creator.doubleDownArrowCondition(2), false);
      });

      test('single up arrow condition', () {
        Movie targetMovie = TestUtilities.movie();

        DirectorCreator creator = DirectorCreator(targetMovie: targetMovie);

        expect(creator.singleUpArrowCondition(0), false);
        expect(creator.singleUpArrowCondition(1), false);
        expect(creator.singleUpArrowCondition(2), false);
      });

      test('double up arrow condition', () {
        Movie targetMovie = TestUtilities.movie();

        DirectorCreator creator = DirectorCreator(targetMovie: targetMovie);

        expect(creator.doubleUpArrowCondition(0), false);
        expect(creator.doubleUpArrowCondition(1), false);
        expect(creator.doubleUpArrowCondition(2), false);
      });

      test('arrow', () {
        Movie targetMovie = TestUtilities.movie();

        DirectorCreator creator = DirectorCreator(targetMovie: targetMovie);

        expect(creator.arrow, '');
      });
    });

    group('getters', () {
      test('color: green', () {
        Movie targetMovie = TestUtilities.movie(director: "James Cameron");
        Movie guessedMovie = TestUtilities.movie(director: "James Cameron");

        DirectorCreator creator = DirectorCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);
        expect(creator.color, TileColor.green);
      });

      test('color: yellow', () {
        Movie targetMovie = TestUtilities.movie(writer: "James Cameron");
        Movie guessedMovie = TestUtilities.movie(director: "James Cameron");

        DirectorCreator creator = DirectorCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);
        expect(creator.color, TileColor.yellow);
      });

      test('color: grey', () {
        Movie targetMovie = TestUtilities.movie(
          director: "James Cameron",
          writer: "James Cameron",
        );
        Movie guessedMovie = TestUtilities.movie(
          director: "Steven Spielberg",
          writer: "Steven Spielberg",
        );

        DirectorCreator creator = DirectorCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);
        expect(creator.color, TileColor.grey);
      });

      test('arrow: not computed', () {
        Movie targetMovie = TestUtilities.movie();

        DirectorCreator creator = DirectorCreator(targetMovie: targetMovie);

        expect(creator.arrow, '');
      });

      test('arrow: computed', () {
        Movie targetMovie = TestUtilities.movie(director: 'Steven Spielberg');
        Movie guessedMovie = TestUtilities.movie(director: 'Steven Spielberg');

        DirectorCreator creator = DirectorCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);
        expect(creator.arrow, '');
      });
    });
  });
}
