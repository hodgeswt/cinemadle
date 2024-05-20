// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'release_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReleaseInfo _$ReleaseInfoFromJson(Map<String, dynamic> json) => ReleaseInfo(
      iso: json['iso_3166_1'] as String,
      releaseDates: (json['release_dates'] as List<dynamic>)
          .map((e) => ReleaseDate.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ReleaseInfoToJson(ReleaseInfo instance) =>
    <String, dynamic>{
      'iso_3166_1': instance.iso,
      'release_dates': instance.releaseDates,
    };
