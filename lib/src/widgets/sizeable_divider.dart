import 'package:cinemadle/src/constants.dart';
import 'package:flutter/material.dart';

class SizeableDivider extends StatelessWidget {
  const SizeableDivider({super.key, this.width, this.color});

  final double? width;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Container(
      width: width ?? w,
      height: 1.0,
      color: color ?? Constants.darkGrey,
    );
  }
}
