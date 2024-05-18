import 'package:cinemadle/constants.dart';
import 'package:cinemadle/movie_card_data.dart';
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
    required this.movieData,
    required this.targetData,
    this.isLoss = false,
  });

  final MovieCardData movieData;
  final MovieCardData targetData;
  final bool isLoss;

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  final MovieData md = MovieData.instance;
  final ResourceManager rm = ResourceManager.instance;

  Map<String, Color?> tileColors = {
    "userScore": null,
    "mpaRating": null,
    "releaseDate": null,
    "revenue": null,
    "runtime": null,
    "genre": null,
    "director": null,
    "writer": null,
    "lead": null,
  };

  StaggeredGridTile _tileBuilder(String text, String colorName) {
    return StaggeredGridTile.count(
      crossAxisCellCount: 1,
      mainAxisCellCount: 1,
      child: TextCard(text: text, color: tileColors[colorName]),
    );
  }

  List<Widget> get tiles {
    if (!mounted) {
      return [];
    }

    int r = widget.movieData.revenueInt;
    String rev =
        r == 0 ? rm.getResource(Resources.unknown) : widget.movieData.revenue;

    return <Widget>[
      _tileBuilder(
          "${rm.getResource(Resources.movieUserScoreCaption)}${widget.movieData.voteAverage} / 10",
          "userScore"),
      _tileBuilder(
          "${rm.getResource(Resources.movieRatingCaption)}${widget.movieData.mpaRating}",
          "mpaRating"),
      _tileBuilder(
          "${rm.getResource(Resources.movieReleaseDateCaption)}${widget.movieData.releaseDate}",
          "releaseDate"),
      _tileBuilder(
          "${rm.getResource(Resources.movieRevenueCaption)}$rev", "revenue"),
      _tileBuilder(
          "${rm.getResource(Resources.movieRuntimeCaption)}${widget.movieData.runtime}${rm.getResource(Resources.minutesLabel)}",
          "runtime"),
      _tileBuilder(
          "${rm.getResource(Resources.movieGenreCaption)}${widget.movieData.genre}",
          "genre"),
      _tileBuilder(
          "${rm.getResource(Resources.movieDirectorCaption)}${widget.movieData.director}",
          "director"),
      _tileBuilder(
          "${rm.getResource(Resources.movieWriterCaption)}${widget.movieData.writer}",
          "writer"),
      _tileBuilder(
          "${rm.getResource(Resources.movieFirstActingCreditCaption)}${widget.movieData.lead}",
          "lead"),
    ];
  }

  late Size size;
  late double subTilePadding;

  _setTileColors() {
    if (widget.isLoss) {
      _setAllRed();
      return;
    }

    if (widget.movieData.isSameAsTarget) {
      _setAllGreen();
      return;
    }

    double voteDiff =
        (widget.movieData.voteAverage - widget.targetData.voteAverage).abs();
    Color? userScore = voteDiff == 0
        ? Constants.lightGreen
        : (voteDiff <= 1 ? Constants.goldYellow : null);
    tileColors["userScore"] = userScore;

    int mpaDiff = (Utils.mapMpaRatingToInt(widget.movieData.mpaRating) -
            Utils.mapMpaRatingToInt(widget.targetData.mpaRating))
        .abs();
    Color? mpaRating = mpaDiff == 0
        ? Constants.lightGreen
        : (mpaDiff <= 1 ? Constants.goldYellow : null);
    tileColors["mpaRating"] = mpaRating;

    Duration dateDiff = Utils.parseDate(widget.movieData.releaseDate)
        .difference(Utils.parseDate(widget.targetData.releaseDate))
        .abs();
    Color? releaseDate = dateDiff.inDays == 0
        ? Constants.lightGreen
        : (dateDiff.inDays <= (365 * 5) ? Constants.goldYellow : null);
    tileColors["releaseDate"] = releaseDate;

    int revenueDiff =
        (widget.movieData.revenueInt - widget.targetData.revenueInt).abs();
    Color? revenue = revenueDiff == 0
        ? Constants.lightGreen
        : (revenueDiff <= 50000000 ? Constants.goldYellow : null);
    tileColors["revenue"] = revenue;

    int runtimeDiff =
        (widget.movieData.runtime - widget.targetData.runtime).abs();
    Color? runtime = runtimeDiff == 0
        ? Constants.lightGreen
        : (runtimeDiff <= 20 ? Constants.goldYellow : null);
    tileColors["runtime"] = runtime;

    bool genreMatch = widget.movieData.genre.toLowerCase() ==
        widget.targetData.genre.toLowerCase();
    Color? popularity = genreMatch ? Constants.lightGreen : null;
    tileColors["genre"] = popularity;

    Color? director = widget.movieData.director == widget.targetData.director
        ? Constants.lightGreen
        : (widget.movieData.director == widget.targetData.writer
            ? Constants.goldYellow
            : null);
    tileColors["director"] = director;

    Color? writer = widget.movieData.writer == widget.targetData.writer
        ? Constants.lightGreen
        : (widget.movieData.writer == widget.targetData.director
            ? Constants.goldYellow
            : null);
    tileColors["writer"] = writer;

    Color? lead = widget.movieData.lead == widget.targetData.lead
        ? Constants.lightGreen
        : (widget.movieData.isLeadInTarget ? Constants.goldYellow : null);
    tileColors["lead"] = lead;
  }

  _setAllGreen() {
    setState(() {
      tileColors = {
        "userScore": Constants.lightGreen,
        "mpaRating": Constants.lightGreen,
        "releaseDate": Constants.lightGreen,
        "revenue": Constants.lightGreen,
        "runtime": Constants.lightGreen,
        "genre": Constants.lightGreen,
        "director": Constants.lightGreen,
        "writer": Constants.lightGreen,
        "lead": Constants.lightGreen,
      };
    });
  }

  _setAllRed() {
    setState(() {
      tileColors = {
        "userScore": Constants.lightRed,
        "mpaRating": Constants.lightRed,
        "releaseDate": Constants.lightRed,
        "revenue": Constants.lightRed,
        "runtime": Constants.lightRed,
        "genre": Constants.lightRed,
        "director": Constants.lightRed,
        "writer": Constants.lightRed,
        "lead": Constants.lightRed,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    _setTileColors();
    double width = MediaQuery.of(context).size.width;

    double widthBox = (110 * 3) + 24;
    if (width > widthBox || width < widthBox) {
      width = widthBox;
    }

    subTilePadding = 4.0;

    return Padding(
      padding: Constants.stdPad,
      child: SizedBox(
        width: width,
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: Colors.grey[200],
          child: Padding(
            padding: Constants.doublePad,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    widget.movieData.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(),
                StaggeredGrid.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2,
                  children: tiles,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
