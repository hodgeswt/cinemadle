import 'package:flutter/material.dart';

class TextCard extends StatefulWidget {
  const TextCard({
    super.key,
    required this.text,
    this.horizontalPadding = 4.0,
    this.verticalPadding = 4.0,
    this.width = 125,
    this.height = 125,
    this.widthScale = 1,
    this.heightScale = 1,
  });

  final String text;

  final double horizontalPadding;
  final double verticalPadding;

  final double width;
  final double height;
  final double widthScale;
  final double heightScale;

  @override
  State<TextCard> createState() => _TextCardState();
}

class _TextCardState extends State<TextCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: widget.verticalPadding,
          horizontal: widget.horizontalPadding),
      child: Container(
        height: widget.height * widget.heightScale,
        width: widget.width * widget.widthScale,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 1.0,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: Colors.blue,
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(widget.text),
        ),
      ),
    );
  }
}
