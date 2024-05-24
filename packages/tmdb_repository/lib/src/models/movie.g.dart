// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Movie _$MovieFromJson(Map<String, dynamic> json) => Movie(
      director: json['director'] as String,
      genre: (json['genre'] as List<dynamic>).map((e) => e as String).toList(),
      id: (json['id'] as num).toInt(),
      lead: json['lead'] as String,
      mpaRating: json['mpaRating'] as String,
      releaseDate: json['releaseDate'] as String,
      revenue: (json['revenue'] as num).toInt(),
      runtime: (json['runtime'] as num).toInt(),
      title: json['title'] as String,
      voteAverage: (json['voteAverage'] as num).toDouble(),
      writer: json['writer'] as String,
      posterPath: json['posterPath'] as String,
    );

Map<String, dynamic> _$MovieToJson(Movie instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'runtime': instance.runtime,
      'voteAverage': instance.voteAverage,
      'mpaRating': instance.mpaRating,
      'releaseDate': instance.releaseDate,
      'revenue': instance.revenue,
      'genre': instance.genre,
      'director': instance.director,
      'writer': instance.writer,
      'lead': instance.lead,
      'posterPath': instance.posterPath,
    };
