// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'release_dates.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReleaseDates _$ReleaseDatesFromJson(Map<String, dynamic> json) => ReleaseDates(
      results: (json['results'] as List<dynamic>)
          .map((e) => ReleaseInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ReleaseDatesToJson(ReleaseDates instance) =>
    <String, dynamic>{
      'results': instance.results,
    };
