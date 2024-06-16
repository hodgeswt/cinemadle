// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tile _$TileFromJson(Map<String, dynamic> json) => Tile(
      Movie.fromJson(json['movie'] as Map<String, dynamic>),
      $enumDecode(_$TileStatusEnumMap, json['status']),
    )..tileData = TileData.fromJson(json['tileData'] as Map<String, dynamic>);

Map<String, dynamic> _$TileToJson(Tile instance) => <String, dynamic>{
      'movie': instance.movie,
      'status': _$TileStatusEnumMap[instance.status]!,
      'tileData': instance.tileData,
    };

const _$TileStatusEnumMap = {
  TileStatus.win: 'win',
  TileStatus.loss: 'loss',
  TileStatus.none: 'none',
};
