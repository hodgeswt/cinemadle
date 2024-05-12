import 'package:cinemadle/resource_manager.dart';
import 'package:cinemadle/resources.dart';
import 'package:flutter/material.dart';

class GuessBox extends StatefulWidget {
  const GuessBox({
    super.key,
    required this.inputCallback,
  });

  final Function(String) inputCallback;

  @override
  State<GuessBox> createState() => _GuessBoxState();
}

class _GuessBoxState extends State<GuessBox> {
  final ResourceManager rm = ResourceManager.instance;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        helperText: rm.getResource(Resources.inputBoxHintText),
      ),
    );
  }
}
