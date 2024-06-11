import 'package:flutter/material.dart';

import 'package:cinemadle/src/converters/color_json_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ColorJsonConverter', () {
    test('fromJson', () {
      const ColorJsonConverter converter = ColorJsonConverter();
      final Color? color = converter.fromJson('4294967295');
      expect(color, const Color(0xFFFFFFFF));
    });

    test('toJson', () {
      const ColorJsonConverter converter = ColorJsonConverter();
      const Color color = Color(0xFFFFFFFF);
      expect(converter.toJson(color), '4294967295');
    });
  });
}
