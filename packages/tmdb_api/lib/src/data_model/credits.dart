import 'package:tmdb_api/src/data_model/movie_credit.dart';
import 'package:json_annotation/json_annotation.dart';

part 'credits.g.dart';

@JsonSerializable()
class Credits {
  @JsonKey(name: "id")
  final int id;

  @JsonKey(name: "cast")
  final List<MovieCredit> cast;

  @JsonKey(name: "crew")
  final List<MovieCredit> crew;

  Credits({
    required this.id,
    required this.cast,
    required this.crew,
  });

  factory Credits.fromJson(Map<String, dynamic> json) =>
      _$CreditsFromJson(json);

  Map<String, dynamic> toJson() => _$CreditsToJson(this);
}
