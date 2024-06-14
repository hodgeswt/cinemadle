import 'package:cinemadle/src/blocs/target_movie/target_movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(TargetMovieEvent, () {
    test('props', () {
      expect(const TargetMovieLoadInitiated().props, []);
    });
  });
}
