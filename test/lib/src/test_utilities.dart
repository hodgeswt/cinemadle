import 'package:tmdb_repository/tmdb_repository.dart';

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
