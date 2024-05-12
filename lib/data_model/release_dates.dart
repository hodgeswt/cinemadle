import 'package:cinemadle/data_model/release_info.dart';
import 'package:json_annotation/json_annotation.dart';

part 'release_dates.g.dart';

@JsonSerializable()
class ReleaseDates {
  @JsonKey(name: "results")
  final List<ReleaseInfo> results;

  ReleaseDates({
    required this.results,
  });

  factory ReleaseDates.fromJson(Map<String, dynamic> json) =>
      _$ReleaseDatesFromJson(json);

  Map<String, dynamic> toJson() => _$ReleaseDatesToJson(this);
}
