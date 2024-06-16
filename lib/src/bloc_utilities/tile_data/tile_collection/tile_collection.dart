import 'package:cinemadle/src/bloc_utilities/tile_data/tile_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tmdb_repository/tmdb_repository.dart';

part 'tile_collection.g.dart';

Map<TileColor, String> resultsColorMap = {
  TileColor.yellow: "🟨",
  TileColor.green: "🟩",
  TileColor.grey: "⬛",
  TileColor.red: "⬛",
};

@JsonSerializable()
class TileCollection {
  TileCollection(this.movie, this.targetMovie, this.status, this.allowFlip);

  final Movie movie;
  final Movie targetMovie;
  final bool allowFlip;

  @JsonKey(includeFromJson: false, includeToJson: false)
  TmdbRepository? tmdbRepository;
  final TileStatus status;

  late final List<Tile> tiles;

  bool get isComputed => tiles.every((tile) => tile.isComputed);

  Future<void> create() async {
    if (tmdbRepository == null) {
      throw Exception('TmdbRepository is not set.');
    }

    tiles = [
      Tile(
        movie,
        status,
      ).setCreator(
        CastCreator(targetMovie: targetMovie, tmdbRepository: tmdbRepository!),
      ),
      Tile(
        movie,
        status,
      ).setCreator(
        DirectorCreator(targetMovie: targetMovie),
      ),
      Tile(
        movie,
        status,
      ).setCreator(
        WriterCreator(targetMovie: targetMovie),
      ),
      Tile(
        movie,
        status,
      ).setCreator(
        GenreCreator(targetMovie: targetMovie),
      ),
      Tile(
        movie,
        status,
      ).setCreator(
        ReleaseDateCreator(targetMovie: targetMovie),
      ),
      Tile(
        movie,
        status,
      ).setCreator(
        RevenueCreator(targetMovie: targetMovie),
      ),
      Tile(
        movie,
        status,
      ).setCreator(
        RuntimeCreator(targetMovie: targetMovie),
      ),
      Tile(
        movie,
        status,
      ).setCreator(
        UserScoreCreator(targetMovie: targetMovie),
      ),
      Tile(
        movie,
        status,
      ).setCreator(
        MpaRatingCreator(targetMovie: targetMovie),
      ),
    ];

    for (final tile in tiles) {
      await tile.create();
    }
  }

  TileCollection setTmdbRepository(TmdbRepository tmdbRepository) {
    this.tmdbRepository = tmdbRepository;
    return this;
  }

  String get results {
    String o = '';

    for (final tile in tiles) {
      o += resultsColorMap[tile.tileData.color] ?? '⬛';
    }

    return '$o\n';
  }

  factory TileCollection.fromJson(Map<String, dynamic> json) =>
      _$TileCollectionFromJson(json);

  Map<String, dynamic> toJson() => _$TileCollectionToJson(this);
}
