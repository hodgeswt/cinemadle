import 'package:cinemadle/constants.dart';
import 'package:cinemadle/resource_manager.dart';
import 'package:cinemadle/resources.dart';
import 'package:flutter/material.dart';

Widget tmdbLogo(double width) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Padding(
        padding: Constants.stdPad,
        child: Text(
          ResourceManager.instance.getResource(Resources.poweredByLabel),
        ),
      ),
      SizedBox(
        width: width,
        child: Image.asset(
          width: width,
          'tmdb_logo.png',
          semanticLabel: 'TheMovieDB.org logo',
        ),
      ),
    ],
  );
}
