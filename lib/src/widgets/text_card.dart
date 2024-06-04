import 'package:cinemadle/src/constants.dart';
import 'package:flutter/material.dart';

class TextCard extends StatelessWidget {
  const TextCard({
    super.key,
    required this.title,
    required this.content,
    this.color,
    this.arrow,
  });

  final RichText title;
  final RichText content;

  final Color? color;

  final String? arrow;
  BoxDecoration get _gradient {
    if (color == Constants.goldYellow) {
      return Constants.yellowGradientBox;
    } else if (color == Constants.lightGreen) {
      return Constants.primaryGradientBox();
    } else {
      return Constants.lightGradientBox;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _gradient,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Center(child: title),
            content,
            if (arrow != null)
              Text(
                "$arrow",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
