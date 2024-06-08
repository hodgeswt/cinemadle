import 'package:cinemadle/src/bloc_utilities/tile_data/tile_color.dart';
import 'package:cinemadle/src/utilities.dart';
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

  final TileColor? color;

  final String? arrow;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Utilities.colorMap[color],
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: title),
            const SizedBox(height: 2.0),
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
