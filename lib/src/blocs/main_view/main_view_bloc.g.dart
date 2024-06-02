// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_view_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MainViewState _$MainViewStateFromJson(Map<String, dynamic> json) =>
    MainViewState(
      status: $enumDecodeNullable(_$MainViewStatusEnumMap, json['status']) ??
          MainViewStatus.playing,
      userGuesses: (json['userGuesses'] as List<dynamic>?)
          ?.map((e) => Movie.fromJson(e as Map<String, dynamic>))
          .toList(),
      userGuessesIds: (json['userGuessesIds'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      remainingGuesses: (json['remainingGuesses'] as num?)?.toInt() ?? 10,
      tileData: (json['tileData'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
            int.parse(k), MovieTileData.fromJson(e as Map<String, dynamic>)),
      ),
      cardFlipControllers:
          (json['cardFlipControllers'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(int.parse(k),
            const FlipCardControllerJsonConverter().fromJson(e as String)),
      ),
      blur: (json['blur'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(int.parse(k),
            const BlurredImageJsonConverter().fromJson(e as String)),
      ),
      allowFlip:
          (json['allowFlip'] as List<dynamic>?)?.map((e) => e as bool).toList(),
      results: json['results'] as String?,
      uuid: (json['uuid'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MainViewStateToJson(MainViewState instance) =>
    <String, dynamic>{
      'status': _$MainViewStatusEnumMap[instance.status]!,
      'userGuesses': instance.userGuesses,
      'userGuessesIds': instance.userGuessesIds,
      'remainingGuesses': instance.remainingGuesses,
      'tileData': instance.tileData?.map((k, e) => MapEntry(k.toString(), e)),
      'cardFlipControllers': instance.cardFlipControllers?.map((k, e) =>
          MapEntry(
              k.toString(), const FlipCardControllerJsonConverter().toJson(e))),
      'blur': instance.blur?.map((k, e) =>
          MapEntry(k.toString(), const BlurredImageJsonConverter().toJson(e))),
      'allowFlip': instance.allowFlip,
      'results': instance.results,
      'uuid': instance.uuid,
    };

const _$MainViewStatusEnumMap = {
  MainViewStatus.playing: 'playing',
  MainViewStatus.win: 'win',
  MainViewStatus.loss: 'loss',
  MainViewStatus.guessNotFound: 'guessNotFound',
  MainViewStatus.fatalError: 'fatalError',
  MainViewStatus.guessLoading: 'guessLoading',
};

MovieTileData _$MovieTileDataFromJson(Map<String, dynamic> json) =>
    MovieTileData(
      userScore: _$JsonConverterFromJson<String, Color?>(
          json['userScore'], const ColorJsonConverter().fromJson),
      mpaRating: _$JsonConverterFromJson<String, Color?>(
          json['mpaRating'], const ColorJsonConverter().fromJson),
      releaseDate: _$JsonConverterFromJson<String, Color?>(
          json['releaseDate'], const ColorJsonConverter().fromJson),
      revenue: _$JsonConverterFromJson<String, Color?>(
          json['revenue'], const ColorJsonConverter().fromJson),
      runtime: _$JsonConverterFromJson<String, Color?>(
          json['runtime'], const ColorJsonConverter().fromJson),
      genre: _$JsonConverterFromJson<String, Color?>(
          json['genre'], const ColorJsonConverter().fromJson),
      director: _$JsonConverterFromJson<String, Color?>(
          json['director'], const ColorJsonConverter().fromJson),
      writer: _$JsonConverterFromJson<String, Color?>(
          json['writer'], const ColorJsonConverter().fromJson),
      firstInCast: _$JsonConverterFromJson<String, Color?>(
          json['firstInCast'], const ColorJsonConverter().fromJson),
      userScoreArrow: json['userScoreArrow'] as String?,
      mpaRatingArrow: json['mpaRatingArrow'] as String?,
      releaseDateArrow: json['releaseDateArrow'] as String?,
      runtimeArrow: json['runtimeArrow'] as String?,
      revenueArrow: json['revenueArrow'] as String?,
    );

Map<String, dynamic> _$MovieTileDataToJson(MovieTileData instance) =>
    <String, dynamic>{
      'userScore': const ColorJsonConverter().toJson(instance.userScore),
      'mpaRating': const ColorJsonConverter().toJson(instance.mpaRating),
      'releaseDate': const ColorJsonConverter().toJson(instance.releaseDate),
      'revenue': const ColorJsonConverter().toJson(instance.revenue),
      'runtime': const ColorJsonConverter().toJson(instance.runtime),
      'genre': const ColorJsonConverter().toJson(instance.genre),
      'director': const ColorJsonConverter().toJson(instance.director),
      'writer': const ColorJsonConverter().toJson(instance.writer),
      'firstInCast': const ColorJsonConverter().toJson(instance.firstInCast),
      'userScoreArrow': instance.userScoreArrow,
      'mpaRatingArrow': instance.mpaRatingArrow,
      'releaseDateArrow': instance.releaseDateArrow,
      'runtimeArrow': instance.runtimeArrow,
      'revenueArrow': instance.revenueArrow,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);
