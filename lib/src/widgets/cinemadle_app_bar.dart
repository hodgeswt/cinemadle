import 'package:cinemadle/src/constants.dart';
import 'package:flutter/material.dart';

class CinemadleAppBar extends AppBar {
  CinemadleAppBar({super.key})
      : super(
          backgroundColor: Constants.darkGrey,
          title: Text(
            "Cinemadle",
            style: TextStyle(
              color: Constants.lightGrey,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Constants.lightGrey,
          ),
        );
}
