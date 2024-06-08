import 'dart:math';
import 'package:cinemadle/src/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:universal_io/io.dart';

import 'bloc_utilities/tile_data/tile_color.dart';

class Utilities {
  static Map<TileColor?, BoxDecoration> colorMap = {
    TileColor.yellow: Constants.yellowBox,
    TileColor.green: Constants.greenBox,
    TileColor.grey: Constants.lightBox,
    null: Constants.lightBox,
  };

  static bool isMobile() {
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  static widthCalculator(double width) {
    if (isMobile()) {
      return width;
    }

    double w = width / 2;
    double widthBox = 800;
    if (w > widthBox || w < widthBox) {
      w = widthBox;
    }

    return w;
  }

  static String formatDate(String? date) {
    DateTime? dt = DateTime.tryParse(date ?? "");

    if (dt == null) {
      return date ?? "";
    }

    return DateFormat.yMd(Platform.localeName).format(dt);
  }

  static String formatIntToDollars(int? val) {
    if (val == null) {
      return "";
    }

    return NumberFormat.compactCurrency(
      locale: Platform.localeName,
      name: 'USD',
      symbol: "\$",
      decimalDigits: 2,
    ).format(val);
  }

  static DateTime parseDate(String? date) {
    try {
      return DateFormat('yyyy', Platform.localeName).parse(date ?? "");
    } catch (_) {
      return DateTime(1970, 1, 1);
    }
  }

  static int mapMpaRatingToInt(String? mpaRating) {
    if (mpaRating == null) {
      return 0;
    }

    switch (mpaRating) {
      case "G":
        return 1;
      case "PG":
        return 2;
      case "PG-13":
        return 3;
      case "R":
        return 4;
      case "NC-17":
        return 5;
      case "NR":
        return 6;
      default:
        return 0;
    }
  }

  static int getUuid() {
    DateTime now = DateTime.now();

    int m = (DateTime(now.year, now.month, now.day).millisecondsSinceEpoch /
            86400000)
        .round();

    return (1 + (sin(m) + 1) * 512 / 2).round();
  }
}
