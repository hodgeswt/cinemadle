import 'package:cinemadle/src/utilities.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Utilities', () {
    test('mapMpaRatingToInt', () {
      expect(Utilities.mapMpaRatingToInt('G'), 1);
      expect(Utilities.mapMpaRatingToInt('PG'), 2);
      expect(Utilities.mapMpaRatingToInt('PG-13'), 3);
      expect(Utilities.mapMpaRatingToInt('R'), 4);
      expect(Utilities.mapMpaRatingToInt('NC-17'), 5);
      expect(Utilities.mapMpaRatingToInt('NR'), 6);
      expect(Utilities.mapMpaRatingToInt(''), 0);
      expect(Utilities.mapMpaRatingToInt(null), 0);
    });

    test('formatIntToDollars', () {
      expect(Utilities.formatIntToDollars(1000), '\$1K');
      expect(Utilities.formatIntToDollars(1000000), '\$1M');
      expect(Utilities.formatIntToDollars(1000000000), '\$1B');
      expect(Utilities.formatIntToDollars(150000000), '\$150M');
      expect(Utilities.formatIntToDollars(150000), '\$150K');
      expect(Utilities.formatIntToDollars(150), '\$150');
      expect(Utilities.formatIntToDollars(0), '\$0.00');
      expect(Utilities.formatIntToDollars(15234213), '\$15.2M');
      expect(Utilities.formatIntToDollars(152342130), '\$152M');
      expect(Utilities.formatIntToDollars(null), '');
    });

    test('formatDate', () {
      expect(Utilities.formatDate('2021-01-01'), '1/1/2021');
      expect(Utilities.formatDate('2021-02-23'), '2/23/2021');
      expect(Utilities.formatDate('2021-12-31'), '12/31/2021');
      expect(Utilities.formatDate('2021'), '2021');
      expect(Utilities.formatDate(null), '');
      expect(Utilities.formatDate(''), '');
    });

    test('parseDate', () {
      expect(Utilities.parseDate(''), DateTime(1970, 1, 1));
      expect(Utilities.parseDate(null), DateTime(1970, 1, 1));
      expect(Utilities.parseDate('asdf'), DateTime(1970, 1, 1));
      expect(Utilities.parseDate('2021'), DateTime(2021, 1, 1));
    });
  });
}
