import 'package:json_annotation/json_annotation.dart';

part 'release_date.g.dart';

@JsonSerializable()
class ReleaseDate {
  @JsonKey(name: "certification")
  final String certification;

  @JsonKey(name: "descriptors")
  final List<String>? descriptors;

  @JsonKey(name: "iso_639_1")
  final String? iso;

  @JsonKey(name: "note")
  final String? note;

  @JsonKey(name: "release_date")
  final String? releaseDate;

  @JsonKey(name: "type")
  final int? type;

  ReleaseDate({
    required this.iso,
    required this.descriptors,
    required this.certification,
    required this.note,
    required this.releaseDate,
    required this.type,
  });

  factory ReleaseDate.fromJson(Map<String, dynamic> json) =>
      _$ReleaseDateFromJson(json);

  Map<String, dynamic> toJson() => _$ReleaseDateToJson(this);
}
