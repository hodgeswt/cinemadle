import 'package:flutter/material.dart';

class Constants {
  static const popularityListLength = 512;
  static const pageSize = 20;

  static const int maxGuess = 10;
  static const Duration pollingDelay = Duration(milliseconds: 200);

  static const Color blue = Colors.blue;

  static const Color grey = Colors.grey;
  static const Color darkGrey = Colors.black54;
  static final Color lightGrey = Colors.grey[200] ?? Colors.grey;
  static const Color black = Colors.black;

  static const Color lightGreen = Color(0xFF8BC34A);
  static const Color otherGreen = Color.fromARGB(255, 214, 237, 179);
  static const Color oliveGreen = Color(0xFF689F38);

  static const Color yellow = Colors.yellow;
  static const Color lightYellow = Color(0xFFFFEB3B);
  static const Color darkYellow = Color(0xFFFFD600);
  static const Color goldYellow = Color(0xFFFFD700);

  static const Color lightRed = Color.fromARGB(255, 255, 90, 90);
  static const Color darkRed = Color.fromARGB(255, 221, 99, 99);
  static const Color crimsonRed = Color(0xFFE53935);

  // Padding
  static const double verticalPadding = 8.0;
  static const double horizontalPadding = 8.0;
  static const EdgeInsetsGeometry stdPad = EdgeInsets.symmetric(
      vertical: verticalPadding, horizontal: horizontalPadding);
  static const EdgeInsetsGeometry doublePad = EdgeInsets.symmetric(
      vertical: verticalPadding * 2, horizontal: horizontalPadding * 2);
  static const EdgeInsetsGeometry halfPad = EdgeInsets.symmetric(
      vertical: verticalPadding / 2, horizontal: horizontalPadding / 2);
}
