import 'package:cinemadle/src/blocs/instructions/instructions_bloc.dart';
import 'package:cinemadle/src/constants.dart';
import 'package:cinemadle/src/utilities.dart';
import 'package:cinemadle/src/views/main_view.dart';
import 'package:cinemadle/src/widgets/cinemadle_app_bar.dart';
import 'package:cinemadle/src/widgets/instructions_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_repository/tmdb_repository.dart';

class InstructionsView extends StatelessWidget {
  const InstructionsView({
    super.key,
    required this.targetMovie,
  });

  final Movie targetMovie;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CinemadleAppBar(),
      body: BlocProvider<InstructionsBloc>(
        create: (context) =>
            InstructionsBloc()..add(const NextInstructionRequested()),
        child: BlocListener<InstructionsBloc, InstructionsState>(
          listener: (context, state) {
            if (state.status == InstructionsStateStatus.completed) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MainView(targetMovie: targetMovie),
                ),
              );
            }
          },
          child: Center(
            child: SizedBox(
              width: Utilities.widthCalculator(
                  MediaQuery.of(context).size.width / 2),
              child: ListView(
                children: [
                  const IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Card(
                            elevation: 4.0,
                            child: Padding(
                              padding: Constants.stdPad,
                              child: Center(
                                child: Text(
                                  'How to Play',
                                  style: TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: Constants.stdPad,
                    child: Divider(),
                  ),
                  Padding(
                    padding: Constants.stdPad,
                    child: BlocBuilder<InstructionsBloc, InstructionsState>(
                      builder: (context, state) {
                        return InstructionsCard(
                          title: state.title,
                          text: state.content,
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: Constants.stdPad,
                    child: BlocBuilder<InstructionsBloc, InstructionsState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: () {
                            context
                                .read<InstructionsBloc>()
                                .add(const SkipInstructionsRequested());
                          },
                          child: const Text("Skip All"),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
