import 'dart:async';

import 'package:tmdb_api/tmdb_api.dart';
import 'package:tmdb_repository/src/env.dart';
import 'package:tmdb_repository/tmdb_repository.dart';
import 'package:universal_io/io.dart';

class TmdbRepository {
  TmdbRepository() {
    _tmdbApiClient = TmdbApiClient.instance;
    _tmdbApiClient.setApiKey(Env.d);
    _tmdbApiClient.localeName = Platform.localeName;
  }

  late TmdbApiClient _tmdbApiClient;

  static const int _minVotes = 7000;
  static const int _minRating = 5;

  Future<List<SearchResult>> search(String text, List<int> blacklist,
      {bool preventRecurse = false, int page = 1}) async {
    PaginatedResults search = await _tmdbApiClient.searchMovie(text);

    List<SearchResult> res = search.results
        .where((x) {
          return x.voteCount >= _minVotes &&
              x.voteAverage >= _minRating &&
              !blacklist.contains(x.id);
        })
        .map((y) => SearchResult.fromMovieRecord(y))
        .toList();

    if (!preventRecurse && res.length < 10 && search.totalPages >= 2) {
      blacklist.addAll(res.map((y) => y.id));
      Iterable<SearchResult> data = await this.search(text, blacklist,
          preventRecurse: page >= 2 || res.isNotEmpty, page: 2);
      res.addAll(data);
    }

    return res.take(10).toList();
  }

  Future<Movie> getMovieFromPage(int page, int index) async {
    PaginatedResults pageData =
        await _tmdbApiClient.getHighestRated(_minVotes, _minRating, page: page);

    int id = pageData.results[index].id;

    final MovieDetails details = await _tmdbApiClient.getDetails(id);
    final Credits credits = await _tmdbApiClient.getMovieCredits(id);

    return Movie.fromRaw(credits, details);
  }

  Future<Movie> getMovie(int id) async {
    final MovieDetails details = await _tmdbApiClient.getDetails(id);
    final Credits credits = await _tmdbApiClient.getMovieCredits(id);

    return Movie.fromRaw(credits, details);
  }

  Future<bool> isActorInMovie(String actor, int id) async {
    final Credits credits = await _tmdbApiClient.getMovieCredits(id);
    try {
      return credits.cast.any((x) => x.name == actor);
    } catch (_) {
      return false;
    }
  }
}
