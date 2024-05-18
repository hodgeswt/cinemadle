import 'package:cinemadle/data_model/credits.dart';
import 'package:cinemadle/data_model/genre_detail.dart';
import 'package:cinemadle/data_model/movie_details.dart';
import 'package:cinemadle/movie_data.dart';
import 'package:cinemadle/resource_manager.dart';
import 'package:cinemadle/resources.dart';
import 'package:cinemadle/utils.dart';

/// A way to store the relevant information
/// about a movie card so that we don't
/// have to re-process the results object
/// every time we render the card
class MovieCardData {
  /// The DB movie ID
  late int id;

  /// The title of the movie
  late String title;

  /// Runtime of the film
  late int runtime;

  /// The average user rating
  late double voteAverage;

  /// The MPA movie rating
  late String mpaRating;

  /// Setter for release date
  set releaseDate(String val) {
    _unformattedReleaseDate ??= val;
  }

  /// Formats the release date if needed,
  /// otherwise returns the formatted date string
  String get releaseDate {
    _formattedReleaseDate ??= Utils.formatDate(_unformattedReleaseDate);
    return _formattedReleaseDate!;
  }

  /// Internal storage for the unformatted
  /// release date string
  String? _unformattedReleaseDate;

  /// Internal storage for the formatted
  /// release date string
  String? _formattedReleaseDate;

  /// Setter for the revenue
  set _revenue(int val) {
    _unformattedRevenue = val;
  }

  int get revenueInt {
    return _unformattedRevenue ?? 0;
  }

  /// Formats the revenue if needed,
  /// otherwise returns the formatted revenue string
  String get revenue {
    _formattedRevenue ??= Utils.formatIntToDollars(_unformattedRevenue);

    return _formattedRevenue!;
  }

  /// Internal storage for the unformatted
  /// revenue value
  int? _unformattedRevenue;

  /// Internal storage for the formatted
  /// revenue value
  String? _formattedRevenue;

  /// Genre of the movie
  late String genre;

  /// Director of the movie
  late String director;

  /// Writer of the movie
  late String writer;

  /// Lead actor of the movie
  late String lead;

  /// Resource gatherer
  final ResourceManager _rm = ResourceManager.instance;

  /// API wrapper
  final MovieData _md = MovieData.instance;

  /// Indicates if this movie's lead actor
  /// is in the target movie's cast
  late bool isLeadInTarget;

  /// Indicates if this is the target card
  late bool isSameAsTarget;

  /// Pulls the MPA rating of a movie from its details
  String _getArbitraryMpaRating(MovieDetails? m) {
    if (m == null) {
      return _rm.getResource(Resources.unknown);
    }

    try {
      DateTime? base = DateTime.tryParse(m.releaseDate);
      String? cert = m.releaseDates?.results
          .firstWhere((x) {
            return x.iso == "US";
          })
          .releaseDates
          .firstWhere((x) {
            DateTime? y = DateTime.tryParse(m.releaseDate);
            if (base == null || y == null) {
              return x.certification != Utils.emptyString;
            }

            return (base.year == y.year) &&
                (base.day == y.day) &&
                (base.month == y.month) &&
                x.certification != Utils.emptyString;
          })
          .certification;
      return (cert?.isEmpty ?? false)
          ? _rm.getResource(Resources.unknown)
          : cert!;
    } catch (_) {
      return _rm.getResource(Resources.unknown);
    }
  }

  /// Pulls the first person matching specified crew roles
  String _getArbitraryCrewRole(Credits? c, List<String> jobs) {
    try {
      return c?.crew.firstWhere((x) {
            return jobs.contains(x.job);
          }).name ??
          _rm.getResource(Resources.unknown);
    } catch (_) {
      return _rm.getResource(Resources.unknown);
    }
  }

  /// Pulls first person in cast
  String _getArbitraryFirstInCast(Credits? c) {
    try {
      return c?.cast.firstWhere((x) {
            return x.order == 0;
          }).name ??
          _rm.getResource(Resources.unknown);
    } catch (_) {
      return _rm.getResource(Resources.unknown);
    }
  }

  /// Indicates if this movie's lead is in the
  /// target movie's credits
  bool _isGuessedLeadInTargetCast(String? lead, Credits? targetCredits) {
    if (lead == null) {
      return false;
    }

    try {
      return targetCredits?.cast.any((x) => x.name == lead) ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Grab the first three genres and concatenate
  /// them into a comma-separated list
  String _getGenre(MovieDetails movieDetails) {
    Iterable<GenreDetail> genres = movieDetails.genres.take(3);
    String out = Utils.emptyString;

    for (GenreDetail genre in genres) {
      out += "${genre.name},\n";
    }

    if (out.isNotEmpty) {
      return out.substring(0, out.length - 2);
    }

    return _rm.getResource(Resources.unknown);
  }

  /// Loads the data from the movie IDs
  loadData(int movieId, int targetId) async {
    if (movieId == targetId) {
      isSameAsTarget = true;
    } else {
      isSameAsTarget = false;
    }

    await _loadMovieData(movieId);

    Credits targetCredits = await _md.getMovieCredits(targetId);

    isLeadInTarget = _isGuessedLeadInTargetCast(lead, targetCredits);
  }

  /// Loads this movie's data
  Future<void> _loadMovieData(int movieId) async {
    MovieDetails? movieDetails;
    Credits? movieCredits;

    await _md.getDetails(movieId).then((data) {
      movieDetails = data;
    });

    await _md.getMovieCredits(movieId).then((data) {
      movieCredits = data;
    });

    if (movieDetails == null || movieCredits == null) {
      throw Exception("Unexpected state");
    }

    title = movieDetails!.title;
    runtime = movieDetails!.runtime;
    voteAverage = movieDetails!.voteAverage;
    mpaRating = _getArbitraryMpaRating(movieDetails);
    releaseDate = movieDetails!.releaseDate;
    _revenue = movieDetails!.revenue;
    genre = _getGenre(movieDetails!);
    director = _getArbitraryCrewRole(movieCredits, ["Director"]);
    writer = _getArbitraryCrewRole(movieCredits, ["Screenplay", "Writer"]);
    lead = _getArbitraryFirstInCast(movieCredits);
    id = movieId;
  }

  /// Create an empty object
  MovieCardData();
}
