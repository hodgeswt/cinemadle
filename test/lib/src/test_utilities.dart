import 'package:mocktail/mocktail.dart';
import 'package:tmdb_repository/tmdb_repository.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class TestData<T, E> {
  TestData({
    required this.input1,
    required this.input2,
    required this.expected,
  });

  final T input1;
  final T input2;
  final E expected;

  @override
  String toString() {
    return 'TestData{input1: $input1, input2: $input2, expected: $expected}';
  }
}

class MockStorage extends Mock implements Storage {}

late Storage hydratedStorage;

void initHydratedStorage() {
  TestWidgetsFlutterBinding.ensureInitialized();
  hydratedStorage = MockStorage();
  when(
    () => hydratedStorage.write(any(), any<dynamic>()),
  ).thenAnswer((_) async {});
  HydratedBloc.storage = hydratedStorage;
}

class TestUtilities {
  static Movie movie({
    int id = 1,
    String title = 'title',
    String director = 'director',
    String writer = 'writer',
    String releaseDate = '1970-01-01',
    String posterPath = 'posterPath',
    double voteAverage = 0.0,
    List<String> genre = const [],
    List<String> leads = const [],
    String mpaRating = 'R',
    int revenue = 115000000,
    int runtime = 115,
  }) =>
      Movie(
        id: id,
        title: title,
        director: director,
        writer: writer,
        releaseDate: releaseDate,
        posterPath: posterPath,
        voteAverage: voteAverage,
        genre: genre,
        leads: leads,
        mpaRating: mpaRating,
        revenue: revenue,
        runtime: runtime,
      );
}
