import 'package:cinemadle/src/blocs/main_view/main_view_bloc.dart';
import 'package:flutter/material.dart';

class Constants {
  static const popularityListLength = 512;
  static const pageSize = 20;

  static const Color primary = Color(0xFF00B288);
  static const Color primaryLight = Color(0xFFA9FFEA);

  static const Color secondary = Color(0xFFFF9E2D);
  static const Color secondaryLight = Color(0xFFFFD29D);

  static const double bigFont = 40;
  static const double mediumFont = 25;
  static const double smallFont = 20;
  static const double tinyFont = 16;

  static BoxDecoration primaryGradientBox({
    bool hasCornerRadius = true,
    bool hasBoxShadow = true,
  }) {
    return BoxDecoration(
      color: primary,
      boxShadow: hasBoxShadow
          ? const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.5),
                offset: Offset(0, 4),
                blurRadius: 4,
              ),
            ]
          : null,
      borderRadius: hasCornerRadius ? BorderRadius.circular(15) : null,
    );
  }

  static final BoxDecoration yellowBox = BoxDecoration(
    color: const Color(0xFFC97616),
    boxShadow: const [
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.5),
        offset: Offset(0, 4),
        blurRadius: 4,
      ),
    ],
    borderRadius: BorderRadius.circular(15),
  );

  static final BoxDecoration greenBox = BoxDecoration(
    color: const Color(0xFF007949),
    boxShadow: const [
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.5),
        offset: Offset(0, 4),
        blurRadius: 4,
      ),
    ],
    borderRadius: BorderRadius.circular(15),
  );

  static BoxDecoration darkGradientBox({bool hasBorderRadius = true}) {
    return BoxDecoration(
      borderRadius: hasBorderRadius ? BorderRadius.circular(15) : null,
      boxShadow: const [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.5),
          offset: Offset(0, 4),
          blurRadius: 4,
        ),
      ],
      gradient: const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Color(0xFF6E6E6E), darkGrey],
      ),
    );
  }

  static final BoxDecoration lightBox = BoxDecoration(
    borderRadius: BorderRadius.circular(15),
    color: const Color(0xFF737373),
    boxShadow: const [
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.5),
        offset: Offset(0, 4),
        blurRadius: 4,
      ),
    ],
  );

  static BoxBorder? _getBorder(bool hasBorder, MainViewStatus? isWin) {
    if (hasBorder && isWin != null) {
      return Border.all(
        color: isWin == MainViewStatus.win ? primary : crimsonRed,
        width: 2,
      );
    }
    return null;
  }

  static BoxDecoration mediumGradientBox({
    bool hasBorderRadius = true,
    bool hasBorder = false,
    MainViewStatus? isWin,
  }) {
    return BoxDecoration(
      borderRadius: hasBorderRadius ? BorderRadius.circular(15) : null,
      border: hasBorder ? _getBorder(hasBorder, isWin) : null,
      boxShadow: const [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.5),
          offset: Offset(0, 4),
          blurRadius: 4,
        ),
      ],
      gradient: const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Color(0xFF6E6E6E), darkGrey],
      ),
    );
  }

  static const Color grey = Colors.grey;
  static const Color darkGrey = Color(0xFF585858);
  static final Color lightGrey = Colors.grey[200] ?? Colors.grey;
  static const Color black = Colors.black;

  static const Color lightGreen = Color(0xFF8BC34A);

  static const Color goldYellow = Color(0xFFFFD700);

  static const Color lightRed = Color.fromARGB(255, 255, 90, 90);
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
