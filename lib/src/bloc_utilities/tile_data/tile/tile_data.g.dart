// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tile_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TileData _$TileDataFromJson(Map<String, dynamic> json) => TileData(
      color: $enumDecode(_$TileColorEnumMap, json['color']),
      title: json['title'] as String,
      content: json['content'] as String,
      arrow: json['arrow'] as String,
      emphasized:
          (json['emphasized'] as List<dynamic>).map((e) => e as bool).toList(),
    );

Map<String, dynamic> _$TileDataToJson(TileData instance) => <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
      'arrow': instance.arrow,
      'emphasized': instance.emphasized,
      'color': _$TileColorEnumMap[instance.color]!,
    };

const _$TileColorEnumMap = {
  TileColor.green: 'green',
  TileColor.yellow: 'yellow',
  TileColor.red: 'red',
  TileColor.grey: 'grey',
};
