import 'package:flutter/material.dart';

class TextCard extends StatefulWidget {
  const TextCard({
    super.key,
    required this.text,
  });

  final String text;

  @override
  State<TextCard> createState() => _TextCardState();
}

class _TextCardState extends State<TextCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: Theme.of(context).cardColor,
      child: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(widget.text),
        ),
      ),
    );
  }
}
