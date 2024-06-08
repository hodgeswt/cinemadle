import 'dart:ui';

import 'package:cinemadle/src/bloc_utilities/blurred_image/blurred_image_data.dart';
import 'package:flutter/material.dart';

class BlurredImage extends StatelessWidget {
  const BlurredImage({
    super.key,
    required this.data,
  });

  final BlurredImageData data;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: data.blur, sigmaY: data.blur),
        child: Image.network(data.imageUri),
      ),
    );
  }
}
