import 'package:tmdb_api/src/data_model/release_date.dart';
import 'package:json_annotation/json_annotation.dart';

part 'release_info.g.dart';

@JsonSerializable()
class ReleaseInfo {
  @JsonKey(name: "iso_3166_1")
  final String iso;

  @JsonKey(name: "release_dates")
  final List<ReleaseDate> releaseDates;

  ReleaseInfo({
    required this.iso,
    required this.releaseDates,
  });

  factory ReleaseInfo.fromJson(Map<String, dynamic> json) =>
      _$ReleaseInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ReleaseInfoToJson(this);
}
