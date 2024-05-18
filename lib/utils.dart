import 'package:cinemadle/resource_manager.dart';
import 'package:intl/intl.dart';
import 'package:language_code/language_code.dart';

class Utils {
  static String get emptyString {
    return "";
  }

  static String langCodeToLang(String? langCode) {
    if (langCode == null) {
      return emptyString;
    }
    return LanguageCodes.fromCode(langCode).englishName;
  }

  static String formatIntToDollars(int? val) {
    if (val == null) {
      return emptyString;
    }

    return NumberFormat.compactCurrency(
      locale: ResourceManager.instance.culture,
      name: "USD",
      symbol: "\$",
      decimalDigits: 2,
    ).format(val);
  }

  static double widthCalculator(double width) {
    double w = width;
    double widthBox = (110 * 3) + 24;
    if (w > widthBox || w < widthBox) {
      w = widthBox;
    }

    return w;
  }

  static String formatDate(String? date) {
    DateTime? dt = DateTime.tryParse(date ?? emptyString);

    if (dt == null) {
      return date ?? emptyString;
    }

    return DateFormat.yMd(ResourceManager.instance.culture).format(dt);
  }

  static DateTime parseDate(String? date) {
    try {
      return DateFormat.yMd(ResourceManager.instance.culture)
          .parse(date ?? emptyString);
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
