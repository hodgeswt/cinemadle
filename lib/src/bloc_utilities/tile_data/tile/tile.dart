import 'package:cinemadle/src/bloc_utilities/tile_data/tile_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tmdb_repository/tmdb_repository.dart';

part 'tile.g.dart';

@JsonSerializable()
class Tile {
  Tile(this.movie, this.status);

  final Movie movie;
  final TileStatus status;

  late TileData tileData;

  @JsonKey(includeFromJson: false, includeToJson: false)
  TileDataCreator? creator;

  Future<void> create() async {
    if (creator == null) {
      throw Exception('Tile creator is not set.');
    }

    tileData = await creator!.compute(movie, status: status);
  }

  Tile setCreator(TileDataCreator creator) {
    this.creator = creator;
    return this;
  }

  bool get isComputed => creator?.isComputed ?? false;

  factory Tile.fromJson(Map<String, dynamic> json) => _$TileFromJson(json);

  Map<String, dynamic> toJson() => _$TileToJson(this);
}
