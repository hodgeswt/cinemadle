import 'package:cinemadle/src/constants.dart';
import 'package:flutter/material.dart';

class HeaderCard extends StatelessWidget {
  const HeaderCard({
    super.key,
    required this.text,
    required this.isWin,
  });

  final bool isWin;
  final String text;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              decoration: isWin
                  ? Constants.primaryGradientBox()
                  : Constants.darkGradientBox(),
              child: Padding(
                padding: Constants.stdPad,
                child: Center(
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: Constants.bigFont,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
