import 'package:cinemadle/src/bloc_utilities/tile_data/tile_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tile_data.g.dart';

@JsonSerializable()
class TileData {
  TileData({
    required this.color,
    required this.title,
    required this.content,
    required this.arrow,
    required this.emphasized,
  });

  final String title;
  final String content;
  final String arrow;
  final List<bool> emphasized;
  final TileColor color;

  factory TileData.fromJson(Map<String, dynamic> json) =>
      _$TileDataFromJson(json);

  Map<String, dynamic> toJson() => _$TileDataToJson(this);
}
