part of 'main_view_bloc.dart';

@JsonSerializable()
@ColorJsonConverter()
class MovieTileColors {
  Color? userScore;
  Color? mpaRating;
  Color? releaseDate;
  Color? revenue;
  Color? runtime;
  Color? genre;
  Color? director;
  Color? writer;
  Color? firstInCast;

  MovieTileColors({
    this.userScore,
    this.mpaRating,
    this.releaseDate,
    this.revenue,
    this.runtime,
    this.genre,
    this.director,
    this.writer,
    this.firstInCast,
  });

  static MovieTileColors all({Color? color}) {
    return MovieTileColors(
      userScore: color,
      mpaRating: color,
      releaseDate: color,
      revenue: color,
      runtime: color,
      genre: color,
      director: color,
      writer: color,
      firstInCast: color,
    );
  }

  Map<String, dynamic> toJson() => _$MovieTileColorsToJson(this);

  factory MovieTileColors.fromJson(Map<String, dynamic> json) =>
      _$MovieTileColorsFromJson(json);
}
