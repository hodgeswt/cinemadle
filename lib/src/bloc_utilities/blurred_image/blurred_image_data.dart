class BlurredImageData {
  final String imageUri;
  final double blur;

  BlurredImageData({
    required this.imageUri,
    required this.blur,
  });

  static BlurredImageData zero(String imageUri) => BlurredImageData(
        imageUri: imageUri,
        blur: 0,
      );
}
