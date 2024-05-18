import 'package:cinemadle/constants.dart';
import 'package:flutter/material.dart';

//

class TextCard extends StatefulWidget {
  const TextCard({
    super.key,
    required this.text,
    this.color,
  });

  final String text;

  final Color? color;

  @override
  State<TextCard> createState() => _TextCardState();
}

class _TextCardState extends State<TextCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.color,
      child: Center(
        child: Padding(
          padding: Constants.stdPad,
          child: Text(
            widget.text,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
