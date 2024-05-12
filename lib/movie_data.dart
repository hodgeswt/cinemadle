import 'package:cinemadle/data_model/movie_details.dart';
import 'package:cinemadle/data_model/movie_record.dart';
import 'package:cinemadle/data_model/paginated_results.dart';
import 'package:cinemadle/resource_manager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import 'package:universal_io/io.dart';
import 'dart:math';

class MovieData {
  static MovieData? _instance;

  late final Dio _dio;
  late final String _apiKey;

  final String _host = "https://api.themoviedb.org/3/";

  static MovieData get instance {
    _instance ??= MovieData._();

    return _instance!;
  }

  MovieData._() {
    _apiKey = dotenv.get('API_KEY', fallback: 'ERROR');

    _dio = Dio();
    _dio.options
      ..baseUrl = _host
      ..validateStatus = (int? status) {
        return status != null && status > 0;
      }
      ..headers = {
        HttpHeaders.userAgentHeader: 'dio',
        "Authorization": "Bearer $_apiKey",
        "accept": "application/json"
      };
  }

  Future<PaginatedResults> getPopular({int page = 1}) async {
    DateTime today = DateTime.now();
    String date = "${today.year}-${today.month}-${today.day}";

    Map<String, dynamic> response = await _getRequest(
        "discover/movie?certification=G%7CPG%7CPG-13%7CR&include_adult=false&include_video=false&language=en-US&page=$page&primary_release_date.gte=1950-01-01&primary_release_date.lte=$date&sort_by=popularity.desc");

    return PaginatedResults.fromJson(response);
  }

  Future<MovieRecord> getTargetMovie() async {
    DateTime now = DateTime.now();

    // Normalize to top 1024
    int m = (DateTime(now.year, now.month, now.day).millisecondsSinceEpoch /
            86400000)
        .round();
    int out = (1 + (sin(m) + 1) * 1024 / 2).round();

    // Pages have 20 results, so this is the page with the movie
    int page = (out / 20).round();
    out %= 20;

    PaginatedResults pageData = await getPopular(page: page);

    return pageData.results[out];
  }

  Future<PaginatedResults> searchMovie(String query) async {
    Map<String, dynamic> response = await _getRequest(
        "search/movie?query=$query&include_adult=false&language=en-US&page=1");

    return PaginatedResults.fromJson(response);
  }

  Future<MovieDetails> getDetails(int movieId) async {
    String endpoint =
        "movie/$movieId?language=${ResourceManager.instance.culture}";

    Map<String, dynamic> response = await _getRequest(endpoint);

    return MovieDetails.fromJson(response);
  }

  Future<Map<String, dynamic>> _getRequest(String endpoint) async {
    Response resp = await _dio.get(endpoint);
    return resp.data;
  }
}
