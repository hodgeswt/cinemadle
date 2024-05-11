// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_results.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginatedResults _$PaginatedResultsFromJson(Map<String, dynamic> json) =>
    PaginatedResults(
      results: (json['results'] as List<dynamic>)
          .map((e) => ResultRecord.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: (json['page'] as num).toInt(),
      totalPages: (json['total_pages'] as num).toInt(),
      totalResults: (json['total_results'] as num).toInt(),
    );

Map<String, dynamic> _$PaginatedResultsToJson(PaginatedResults instance) =>
    <String, dynamic>{
      'page': instance.page,
      'total_pages': instance.totalPages,
      'total_results': instance.totalResults,
      'results': instance.results,
    };
