// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'target_movie_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TargetMovieState _$TargetMovieStateFromJson(Map<String, dynamic> json) =>
    TargetMovieState(
      movie: json['movie'] == null
          ? null
          : Movie.fromJson(json['movie'] as Map<String, dynamic>),
      status: $enumDecodeNullable(_$TargetMovieStatusEnumMap, json['status']) ??
          TargetMovieStatus.initial,
    );

Map<String, dynamic> _$TargetMovieStateToJson(TargetMovieState instance) =>
    <String, dynamic>{
      'movie': instance.movie,
      'status': _$TargetMovieStatusEnumMap[instance.status]!,
    };

const _$TargetMovieStatusEnumMap = {
  TargetMovieStatus.initial: 'initial',
  TargetMovieStatus.loading: 'loading',
  TargetMovieStatus.loaded: 'loaded',
  TargetMovieStatus.failed: 'failed',
};
