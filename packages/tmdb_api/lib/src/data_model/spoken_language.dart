import 'package:json_annotation/json_annotation.dart';

part 'spoken_language.g.dart';

@JsonSerializable()
class SpokenLanguage {
  @JsonKey(name: "english_name")
  final String englishName;

  @JsonKey(name: "iso_639_1")
  final String? iso;

  @JsonKey(name: "name")
  final String name;

  SpokenLanguage({
    required this.englishName,
    required this.iso,
    required this.name,
  });

  factory SpokenLanguage.fromJson(Map<String, dynamic> json) =>
      _$SpokenLanguageFromJson(json);

  Map<String, dynamic> toJson() => _$SpokenLanguageToJson(this);
}
