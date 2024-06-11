import 'package:cinemadle/src/converters/flip_card_controller_json_converter.dart';
import 'package:flutter_flip_card/controllers/flip_card_controllers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FlipCardControllerJsonConverter', () {
    test('fromJson', () {
      const FlipCardControllerJsonConverter converter =
          FlipCardControllerJsonConverter();
      final FlipCardController controller = converter.fromJson('');
      expect(controller, isA<FlipCardController>());

      final FlipCardController controller2 = converter.fromJson('true');
      expect(controller2, isA<FlipCardController>());

      final FlipCardController controller3 = converter.fromJson('false');
      expect(controller3, isA<FlipCardController>());
    });

    test('toJson', () {
      const FlipCardControllerJsonConverter converter =
          FlipCardControllerJsonConverter();
      final FlipCardController controller = FlipCardController();
      expect(converter.toJson(controller), 'true');
    });
  });
}
