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

  static String formatDate(String? date) {
    DateTime? dt = DateTime.tryParse(date ?? emptyString);

    if (dt == null) {
      return date ?? emptyString;
    }

    return DateFormat.yMd(ResourceManager.instance.culture).format(dt);
  }
}
