import 'package:cinemadle/src/bloc_utilities/blurred_image/blurred_image.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BlurredImageData', () {
    test('create 0.0', () {
      final data = BlurredImageData(
        imageUri: 'imageUrl',
        blur: 0.0,
      );

      expect(data.imageUri, 'imageUrl');
      expect(data.blur, 0.0);
    });

    test('create 1.1.', () {
      final data = BlurredImageData(
        imageUri: 'imageUrl',
        blur: 1.1,
      );

      expect(data.imageUri, 'imageUrl');
      expect(data.blur, 1.1);
    });

    test('zero', () {
      final data = BlurredImageData.zero('imageUrl');

      expect(data.imageUri, 'imageUrl');
      expect(data.blur, 0.0);
    });
  });
}
