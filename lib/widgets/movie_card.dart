import 'package:cinemadle/data_model/movie_details.dart';
import 'package:cinemadle/data_model/movie_record.dart';
import 'package:cinemadle/movie_data.dart';
import 'package:cinemadle/resource_manager.dart';
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

  List<Widget> get tiles => <Widget>[
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: TextCard(
            text: movies?.voteAverage.toString() ?? Utils.emptyString,
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: TextCard(
            text: movies?.originalLanguage ?? Utils.emptyString,
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: TextCard(
            text: movies?.releaseDate ?? Utils.emptyString,
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: TextCard(
            text: movies?.revenue.toString() ?? Utils.emptyString,
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: TextCard(
            text: movies?.runtime.toString() ?? Utils.emptyString,
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: TextCard(
            text: movies?.popularity.toString() ?? Utils.emptyString,
          ),
        ),
      ];

  MovieDetails? movies;

  Size? size;

  @override
  Widget build(BuildContext context) {
    md.getDetails(widget.movie.id).then((movieDetails) => {
          setState(() {
            if (mounted) {
              movies = movieDetails;
            }
          })
        });

    Size mqSize = MediaQuery.of(context).size;
    size = Size((mqSize.width / 2) - 8 * 3, (mqSize.height / 2) - 8 * 3);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Container(
        width: size?.width,
        height: size?.height,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 1.0,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: Colors.grey,
        ),
        child: StaggeredGrid.count(
          crossAxisCount: 3,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
          children: <Widget>[
            StaggeredGridTile.count(
              crossAxisCellCount: 3,
              mainAxisCellCount: 1,
              child: TextCard(
                text: movies?.title ?? Utils.emptyString,
                height: (size?.height ?? 3 / 3),
              ),
            ),
            ...tiles,
          ],
        ),
      ),
    );
  }
}
