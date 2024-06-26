import 'package:tmdb_api/src/data_model/genre_detail.dart';
import 'package:tmdb_api/src/data_model/production_company.dart';
import 'package:tmdb_api/src/data_model/production_country.dart';
import 'package:tmdb_api/src/data_model/release_dates.dart';
import 'package:tmdb_api/src/data_model/spoken_language.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movie_details.g.dart';

@JsonSerializable()
class MovieDetails {
  @JsonKey(name: "adult")
  final bool? adult;

  @JsonKey(name: "belongs_to_collection")
  final Map<String, dynamic>? belongsToCollection;

  @JsonKey(name: "backdrop_path")
  final String? backdropPath;

  @JsonKey(name: "budget")
  final int budget;

  @JsonKey(name: "genres")
  final List<GenreDetail> genres;

  @JsonKey(name: "homepage")
  final String? homepage;

  @JsonKey(name: "id")
  final int id;

  @JsonKey(name: "imdb_id")
  final String? imdbId;

  @JsonKey(name: "origin_country")
  final List<String>? originCountry;

  @JsonKey(name: "original_title")
  final String? originalTitle;

  @JsonKey(name: "original_language")
  final String? originalLanguage;

  @JsonKey(name: "overview")
  final String overview;

  @JsonKey(name: "popularity")
  final double popularity;

  @JsonKey(name: "poster_path")
  final String? posterPath;

  @JsonKey(name: "production_companies")
  final List<ProductionCompany>? productionCompanies;

  @JsonKey(name: "production_countries")
  final List<ProductionCountry>? productionCountries;

  @JsonKey(name: "release_date")
  final String releaseDate;

  @JsonKey(name: "revenue")
  final int revenue;

  @JsonKey(name: "runtime")
  final int runtime;

  @JsonKey(name: "spoken_languages")
  final List<SpokenLanguage> spokenLanguages;

  @JsonKey(name: "status")
  final String? status;

  @JsonKey(name: "tagline")
  final String tagline;

  @JsonKey(name: "title")
  final String title;

  @JsonKey(name: "video")
  final bool? video;

  @JsonKey(name: "vote_average")
  final double voteAverage;

  @JsonKey(name: "vote_count")
  final int voteCount;

  @JsonKey(name: "release_dates")
  final ReleaseDates? releaseDates;

  MovieDetails({
    required this.voteCount,
    required this.backdropPath,
    required this.budget,
    required this.genres,
    required this.homepage,
    required this.id,
    required this.imdbId,
    required this.originCountry,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.productionCompanies,
    required this.productionCountries,
    required this.releaseDate,
    required this.revenue,
    required this.runtime,
    required this.spokenLanguages,
    required this.status,
    required this.tagline,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.releaseDates,
    required this.adult,
    required this.belongsToCollection,
  });

  factory MovieDetails.fromJson(Map<String, dynamic> json) =>
      _$MovieDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$MovieDetailsToJson(this);
}
