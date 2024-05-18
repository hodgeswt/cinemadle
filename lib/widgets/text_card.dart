import 'package:cinemadle/constants.dart';
import 'package:cinemadle/utils.dart';
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
  String get title {
    return "${widget.text.split(':').first}:";
  }

  String get text {
    return widget.text.split(':').last;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.color,
      child: Center(
        child: Padding(
          padding: Constants.stdPad,
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: Utils.emptyString,
              children: <TextSpan>[
                TextSpan(
                  text: title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Constants.black,
                  ),
                ),
                TextSpan(
                  text: text,
                  style: const TextStyle(
                    color: Constants.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
