import 'package:cinemadle/src/blocs/instructions/instructions_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InstructionsCardButton extends StatelessWidget {
  const InstructionsCardButton({
    super.key,
    required this.text,
    required this.disabled,
    required this.goesForward,
  });

  final String text;
  final bool disabled;
  final bool goesForward;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: disabled
          ? null
          : () {
              InstructionsEvent action = goesForward
                  ? const NextInstructionRequested()
                  : const PreviousInstructionRequested();

              context.read<InstructionsBloc>().add(action);
            },
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
      ),
      child: Text(text),
    );
  }
}
