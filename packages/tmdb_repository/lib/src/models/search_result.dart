import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tmdb_api/tmdb_api.dart';

part 'search_result.g.dart';

@JsonSerializable()
class SearchResult extends Equatable {
  const SearchResult({
    required this.id,
    required this.title,
  });

  final int id;
  final String title;

  factory SearchResult.fromJson(Map<String, dynamic> json) =>
      _$SearchResultFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResultToJson(this);

  factory SearchResult.fromMovieRecord(MovieRecord movieData) {
    return SearchResult(id: movieData.id, title: movieData.title);
  }

  @override
  List<Object> get props => [
        id,
        title,
      ];
}
