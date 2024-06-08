import 'package:cinemadle/src/bloc_utilities/tile_data/tile_data.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:tmdb_repository/tmdb_repository.dart';

import '../../../test_utilities.dart';

void main() {
  group('WriterCreator', () {
    test('constructor', () {
      Movie targetMovie = TestUtilities.movie();

      WriterCreator creator = WriterCreator(targetMovie: targetMovie);

      expect(creator.targetMovie, targetMovie);
    });

    group('compute', () {
      test('directorMatch', () {
        Movie targetMovie = TestUtilities.movie(director: "James Cameron");
        Movie guessedMovie = TestUtilities.movie(writer: "James Cameron");

        WriterCreator creator = WriterCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);

        expect(creator.data, 1);
        expect(creator.isComputed, true);
      });

      test('writerMatch', () {
        Movie targetMovie = TestUtilities.movie(writer: "James Cameron");
        Movie guessedMovie = TestUtilities.movie(writer: "James Cameron");

        WriterCreator creator = WriterCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);

        expect(creator.data, 2);
        expect(creator.isComputed, true);
      });

      test('noMatch', () {
        Movie targetMovie = TestUtilities.movie(writer: "James Cameron");
        Movie guessedMovie = TestUtilities.movie(writer: "Steven Spielberg");

        WriterCreator creator = WriterCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);

        expect(creator.data, 0);
        expect(creator.isComputed, true);
      });
    });

    group('colors', () {
      test('greenCondition', () {
        Movie targetMovie = TestUtilities.movie();

        WriterCreator creator = WriterCreator(targetMovie: targetMovie);

        expect(creator.greenCondition(0), false);
        expect(creator.greenCondition(1), false);
        expect(creator.greenCondition(2), true);
      });

      test('yellowCondition', () {
        Movie targetMovie = TestUtilities.movie();

        WriterCreator creator = WriterCreator(targetMovie: targetMovie);

        expect(creator.yellowCondition(0), false);
        expect(creator.yellowCondition(1), true);
        expect(creator.yellowCondition(2), false);
      });
    });

    group('arrows', () {
      test('singleDownArrowCondition', () {
        Movie targetMovie = TestUtilities.movie();

        WriterCreator creator = WriterCreator(targetMovie: targetMovie);

        expect(creator.singleDownArrowCondition(0), false);
        expect(creator.singleDownArrowCondition(1), false);
        expect(creator.singleDownArrowCondition(2), false);
      });

      test('doubleDownArrowCondition', () {
        Movie targetMovie = TestUtilities.movie();

        WriterCreator creator = WriterCreator(targetMovie: targetMovie);

        expect(creator.doubleDownArrowCondition(0), false);
        expect(creator.doubleDownArrowCondition(1), false);
        expect(creator.doubleDownArrowCondition(2), false);
      });

      test('singleUpArrowCondition', () {
        Movie targetMovie = TestUtilities.movie();

        WriterCreator creator = WriterCreator(targetMovie: targetMovie);

        expect(creator.singleUpArrowCondition(0), false);
        expect(creator.singleUpArrowCondition(1), false);
        expect(creator.singleUpArrowCondition(2), false);
      });

      test('doubleUpArrowCondition', () {
        Movie targetMovie = TestUtilities.movie();

        WriterCreator creator = WriterCreator(targetMovie: targetMovie);

        expect(creator.doubleUpArrowCondition(0), false);
        expect(creator.doubleUpArrowCondition(1), false);
        expect(creator.doubleUpArrowCondition(2), false);
      });

      test('arrow', () {
        Movie targetMovie = TestUtilities.movie();

        WriterCreator creator = WriterCreator(targetMovie: targetMovie);

        expect(creator.arrow, '');
      });
    });

    group('getters', () {
      test('color: green', () {
        Movie targetMovie = TestUtilities.movie(writer: "James Cameron");
        Movie guessedMovie = TestUtilities.movie(writer: "James Cameron");

        WriterCreator creator = WriterCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);
        expect(creator.color, TileColor.green);
      });

      test('color: yellow', () {
        Movie targetMovie = TestUtilities.movie(director: "James Cameron");
        Movie guessedMovie = TestUtilities.movie(writer: "James Cameron");

        WriterCreator creator = WriterCreator(targetMovie: targetMovie);

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

        WriterCreator creator = WriterCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);
        expect(creator.color, TileColor.grey);
      });

      test('arrow: not computed', () {
        Movie targetMovie = TestUtilities.movie();

        WriterCreator creator = WriterCreator(targetMovie: targetMovie);

        expect(creator.arrow, '');
      });

      test('arrow: computed', () {
        Movie targetMovie = TestUtilities.movie(director: 'Steven Spielberg');
        Movie guessedMovie = TestUtilities.movie(director: 'Steven Spielberg');

        WriterCreator creator = WriterCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);
        expect(creator.arrow, '');
      });
    });
  });
}
