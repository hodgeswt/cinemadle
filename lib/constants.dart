import 'package:flutter/material.dart';

class Constants {
  static const Duration pollingDelay = Duration(milliseconds: 200);

  // Tile colors
  static const Color darkGreen = Colors.green;
  static const Color lightGreen = Colors.lightGreen;
  static const Color grey = Colors.grey;
  static const Color darkGrey = Colors.black54;
  static const Color black = Colors.black;
  static const Color yellow = Colors.yellow;

  // Padding
  static const double verticalPadding = 8.0;
  static const double horizontalPadding = 8.0;
  static const EdgeInsetsGeometry stdPad = EdgeInsets.symmetric(
      vertical: verticalPadding, horizontal: horizontalPadding);
  static const EdgeInsetsGeometry doublePad = EdgeInsets.symmetric(
      vertical: verticalPadding * 2, horizontal: horizontalPadding * 2);
}
