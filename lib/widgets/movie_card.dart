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

  Map<String, Color> tileColors = {
    "userScore": Constants.grey,
    "mpaRating": Constants.grey,
    "releaseDate": Constants.grey,
    "revenue": Constants.grey,
    "runtime": Constants.grey,
    "genre": Constants.grey,
    "director": Constants.grey,
    "writer": Constants.grey,
    "lead": Constants.grey,
  };

  StaggeredGridTile _tileBuilder(String text, String colorName) {
    return StaggeredGridTile.count(
      crossAxisCellCount: 1,
      mainAxisCellCount: 1,
      child: TextCard(
        text: text,
        horizontalPadding: subTilePadding,
        verticalPadding: subTilePadding,
        color: tileColors[colorName] ?? Constants.grey,
      ),
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
    Color userScore = voteDiff == 0
        ? Constants.darkGreen
        : (voteDiff <= 1 ? Constants.yellow : Constants.grey);
    tileColors["userScore"] = userScore;

    int mpaDiff = (Utils.mapMpaRatingToInt(widget.movieData.mpaRating) -
            Utils.mapMpaRatingToInt(widget.targetData.mpaRating))
        .abs();
    Color mpaRating = mpaDiff == 0
        ? Constants.darkGreen
        : (mpaDiff <= 1 ? Constants.yellow : Constants.grey);
    tileColors["mpaRating"] = mpaRating;

    Duration dateDiff = Utils.parseDate(widget.movieData.releaseDate)
        .difference(Utils.parseDate(widget.targetData.releaseDate))
        .abs();
    Color releaseDate = dateDiff.inDays == 0
        ? Constants.darkGreen
        : (dateDiff.inDays <= (365 * 5) ? Constants.yellow : Constants.grey);
    tileColors["releaseDate"] = releaseDate;

    int revenueDiff =
        (widget.movieData.revenueInt - widget.targetData.revenueInt).abs();
    Color revenue = revenueDiff == 0
        ? Constants.darkGreen
        : (revenueDiff <= 50000000 ? Constants.yellow : Constants.grey);
    tileColors["revenue"] = revenue;

    int runtimeDiff =
        (widget.movieData.runtime - widget.targetData.runtime).abs();
    Color runtime = runtimeDiff == 0
        ? Constants.darkGreen
        : (runtimeDiff <= 20 ? Constants.yellow : Constants.grey);
    tileColors["runtime"] = runtime;

    bool genreMatch = widget.movieData.genre.toLowerCase() ==
        widget.targetData.genre.toLowerCase();
    Color popularity = genreMatch ? Constants.darkGreen : Constants.grey;
    tileColors["genre"] = popularity;

    Color director = widget.movieData.director == widget.targetData.director
        ? Constants.darkGreen
        : (widget.movieData.director == widget.targetData.writer
            ? Constants.yellow
            : Constants.grey);
    tileColors["director"] = director;

    Color writer = widget.movieData.writer == widget.targetData.writer
        ? Constants.darkGreen
        : (widget.movieData.writer == widget.targetData.director
            ? Constants.yellow
            : Constants.grey);
    tileColors["writer"] = writer;

    Color lead = widget.movieData.lead == widget.targetData.lead
        ? Constants.darkGreen
        : (widget.movieData.isLeadInTarget ? Constants.yellow : Constants.grey);
    tileColors["lead"] = lead;
  }

  _setAllGreen() {
    setState(() {
      tileColors = {
        "userScore": Constants.darkGreen,
        "mpaRating": Constants.darkGreen,
        "releaseDate": Constants.darkGreen,
        "revenue": Constants.darkGreen,
        "runtime": Constants.darkGreen,
        "genre": Constants.darkGreen,
        "director": Constants.darkGreen,
        "writer": Constants.darkGreen,
        "lead": Constants.darkGreen,
      };
    });
  }

  _setAllRed() {
    setState(() {
      tileColors = {
        "userScore": Constants.red,
        "mpaRating": Constants.red,
        "releaseDate": Constants.red,
        "revenue": Constants.red,
        "runtime": Constants.red,
        "genre": Constants.red,
        "director": Constants.red,
        "writer": Constants.red,
        "lead": Constants.red,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    _setTileColors();
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
      padding: Constants.stdPad,
      child: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          border: Border.all(
            color: Constants.black,
            width: 1.0,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: widget.isLoss
              ? Constants.darkRed
              : (widget.movieData.isSameAsTarget
                  ? Constants.lightGreen
                  : Constants.darkGrey),
        ),
        child: Padding(
          padding: Constants.stdPad,
          child: StaggeredGrid.count(
            crossAxisCount: 3,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
            children: <Widget>[
              StaggeredGridTile.count(
                crossAxisCellCount: 3,
                mainAxisCellCount: 1,
                child: TextCard(
                  text: widget.movieData.title,
                  horizontalPadding: subTilePadding,
                  verticalPadding: subTilePadding,
                  color: widget.isLoss
                      ? Constants.red
                      : (widget.movieData.isSameAsTarget
                          ? Constants.darkGreen
                          : Constants.grey),
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
