import 'package:cinemadle/data_model/credits.dart';
import 'package:cinemadle/data_model/movie_details.dart';
import 'package:cinemadle/data_model/movie_record.dart';
import 'package:cinemadle/movie_data.dart';
import 'package:cinemadle/resource_manager.dart';
import 'package:cinemadle/resources.dart';
import 'package:cinemadle/utils.dart';
import 'package:cinemadle/widgets/text_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MovieCard extends StatefulWidget {
  const MovieCard({
    super.key,
    required this.movie,
    required this.target,
  });

  final MovieRecord movie;
  final MovieRecord? target;

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  final MovieData md = MovieData.instance;
  final ResourceManager rm = ResourceManager.instance;

  String _getMpaRating() {
    return _getArbitraryMpaRating(movie);
  }

  String _getTargetMpaRating() {
    return _getArbitraryMpaRating(targetDetails);
  }

  String _getArbitraryMpaRating(MovieDetails? m) {
    try {
      String? cert = m?.releaseDates?.results
          .firstWhere((x) {
            return x.iso == "US";
          })
          .releaseDates
          .last
          .certification;
      return (cert?.isEmpty ?? true)
          ? rm.getResource(Resources.unknown)
          : cert!;
    } catch (_) {
      return rm.getResource(Resources.unknown);
    }
  }

  String _getArbitraryCrewRole(Credits? c, List<String> jobs) {
    try {
      return c?.crew.firstWhere((x) {
            return jobs.contains(x.job);
          }).name ??
          rm.getResource(Resources.unknown);
    } catch (_) {
      return rm.getResource(Resources.unknown);
    }
  }

  String _getMovieDirector() {
    return _getArbitraryCrewRole(credits, ["Director"]);
  }

  String _getMovieWriter() {
    return _getArbitraryCrewRole(credits, ["Screenplay", "Writer"]);
  }

  String _getTargetDirector() {
    return _getArbitraryCrewRole(targetCredits, ["Director"]);
  }

  String _getTargetWriter() {
    return _getArbitraryCrewRole(targetCredits, ["Screenplay", "Writer"]);
  }

  String _getArbitraryFirstInCast(Credits? c) {
    try {
      return c?.cast.firstWhere((x) {
            return x.order == 0;
          }).name ??
          rm.getResource(Resources.unknown);
    } catch (_) {
      return rm.getResource(Resources.unknown);
    }
  }

  bool _isGussedActorInCast() {
    try {
      return targetCredits?.cast.any((x) {
            return credits?.cast.any((y) {
                  return y.name == x.name;
                }) ??
                false;
          }) ??
          false;
    } catch (_) {
      return false;
    }
  }

  String _getFirstInCast() {
    return _getArbitraryFirstInCast(credits);
  }

  String _getTargetFirstInCast() {
    return _getArbitraryFirstInCast(targetCredits);
  }

  Map<String, Color> tileColors = {
    "userScore": Colors.grey,
    "mpaRating": Colors.grey,
    "releaseDate": Colors.grey,
    "revenue": Colors.grey,
    "runtime": Colors.grey,
    "popularity": Colors.grey,
    "director": Colors.grey,
    "writer": Colors.grey,
    "lead": Colors.grey,
  };

  List<Widget> get tiles => <Widget>[
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: TextCard(
            text:
                "${rm.getResource(Resources.movieUserScoreCaption)}${movie?.voteAverage} / 10",
            horizontalPadding: subTilePadding,
            verticalPadding: subTilePadding,
            color: tileColors["userScore"] ?? Colors.grey,
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: TextCard(
            text:
                "${rm.getResource(Resources.movieRatingCaption)}${_getMpaRating()}",
            horizontalPadding: subTilePadding,
            verticalPadding: subTilePadding,
            color: tileColors["mpaRating"] ?? Colors.grey,
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: TextCard(
            text:
                "${rm.getResource(Resources.movieReleaseDateCaption)}${Utils.formatDate(movie?.releaseDate)}",
            horizontalPadding: subTilePadding,
            verticalPadding: subTilePadding,
            color: tileColors["releaseDate"] ?? Colors.grey,
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: TextCard(
            text:
                "${rm.getResource(Resources.movieRevenueCaption)}${Utils.formatIntToDollars(movie?.revenue)}",
            horizontalPadding: subTilePadding,
            verticalPadding: subTilePadding,
            color: tileColors["revenue"] ?? Colors.grey,
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: TextCard(
            text:
                "${rm.getResource(Resources.movieRuntimeCaption)}${movie?.runtime}${rm.getResource(Resources.minutesLabel)}",
            horizontalPadding: subTilePadding,
            verticalPadding: subTilePadding,
            color: tileColors["runtime"] ?? Colors.grey,
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: TextCard(
            text:
                "${rm.getResource(Resources.moviePopularityCaption)}${movie?.popularity}",
            horizontalPadding: subTilePadding,
            verticalPadding: subTilePadding,
            color: tileColors["popularity"] ?? Colors.grey,
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: TextCard(
            text:
                "${rm.getResource(Resources.movieDirectorCaption)}${_getMovieDirector()}",
            horizontalPadding: subTilePadding,
            verticalPadding: subTilePadding,
            color: tileColors["director"] ?? Colors.grey,
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: TextCard(
            text:
                "${rm.getResource(Resources.movieWriterCaption)}${_getMovieWriter()}",
            horizontalPadding: subTilePadding,
            verticalPadding: subTilePadding,
            color: tileColors["writer"] ?? Colors.grey,
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: TextCard(
            text:
                "${rm.getResource(Resources.movieFirstActingCreditCaption)}${_getFirstInCast()}",
            horizontalPadding: subTilePadding,
            verticalPadding: subTilePadding,
            color: tileColors["lead"] ?? Colors.grey,
          ),
        ),
      ];

  MovieDetails? movie;
  MovieDetails? targetDetails;
  Credits? credits;
  Credits? targetCredits;

  late Size size;
  late double subTilePadding;

  @override
  Widget build(BuildContext context) {
    if (widget.target?.id != null) {
      md.getDetails(widget.target?.id ?? -1).then((movieDetails) => {
            if (mounted)
              {
                setState(() {
                  targetDetails = movieDetails;
                })
              }
          });

      md.getMovieCredits(widget.target?.id ?? -1).then((movieCredits) => {
            if (mounted)
              {
                setState(() {
                  targetCredits = movieCredits;
                })
              }
          });
    }

    md.getDetails(widget.movie.id).then((movieDetails) => {
          if (mounted)
            {
              setState(() {
                movie = movieDetails;

                double voteDiff = ((movie?.voteAverage ?? 0) -
                        (widget.target?.voteAverage ?? 0))
                    .abs();
                Color userScore = voteDiff == 0
                    ? Colors.green
                    : (voteDiff <= 1 ? Colors.yellow : Colors.grey);
                tileColors["userScore"] = userScore;

                int mpaDiff = (Utils.mapMpaRatingToInt(_getMpaRating()) -
                        Utils.mapMpaRatingToInt(_getTargetMpaRating()))
                    .abs();
                Color mpaRating = mpaDiff == 0
                    ? Colors.green
                    : (mpaDiff <= 1 ? Colors.yellow : Colors.grey);
                tileColors["mpaRating"] = mpaRating;

                Duration dateDiff = Utils.parseDate(movie?.releaseDate)
                    .difference(Utils.parseDate(targetDetails?.releaseDate))
                    .abs();
                Color releaseDate = dateDiff.inDays == 0
                    ? Colors.green
                    : (dateDiff.inDays <= (365 * 5)
                        ? Colors.yellow
                        : Colors.grey);
                tileColors["releaseDate"] = releaseDate;

                int revenueDiff =
                    ((movie?.revenue ?? 0) - (targetDetails?.revenue ?? 0))
                        .abs();
                Color revenue = revenueDiff == 0
                    ? Colors.green
                    : (revenueDiff <= 50000000 ? Colors.yellow : Colors.grey);
                tileColors["revenue"] = revenue;

                int runtimeDiff =
                    ((movie?.runtime ?? 0) - (targetDetails?.runtime ?? 0))
                        .abs();
                Color runtime = runtimeDiff == 0
                    ? Colors.green
                    : (runtimeDiff <= 20 ? Colors.yellow : Colors.grey);
                tileColors["runtime"] = runtime;

                double popularityDiff = ((movie?.popularity ?? 0) -
                        (targetDetails?.popularity ?? 0))
                    .abs();
                Color popularity = popularityDiff == 0
                    ? Colors.green
                    : (popularityDiff <= 50 ? Colors.yellow : Colors.grey);
                tileColors["popularity"] = popularity;
              })
            }
        });

    md.getMovieCredits(widget.movie.id).then((movieCredits) => {
          if (mounted)
            {
              setState(() {
                credits = movieCredits;

                Color director = _getMovieDirector() == _getTargetDirector()
                    ? Colors.green
                    : (_getMovieDirector() == _getTargetWriter()
                        ? Colors.yellow
                        : Colors.grey);
                tileColors["director"] = director;

                Color writer = _getMovieWriter() == _getTargetWriter()
                    ? Colors.green
                    : (_getMovieWriter() == _getTargetDirector()
                        ? Colors.yellow
                        : Colors.grey);
                tileColors["writer"] = writer;

                Color lead = _getFirstInCast() == _getTargetFirstInCast()
                    ? Colors.green
                    : (_isGussedActorInCast() ? Colors.yellow : Colors.grey);
                tileColors["lead"] = lead;
              })
            }
        });

    Size mqSize = MediaQuery.of(context).size;
    double width = mqSize.width / 2;
    double height = mqSize.height / 2;

    double widthBox = (110 * 3) + 16;
    if (width > widthBox || width < widthBox) {
      width = widthBox;
    }

    double heightBox = (110 * 4) + 24;
    if (height > heightBox || height < heightBox) {
      height = heightBox;
    }

    size = Size(width, height);

    subTilePadding = 4.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 1.0,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: movie?.title == targetDetails?.title
              ? Colors.lightGreen
              : Colors.black54,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: StaggeredGrid.count(
            crossAxisCount: 3,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
            children: <Widget>[
              StaggeredGridTile.count(
                crossAxisCellCount: 3,
                mainAxisCellCount: 1,
                child: TextCard(
                  text: movie?.title ?? Utils.emptyString,
                  horizontalPadding: subTilePadding,
                  verticalPadding: subTilePadding,
                  color: movie?.title == targetDetails?.title
                      ? Colors.green
                      : Colors.grey,
                ),
              ),
              ...tiles,
            ],
          ),
        ),
      ),
    );
  }
}
