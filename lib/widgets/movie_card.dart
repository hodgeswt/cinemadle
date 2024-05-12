import 'package:cinemadle/data_model/movie_details.dart';
import 'package:cinemadle/data_model/movie_record.dart';
import 'package:cinemadle/movie_data.dart';
import 'package:cinemadle/utils.dart';
import 'package:cinemadle/widgets/text_card.dart';
import 'package:flutter/material.dart';

class MovieCard extends StatefulWidget {
  const MovieCard({
    super.key,
    required this.movie,
    required this.maxWidth,
    required this.maxHeight,
  });

  final MovieRecord movie;
  final double maxWidth;
  final double maxHeight;

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  final MovieData md = MovieData.instance;

  List<Widget> movies = <Widget>[
    TextCard(text: Utils.emptyString),
    TextCard(text: Utils.emptyString),
    TextCard(text: Utils.emptyString),
    TextCard(text: Utils.emptyString),
    TextCard(text: Utils.emptyString),
    TextCard(text: Utils.emptyString),
  ];

  String title = Utils.emptyString;

  _updateState(MovieDetails movieDetails) {
    if (mounted) {
      setState(
        () {
          title = movieDetails.title;
          movies = <Widget>[
            TextCard(text: "Languager: ${movieDetails.originalLanguage}"),
            TextCard(text: "Runtime: ${movieDetails.runtime} minutes"),
            TextCard(text: "Release Daste: ${movieDetails.releaseDate}"),
            TextCard(text: "Budget: ${movieDetails.budget}"),
            TextCard(text: "Rating: ${movieDetails.voteAverage}"),
            TextCard(text: "Tagline: ${movieDetails.tagline}"),
          ];
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    md
        .getDetails(widget.movie.id)
        .then((movieDetails) => {_updateState(movieDetails)});

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 8.0,
          ),
          child: SizedBox(
            width: (widget.maxWidth - 16.0) / 2,
            height: (widget.maxHeight - 16.0),
            child: Card(
              clipBehavior: Clip.antiAlias,
              color: Theme.of(context).cardColor,
              child: GridView.count(
                primary: false,
                padding: const EdgeInsets.all(16.0),
                crossAxisCount: 1,
                crossAxisSpacing: 16,
                children: <Widget>[
                  TextCard(text: title),
                  GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(16.0),
                    crossAxisCount: 3,
                    crossAxisSpacing: 16,
                    children: movies,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
