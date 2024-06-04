part of 'main_view_bloc.dart';

@JsonSerializable()
@ColorJsonConverter()
class MovieTileData {
  Color? userScore;
  Color? mpaRating;
  Color? releaseDate;
  Color? revenue;
  Color? runtime;
  Color? genre;
  Color? director;
  Color? writer;
  Color? firstInCast;

  String? userScoreArrow;
  String? mpaRatingArrow;
  String? releaseDateArrow;
  String? runtimeArrow;
  String? revenueArrow;

  List<bool>? boldGenre;
  List<bool>? boldCast;

  MovieTileData({
    this.userScore,
    this.mpaRating,
    this.releaseDate,
    this.revenue,
    this.runtime,
    this.genre,
    this.director,
    this.writer,
    this.firstInCast,
    this.userScoreArrow,
    this.mpaRatingArrow,
    this.releaseDateArrow,
    this.runtimeArrow,
    this.revenueArrow,
    this.boldGenre,
    this.boldCast,
  });

  static MovieTileData all({Color? color}) {
    return MovieTileData(
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

  Map<String, dynamic> toJson() => _$MovieTileDataToJson(this);

  factory MovieTileData.fromJson(Map<String, dynamic> json) =>
      _$MovieTileDataFromJson(json);
}
