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
    return text.split(':').first;
  }

  String get textSplit {
    return text.split(':').last;
  }

  BoxDecoration get _gradient {
    if (color == Constants.goldYellow) {
      return Constants.yellowGradientBox;
    } else if (color == Constants.lightGreen) {
      return Constants.primaryGradientBox;
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
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  text: titleSplit,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: "\n$textSplit${arrow == null ? "" : " $arrow"}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              // Text(
              //   "$titleSplit ${arrow ?? ""}",
              //   style: const TextStyle(
              //     fontWeight: FontWeight.w500,
              //     color: Colors.white,
              //     fontSize: 20.0,
              //   ),
              //   textAlign: TextAlign.left,
              // ),
            ),
            // Expanded(
            //   child: Text(
            //     textSplit,
            //     style: const TextStyle(
            //       color: Colors.white,
            //     ),
            //     textAlign: TextAlign.left,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
