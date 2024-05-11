import 'package:cinemadle/data_model/movie_record.dart';
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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 8.0,
      ),
      child: SizedBox(
        width: (widget.maxWidth - 16.0) / 2,
        height: (widget.maxHeight - 16.0) / 2,
        child: Card(
          clipBehavior: Clip.antiAlias,
          color: Theme.of(context).cardColor,
          child: Text(widget.movie.title),
        ),
      ),
    );
  }
}
