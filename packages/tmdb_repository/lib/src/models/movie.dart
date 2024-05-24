import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tmdb_api/tmdb_api.dart';

part 'movie.g.dart';

@JsonSerializable()
class Movie extends Equatable {
  const Movie({
    required this.director,
    required this.genre,
    required this.id,
    required this.lead,
    required this.mpaRating,
    required this.releaseDate,
    required this.revenue,
    required this.runtime,
    required this.title,
    required this.voteAverage,
    required this.writer,
    required this.posterPath,
  });

  final int id;
  final String title;
  final int runtime;
  final double voteAverage;
  final String mpaRating;
  final String releaseDate;
  final int revenue;
  final List<String> genre;
  final String director;
  final String writer;
  final String lead;
  final String posterPath;

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);

  static String _getArbitraryCrewRole(Credits? c, List<String> jobs) {
    try {
      return c?.crew.firstWhere((x) {
            return jobs.contains(x.job);
          }).name ??
          "";
    } catch (_) {
      return "";
    }
  }

  static List<String> _getGenre(MovieDetails movieDetails) {
    Iterable<GenreDetail> rawGenres = movieDetails.genres.take(3);
    List<String> genres = [];

    for (GenreDetail detail in rawGenres) {
      genres.add(detail.name);
    }

    return genres;
  }

  static String _getArbitraryFirstInCast(Credits? c) {
    try {
      return c?.cast.firstWhere((x) {
            return x.order == 0;
          }).name ??
          "";
    } catch (_) {
      return "";
    }
  }

  static String _getArbitraryMpaRating(MovieDetails? m) {
    if (m == null) {
      return "";
    }

    try {
      DateTime? base = DateTime.tryParse(m.releaseDate);
      String? cert = m.releaseDates?.results
          .firstWhere((x) {
            return x.iso == "US";
          })
          .releaseDates
          .firstWhere((x) {
            DateTime? y = DateTime.tryParse(m.releaseDate);
            if (base == null || y == null) {
              return x.certification != "";
            }

            return (base.year == y.year) &&
                (base.day == y.day) &&
                (base.month == y.month) &&
                x.certification != "";
          })
          .certification;
      return (cert?.isEmpty ?? false) ? "" : cert!;
    } catch (_) {
      return "";
    }
  }

  factory Movie.fromRaw(Credits credits, MovieDetails details) {
    return Movie(
      title: details.title,
      runtime: details.runtime,
      voteAverage: details.voteAverage,
      mpaRating: _getArbitraryMpaRating(details),
      releaseDate: details.releaseDate.split('-').first,
      revenue: details.revenue,
      genre: _getGenre(details),
      director: _getArbitraryCrewRole(credits, ["Director"]),
      writer: _getArbitraryCrewRole(credits, ["Screenplay", "Writer"]),
      lead: _getArbitraryFirstInCast(credits),
      id: details.id,
      posterPath: details.posterPath == null
          ? ""
          : "${TmdbApiClient.instance.imageEndpoint}${details.posterPath}",
    );
  }

  Map<String, dynamic> toJson() => _$MovieToJson(this);

  @override
  List<Object> get props => [
        id,
        title,
        runtime,
        voteAverage,
        mpaRating,
        releaseDate,
        revenue,
        genre,
        director,
        writer,
        lead,
        posterPath,
      ];
}
