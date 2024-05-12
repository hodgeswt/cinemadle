// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_credit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieCredit _$MovieCreditFromJson(Map<String, dynamic> json) => MovieCredit(
      id: (json['id'] as num).toInt(),
      adult: json['adult'] as bool?,
      castId: (json['cast_id'] as num?)?.toInt(),
      character: json['character'] as String?,
      creditId: json['credit_id'] as String?,
      gender: (json['gender'] as num?)?.toInt(),
      knownForDepartment: json['known_for_department'] as String?,
      name: json['name'] as String,
      order: (json['order'] as num?)?.toInt(),
      originalName: json['original_name'] as String?,
      popularity: (json['popularity'] as num?)?.toDouble(),
      profilePath: json['profile_path'] as String?,
      job: json['job'] as String?,
    );

Map<String, dynamic> _$MovieCreditToJson(MovieCredit instance) =>
    <String, dynamic>{
      'id': instance.id,
      'adult': instance.adult,
      'gender': instance.gender,
      'known_for_department': instance.knownForDepartment,
      'name': instance.name,
      'original_name': instance.originalName,
      'popularity': instance.popularity,
      'profile_path': instance.profilePath,
      'cast_id': instance.castId,
      'character': instance.character,
      'credit_id': instance.creditId,
      'order': instance.order,
      'job': instance.job,
    };
