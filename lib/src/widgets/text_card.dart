import 'package:cinemadle/src/constants.dart';
import 'package:flutter/material.dart';

class TextCard extends StatelessWidget {
  const TextCard({
    super.key,
    required this.text,
    this.color,
    this.arrow,
  });

  final String text;

  final Color? color;

  final String? arrow;

  String get titleSplit {
    return "${text.split(':').first}:";
  }

  String get textSplit {
    return text.split(':').last;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: color,
      child: Center(
        child: Padding(
          padding: Constants.stdPad,
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: "",
              children: <TextSpan>[
                TextSpan(
                  text: "$titleSplit\n",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Constants.black,
                  ),
                ),
                arrow != null
                    ? TextSpan(
                        text: "$arrow\n",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Constants.black,
                        ),
                      )
                    : const TextSpan(text: ""),
                TextSpan(
                  text: textSplit,
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
