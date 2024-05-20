import 'package:json_annotation/json_annotation.dart';

part 'genre_detail.g.dart';

@JsonSerializable()
class GenreDetail {
  @JsonKey(name: "id")
  final int id;

  @JsonKey(name: "name")
  final String name;

  GenreDetail({
    required this.id,
    required this.name,
  });

  factory GenreDetail.fromJson(Map<String, dynamic> json) =>
      _$GenreDetailFromJson(json);

  Map<String, dynamic> toJson() => _$GenreDetailToJson(this);
}
