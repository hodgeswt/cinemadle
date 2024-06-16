import 'package:cinemadle/src/bloc_utilities/tile_data/tile_collection/tile_color.dart';
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

  final Text title;
  final List<Widget> content;

  final TileColor? color;

  final String? arrow;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Utilities.colorMap[color],
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Align(alignment: Alignment.topLeft, child: title),
            for (final Widget c in content)
              Flexible(child: FittedBox(fit: BoxFit.fill, child: c)),
          ],
        ),
      ),
    );
  }
}
