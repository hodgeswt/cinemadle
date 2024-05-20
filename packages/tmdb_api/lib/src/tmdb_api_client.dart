import 'package:dio/dio.dart';

import 'package:tmdb_api/tmdb_api.dart';

class TmdbApiClient {
  static TmdbApiClient? _instance;

  static List<int> searchableIds = [];

  String _apiKey = "";

  set apiKey(String val) {
    _apiKey = val;
  }

  String localeName = "";

  late final Dio _dio;

  final String _host = "https://api.themoviedb.org/3/";

  static TmdbApiClient get instance {
    _instance ??= TmdbApiClient._();

    return _instance!;
  }

  setApiKey(String apiKey) {
    _apiKey = apiKey;

    _dio.options.headers = {
      "Authorization": "Bearer $_apiKey",
      "accept": "application/json"
    };
  }

  TmdbApiClient._() {
    _dio = Dio();
    _dio.options
      ..baseUrl = _host
      ..validateStatus = (int? status) {
        return status != null && status > 0;
      };
  }

  Future<PaginatedResults> getHighestRated(int voteCount, int voteAverage,
      {int page = 1}) async {
    page = page == 0 ? 1 : page;

    Map<String, dynamic> response = await _getRequest(
        "discover/movie?include_adult=false&include_video=false&language=$localeName&page=$page&sort_by=vote_average.desc&vote_average.gte=$voteAverage&vote_count.gte=$voteCount");

    return PaginatedResults.fromJson(response);
  }

  Future<PaginatedResults> searchMovie(String query, {int page = 1}) async {
    Map<String, dynamic> response = await _getRequest(
        "search/movie?query=$query&include_adult=false&language=en-US&page=$page");

    return PaginatedResults.fromJson(response);
  }

  Future<MovieDetails> getDetails(int movieId) async {
    String endpoint =
        "movie/$movieId?language=$localeName&append_to_response=release_dates";

    Map<String, dynamic> response = await _getRequest(endpoint);

    return MovieDetails.fromJson(response);
  }

  Future<Credits> getMovieCredits(int movieId) async {
    String endpoint = "movie/$movieId/credits?language=$localeName";

    Map<String, dynamic> response = await _getRequest(endpoint);

    return Credits.fromJson(response);
  }

  Future<Map<String, dynamic>> _getRequest(String endpoint) async {
    Response resp = await _dio.get(endpoint);
    return resp.data;
  }
}
