import 'package:cinemadle/src/bloc_utilities/blurred_image/blurred_image_data.dart';
import 'package:cinemadle/src/widgets/blurred_image.dart';

class BlurredImageCreator {
  static BlurredImageCreator? _instance;

  final Map<BlurredImageData, BlurredImage> _memo = {};

  static BlurredImageCreator get instance {
    _instance ??= BlurredImageCreator._init();
    return _instance!;
  }

  BlurredImageCreator._init();

  BlurredImage create(BlurredImageData data) {
    return _memo.putIfAbsent(data, () => BlurredImage(data: data));
  }
}
