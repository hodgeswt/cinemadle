import 'dart:convert';

import 'package:cinemadle/data_model/paginated_results.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import 'package:universal_io/io.dart';

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

  Future<PaginatedResults> getPopular() async {
    DateTime today = DateTime.now();
    String date = "${today.year}-${today.month}-${today.day}";

    Map<String, dynamic> response = await _getRequest(
        "discover/movie?certification=G%7CPG%7CPG-13%7CR&include_adult=false&include_video=false&language=en-US&page=1&primary_release_date.gte=1950-01-01&primary_release_date.lte=$date&sort_by=popularity.desc");

    return PaginatedResults.fromJson(response);
  }

  Future<Map<String, dynamic>> _getRequest(String endpoint) async {
    Response resp = await _dio.get(endpoint);
    return resp.data;
  }
}
