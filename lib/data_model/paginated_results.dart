import 'package:cinemadle/data_model/movie_record.dart';
import 'package:json_annotation/json_annotation.dart';

part 'paginated_results.g.dart';

@JsonSerializable()
class PaginatedResults {
  @JsonKey(name: "page")
  final int page;

  @JsonKey(name: "total_pages")
  final int totalPages;

  @JsonKey(name: "total_results")
  final int totalResults;

  @JsonKey(name: "results")
  final List<MovieRecord> results;

  PaginatedResults({
    required this.results,
    required this.page,
    required this.totalPages,
    required this.totalResults,
  });

  factory PaginatedResults.fromJson(Map<String, dynamic> json) =>
      _$PaginatedResultsFromJson(json);

  Map<String, dynamic> toJson() => _$PaginatedResultsToJson(this);
}
