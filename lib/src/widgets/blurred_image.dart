import 'dart:ui';

import 'package:flutter/material.dart';

class BlurredImage extends StatelessWidget {
  const BlurredImage({
    super.key,
    required this.imageBlur,
    required this.imagePath,
  });

  final double imageBlur;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: imageBlur, sigmaY: imageBlur),
        child: Image.network(imagePath),
      ),
    );
  }
}
