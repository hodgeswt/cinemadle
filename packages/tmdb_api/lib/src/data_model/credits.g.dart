// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credits.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Credits _$CreditsFromJson(Map<String, dynamic> json) => Credits(
      id: (json['id'] as num).toInt(),
      cast: (json['cast'] as List<dynamic>)
          .map((e) => MovieCredit.fromJson(e as Map<String, dynamic>))
          .toList(),
      crew: (json['crew'] as List<dynamic>)
          .map((e) => MovieCredit.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CreditsToJson(Credits instance) => <String, dynamic>{
      'id': instance.id,
      'cast': instance.cast,
      'crew': instance.crew,
    };
