import 'package:intl/intl.dart';
import 'package:universal_io/io.dart';

class Utilities {
  static widthCalculator(double width) {
    double w = width;
    double widthBox = (110 * 3) + 24;
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
}
