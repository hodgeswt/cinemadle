import 'package:flutter/material.dart';

class BottomPaddedText extends StatelessWidget {
  const BottomPaddedText({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8.0,
      ),
      child: Text(
        text,
      ),
    );
  }
}
