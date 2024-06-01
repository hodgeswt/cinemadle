import 'package:cinemadle/src/widgets/blurred_image.dart';
import 'package:json_annotation/json_annotation.dart';

class BlurredImageJsonConverter extends JsonConverter<BlurredImage, String> {
  const BlurredImageJsonConverter() : super();

  @override
  BlurredImage fromJson(String json) {
    final List<String> parts = json.split(",");
    final double imageBlur = double.tryParse(parts[0]) ?? 0.0;
    final String imagePath = parts[1];

    return BlurredImage(imageBlur: imageBlur, imagePath: imagePath);
  }

  @override
  String toJson(BlurredImage object) {
    return "${object.imageBlur},${object.imagePath}";
  }
}