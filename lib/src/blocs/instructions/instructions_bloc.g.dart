// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instructions_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstructionsState _$InstructionsStateFromJson(Map<String, dynamic> json) =>
    InstructionsState(
      status: $enumDecodeNullable(
              _$InstructionsStateStatusEnumMap, json['status']) ??
          InstructionsStateStatus.initial,
      index: (json['index'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? "Loading...",
      content: json['content'] as String? ?? "Loading...",
      canGoBack: json['canGoBack'] as bool? ?? false,
    );

Map<String, dynamic> _$InstructionsStateToJson(InstructionsState instance) =>
    <String, dynamic>{
      'status': _$InstructionsStateStatusEnumMap[instance.status]!,
      'index': instance.index,
      'title': instance.title,
      'content': instance.content,
      'canGoBack': instance.canGoBack,
    };

const _$InstructionsStateStatusEnumMap = {
  InstructionsStateStatus.initial: 'initial',
  InstructionsStateStatus.introduction: 'introduction',
  InstructionsStateStatus.overview: 'overview',
  InstructionsStateStatus.detail: 'detail',
  InstructionsStateStatus.userScoreDescription: 'userScoreDescription',
  InstructionsStateStatus.mpaRatingDescription: 'mpaRatingDescription',
  InstructionsStateStatus.releaseDateDescription: 'releaseDateDescription',
  InstructionsStateStatus.revenueDescription: 'revenueDescription',
  InstructionsStateStatus.runtimeDescription: 'runtimeDescription',
  InstructionsStateStatus.genreDescription: 'genreDescription',
  InstructionsStateStatus.directorDescription: 'directorDescription',
  InstructionsStateStatus.writerDescription: 'writerDescription',
  InstructionsStateStatus.firstInCastDescription: 'firstInCastDescription',
  InstructionsStateStatus.completed: 'completed',
};
