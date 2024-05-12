import 'package:json_annotation/json_annotation.dart';

part 'movie_credit.g.dart';

@JsonSerializable()
class MovieCredit {
  @JsonKey(name: "id")
  final int id;

  @JsonKey(name: "adult")
  final bool? adult;

  @JsonKey(name: "gender")
  final int? gender;

  @JsonKey(name: "known_for_department")
  final String? knownForDepartment;

  @JsonKey(name: "name")
  final String name;

  @JsonKey(name: "original_name")
  final String? originalName;

  @JsonKey(name: "popularity")
  final double? popularity;

  @JsonKey(name: "profile_path")
  final String? profilePath;

  @JsonKey(name: "cast_id")
  final int? castId;

  @JsonKey(name: "character")
  final String? character;

  @JsonKey(name: "credit_id")
  final String? creditId;

  @JsonKey(name: "order")
  final int? order;

  @JsonKey(name: "job")
  final String? job;

  MovieCredit({
    required this.id,
    required this.adult,
    required this.castId,
    required this.character,
    required this.creditId,
    required this.gender,
    required this.knownForDepartment,
    required this.name,
    required this.order,
    required this.originalName,
    required this.popularity,
    required this.profilePath,
    required this.job,
  });

  factory MovieCredit.fromJson(Map<String, dynamic> json) =>
      _$MovieCreditFromJson(json);

  Map<String, dynamic> toJson() => _$MovieCreditToJson(this);
}
