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
  });

  final MovieRecord movie;

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  final MovieData md = MovieData.instance;
  final ResourceManager rm = ResourceManager.instance;

  String _getMpaRating() {
    return movie?.releaseDates?.results
            .firstWhere((x) {
              return x.iso == "US";
            })
            .releaseDates
            .last
            .certification ??
        rm.getResource(Resources.unknown);
  }

  String _getMovieDirector() {
    return credits?.crew.firstWhere((x) {
          return x.job == "Director";
        }).name ??
        rm.getResource(Resources.unknown);
  }

  String _getMovieWriter() {
    return credits?.crew.firstWhere((x) {
          return x.job == "Screenplay" || x.job == "Writer";
        }).name ??
        rm.getResource(Resources.unknown);
  }

  String _getFirstInCast() {
    return credits?.cast.firstWhere((x) {
          return x.order == 0;
        }).name ??
        rm.getResource(Resources.unknown);
  }

  List<Widget> get tiles => <Widget>[
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: TextCard(
            text:
                "${rm.getResource(Resources.movieUserScoreCaption)}${movie?.voteAverage} / 10",
            horizontalPadding: subTilePadding,
            verticalPadding: subTilePadding,
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: TextCard(
            text: _getMpaRating(),
            horizontalPadding: subTilePadding,
            verticalPadding: subTilePadding,
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
          ),
        ),
      ];

  MovieDetails? movie;
  Credits? credits;

  late Size size;
  late double subTilePadding;

  @override
  Widget build(BuildContext context) {
    md.getDetails(widget.movie.id).then((movieDetails) => {
          setState(() {
            if (mounted) {
              movie = movieDetails;
            }
          })
        });

    md.getMovieCredits(widget.movie.id).then((movieCredits) => {
          setState(() {
            if (mounted) {
              credits = movieCredits;
            }
          })
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
          color: Colors.grey,
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
