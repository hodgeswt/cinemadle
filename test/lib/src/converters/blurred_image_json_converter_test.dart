import 'package:cinemadle/src/bloc_utilities/blurred_image/blurred_image_data.dart';
import 'package:cinemadle/src/converters/blurred_image_json_converter.dart';
import 'package:cinemadle/src/widgets/blurred_image.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BlurredImageJsonConverter', () {
    test('fromJson', () {
      const BlurredImageJsonConverter converter = BlurredImageJsonConverter();
      final BlurredImage blurredImage = converter.fromJson('0.5,imagePath');
      expect(blurredImage.data.blur, 0.5);
      expect(blurredImage.data.imageUri, 'imagePath');
    });

    test('toJson', () {
      const BlurredImageJsonConverter converter = BlurredImageJsonConverter();
      final BlurredImageData data =
          BlurredImageData(imageUri: 'imagePath', blur: 0.5);
      final BlurredImage blurredImage = BlurredImage(data: data);
      expect(converter.toJson(blurredImage), '0.5,imagePath');
    });
  });
}
