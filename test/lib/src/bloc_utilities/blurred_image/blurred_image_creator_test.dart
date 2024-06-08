import 'package:cinemadle/src/bloc_utilities/blurred_image/blurred_image.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BlurredImageCreator', () {
    group('instance', () {
      test('instance is non-null', () {
        final instance = BlurredImageCreator.instance;
        expect(instance, isNotNull);
      });

      test('instance is singleton', () {
        final instance1 = BlurredImageCreator.instance;
        final instance2 = BlurredImageCreator.instance;
        expect(identical(instance1, instance2), isTrue);
      });
    });

    group('create', () {
      test('create 0.0', () {
        final data = BlurredImageData(
          imageUri: 'imageUrl',
          blur: 0.0,
        );

        final image = BlurredImageCreator.instance.create(data);
        expect(image.data, data);
      });

      test('create 1.1.', () {
        final data = BlurredImageData(
          imageUri: 'imageUrl',
          blur: 1.1,
        );

        final image = BlurredImageCreator.instance.create(data);
        expect(image.data, data);
      });
    });

    test('create memoization', () {
      final data = BlurredImageData(
        imageUri: 'imageUrl',
        blur: 0.0,
      );

      final image1 = BlurredImageCreator.instance.create(data);
      final image2 = BlurredImageCreator.instance.create(data);
      expect(identical(image1, image2), isTrue);
    });

    test('create different data', () {
      final data1 = BlurredImageData(
        imageUri: 'imageUrl1',
        blur: 0.0,
      );

      final data2 = BlurredImageData(
        imageUri: 'imageUrl2',
        blur: 0.0,
      );

      final image1 = BlurredImageCreator.instance.create(data1);
      final image2 = BlurredImageCreator.instance.create(data2);
      expect(identical(image1, image2), isFalse);
    });
  });
}
