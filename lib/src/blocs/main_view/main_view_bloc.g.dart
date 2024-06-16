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
          ?.map((e) => TileCollection.fromJson(e as Map<String, dynamic>))
          .toList(),
      userGuessesIds: (json['userGuessesIds'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      remainingGuesses:
          (json['remainingGuesses'] as num?)?.toInt() ?? userGuessLimit,
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
      userScore: $enumDecodeNullable(_$TileColorEnumMap, json['userScore']),
      mpaRating: $enumDecodeNullable(_$TileColorEnumMap, json['mpaRating']),
      releaseDate: $enumDecodeNullable(_$TileColorEnumMap, json['releaseDate']),
      revenue: $enumDecodeNullable(_$TileColorEnumMap, json['revenue']),
      runtime: $enumDecodeNullable(_$TileColorEnumMap, json['runtime']),
      genre: $enumDecodeNullable(_$TileColorEnumMap, json['genre']),
      director: $enumDecodeNullable(_$TileColorEnumMap, json['director']),
      writer: $enumDecodeNullable(_$TileColorEnumMap, json['writer']),
      firstInCast: $enumDecodeNullable(_$TileColorEnumMap, json['firstInCast']),
      userScoreArrow: json['userScoreArrow'] as String?,
      mpaRatingArrow: json['mpaRatingArrow'] as String?,
      releaseDateArrow: json['releaseDateArrow'] as String?,
      runtimeArrow: json['runtimeArrow'] as String?,
      revenueArrow: json['revenueArrow'] as String?,
      boldGenre:
          (json['boldGenre'] as List<dynamic>?)?.map((e) => e as bool).toList(),
      boldCast:
          (json['boldCast'] as List<dynamic>?)?.map((e) => e as bool).toList(),
    );

Map<String, dynamic> _$MovieTileDataToJson(MovieTileData instance) =>
    <String, dynamic>{
      'userScore': _$TileColorEnumMap[instance.userScore],
      'mpaRating': _$TileColorEnumMap[instance.mpaRating],
      'releaseDate': _$TileColorEnumMap[instance.releaseDate],
      'revenue': _$TileColorEnumMap[instance.revenue],
      'runtime': _$TileColorEnumMap[instance.runtime],
      'genre': _$TileColorEnumMap[instance.genre],
      'director': _$TileColorEnumMap[instance.director],
      'writer': _$TileColorEnumMap[instance.writer],
      'firstInCast': _$TileColorEnumMap[instance.firstInCast],
      'userScoreArrow': instance.userScoreArrow,
      'mpaRatingArrow': instance.mpaRatingArrow,
      'releaseDateArrow': instance.releaseDateArrow,
      'runtimeArrow': instance.runtimeArrow,
      'revenueArrow': instance.revenueArrow,
      'boldGenre': instance.boldGenre,
      'boldCast': instance.boldCast,
    };

const _$TileColorEnumMap = {
  TileColor.green: 'green',
  TileColor.yellow: 'yellow',
  TileColor.red: 'red',
  TileColor.grey: 'grey',
};
