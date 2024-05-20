import 'package:cinemadle/src/blocs/instructions/instructions_bloc.dart';
import 'package:cinemadle/src/constants.dart';
import 'package:cinemadle/src/widgets/instructions_card_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InstructionsCard extends StatelessWidget {
  final String title;
  final String text;

  const InstructionsCard({super.key, required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: Constants.stdPad,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),
            const SizedBox(height: 8),
            Center(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            const Divider(),
            Center(
              child: BlocBuilder<InstructionsBloc, InstructionsState>(
                builder: (context, state) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: InstructionsCardButton(
                          text: "Previous",
                          disabled: !state.canGoBack,
                          goesForward: false,
                        ),
                      ),
                      const Expanded(
                        child: InstructionsCardButton(
                          text: "Next",
                          disabled: false,
                          goesForward: true,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
