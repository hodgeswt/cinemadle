// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'genre_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenreDetail _$GenreDetailFromJson(Map<String, dynamic> json) => GenreDetail(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$GenreDetailToJson(GenreDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
