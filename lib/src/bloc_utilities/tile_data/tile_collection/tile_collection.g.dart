// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tile_collection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TileCollection _$TileCollectionFromJson(Map<String, dynamic> json) =>
    TileCollection(
      Movie.fromJson(json['movie'] as Map<String, dynamic>),
      Movie.fromJson(json['targetMovie'] as Map<String, dynamic>),
      $enumDecode(_$TileStatusEnumMap, json['status']),
    )..tiles = (json['tiles'] as List<dynamic>)
        .map((e) => Tile.fromJson(e as Map<String, dynamic>))
        .toList();

Map<String, dynamic> _$TileCollectionToJson(TileCollection instance) =>
    <String, dynamic>{
      'movie': instance.movie,
      'targetMovie': instance.targetMovie,
      'status': _$TileStatusEnumMap[instance.status]!,
      'tiles': instance.tiles,
    };

const _$TileStatusEnumMap = {
  TileStatus.win: 'win',
  TileStatus.loss: 'loss',
  TileStatus.none: 'none',
};
