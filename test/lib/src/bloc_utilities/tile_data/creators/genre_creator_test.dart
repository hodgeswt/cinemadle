import 'package:cinemadle/src/bloc_utilities/tile_data/tile_data.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:tmdb_repository/tmdb_repository.dart';

import '../../../test_utilities.dart';

void main() {
  group('GenreCreator', () {
    test('constructor', () {
      Movie targetMovie = TestUtilities.movie();

      GenreCreator creator = GenreCreator(targetMovie: targetMovie);

      expect(creator.targetMovie, targetMovie);
    });

    group('compute', () {
      test('no match', () {
        Movie targetMovie =
            TestUtilities.movie(genre: ["Action", "Adventure", "Comedy"]);
        Movie guessedMovie =
            TestUtilities.movie(genre: ["Sci-Fi", "Horror", "Romance"]);

        GenreCreator creator = GenreCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);

        expect(creator.data, 0);
        expect(creator.isComputed, true);
      });

      test('one match', () {
        Movie targetMovie =
            TestUtilities.movie(genre: ["Action", "Adventure", "Comedy"]);
        Movie guessedMovie =
            TestUtilities.movie(genre: ["Sci-Fi", "Horror", "Comedy"]);

        GenreCreator creator = GenreCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);

        expect(creator.data, 1);
        expect(creator.isComputed, true);
      });

      test('two match', () {
        Movie targetMovie =
            TestUtilities.movie(genre: ["Action", "Adventure", "Comedy"]);
        Movie guessedMovie =
            TestUtilities.movie(genre: ["Sci-Fi", "Adventure", "Comedy"]);

        GenreCreator creator = GenreCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);

        expect(creator.data, 1);
        expect(creator.isComputed, true);
      });

      test('three match', () {
        Movie targetMovie =
            TestUtilities.movie(genre: ["Action", "Adventure", "Comedy"]);
        Movie guessedMovie =
            TestUtilities.movie(genre: ["Action", "Adventure", "Comedy"]);

        GenreCreator creator = GenreCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);

        expect(creator.data, 2);
        expect(creator.isComputed, true);
      });
    });

    group('colors', () {
      test('greenCondition', () {
        Movie targetMovie = TestUtilities.movie();

        GenreCreator creator = GenreCreator(targetMovie: targetMovie);

        expect(creator.greenCondition(0), false);
        expect(creator.greenCondition(1), false);
        expect(creator.greenCondition(2), true);
      });

      test('yellowCondition', () {
        Movie targetMovie = TestUtilities.movie();

        GenreCreator creator = GenreCreator(targetMovie: targetMovie);

        expect(creator.yellowCondition(0), false);
        expect(creator.yellowCondition(1), true);
        expect(creator.yellowCondition(2), false);
      });
    });

    group('arrows', () {
      test('singleDownArrowCondition', () {
        Movie targetMovie = TestUtilities.movie();

        GenreCreator creator = GenreCreator(targetMovie: targetMovie);

        expect(creator.singleDownArrowCondition(0), false);
        expect(creator.singleDownArrowCondition(1), false);
        expect(creator.singleDownArrowCondition(2), false);
      });

      test('doubleDownArrowCondition', () {
        Movie targetMovie = TestUtilities.movie();

        GenreCreator creator = GenreCreator(targetMovie: targetMovie);

        expect(creator.doubleDownArrowCondition(0), false);
        expect(creator.doubleDownArrowCondition(1), false);
        expect(creator.doubleDownArrowCondition(2), false);
      });

      test('singleUpArrowCondition', () {
        Movie targetMovie = TestUtilities.movie();

        GenreCreator creator = GenreCreator(targetMovie: targetMovie);

        expect(creator.singleUpArrowCondition(0), false);
        expect(creator.singleUpArrowCondition(1), false);
        expect(creator.singleUpArrowCondition(2), false);
      });

      test('doubleUpArrowCondition', () {
        Movie targetMovie = TestUtilities.movie();

        GenreCreator creator = GenreCreator(targetMovie: targetMovie);

        expect(creator.doubleUpArrowCondition(0), false);
        expect(creator.doubleUpArrowCondition(1), false);
        expect(creator.doubleUpArrowCondition(2), false);
      });

      test('arrow', () {
        Movie targetMovie = TestUtilities.movie();

        GenreCreator creator = GenreCreator(targetMovie: targetMovie);

        expect(creator.arrow, '');
      });
    });

    group('getters', () {
      test('color: green', () {
        Movie targetMovie =
            TestUtilities.movie(genre: ["Action", "Adventure", "Comedy"]);
        Movie guessedMovie =
            TestUtilities.movie(genre: ["Action", "Adventure", "Comedy"]);

        GenreCreator creator = GenreCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);
        expect(creator.color, TileColor.green);
      });

      test('color: yellow (1)', () {
        Movie targetMovie =
            TestUtilities.movie(genre: ["Action", "Adventure", "Comedy"]);
        Movie guessedMovie =
            TestUtilities.movie(genre: ["Sci-Fi", "Adventure", "Romance"]);

        GenreCreator creator = GenreCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);
        expect(creator.color, TileColor.yellow);
      });

      test('color: yellow (2)', () {
        Movie targetMovie =
            TestUtilities.movie(genre: ["Action", "Adventure", "Comedy"]);
        Movie guessedMovie =
            TestUtilities.movie(genre: ["Action", "Adventure", "Romance"]);

        GenreCreator creator = GenreCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);
        expect(creator.color, TileColor.yellow);
      });

      test('color: grey', () {
        Movie targetMovie =
            TestUtilities.movie(genre: ["Action", "Adventure", "Comedy"]);
        Movie guessedMovie =
            TestUtilities.movie(genre: ["Sci-Fi", "Horror", "Romance"]);

        GenreCreator creator = GenreCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);
        expect(creator.color, TileColor.grey);
      });

      test('arrow: not computed', () {
        Movie targetMovie = TestUtilities.movie();

        GenreCreator creator = GenreCreator(targetMovie: targetMovie);

        expect(creator.arrow, '');
      });

      test('arrow: computed', () {
        Movie targetMovie =
            TestUtilities.movie(genre: ["Action", "Adventure", "Comedy"]);
        Movie guessedMovie =
            TestUtilities.movie(genre: ["Sci-Fi", "Horror", "Romance"]);

        GenreCreator creator = GenreCreator(targetMovie: targetMovie);

        creator.compute(guessedMovie);
        expect(creator.arrow, '');
      });
    });
  });
}
