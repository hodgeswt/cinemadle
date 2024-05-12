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
  });

  final MovieRecord movie;

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  final MovieData md = MovieData.instance;

  List<Widget> row1 = <Widget>[
    TextCard(text: Utils.emptyString),
    TextCard(text: Utils.emptyString),
    TextCard(text: Utils.emptyString),
  ];

  List<Widget> row2 = <Widget>[
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
          row1 = <Widget>[
            TextCard(text: "Languager: ${movieDetails.originalLanguage}"),
            TextCard(text: "Runtime: ${movieDetails.runtime} minutes"),
            TextCard(text: "Release Daste: ${movieDetails.releaseDate}"),
          ];

          row2 = <Widget>[
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

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(children: <Widget>[TextCard(text: title, widthScale: 3)]),
          Row(children: row1),
          Row(children: row2),
        ],
      ),
    );
  }
}
