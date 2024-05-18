import 'package:cinemadle/constants.dart';
import 'package:cinemadle/movie_card_data.dart';
import 'package:cinemadle/resource_manager.dart';
import 'package:cinemadle/resources.dart';
import 'package:cinemadle/utils.dart';
import 'package:cinemadle/views/main_view.dart';
import 'package:flutter/material.dart';

class GameStart extends StatefulWidget {
  const GameStart({
    super.key,
    required this.targetData,
  });

  final MovieCardData targetData;

  @override
  State<GameStart> createState() => _GameStartState();
}

class _GameStartState extends State<GameStart> {
  final ResourceManager rm = ResourceManager.instance;

  Widget _startGameButton() {
    return Padding(
      padding: Constants.doublePad,
      child: ElevatedButton(
        child: Text(rm.getResource(Resources.startButtonText)),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainView(
                targetData: widget.targetData,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _gameDescription() {
    return Padding(
      padding: Constants.stdPad,
      child: Text(
        rm.getResource(Resources.gameDescription),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = Utils.widthCalculator(MediaQuery.of(context).size.width);
    return Padding(
      padding: Constants.stdPad,
      child: Align(
        alignment: Alignment.center,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              width: width,
              child: ListView(
                children: <Widget>[_gameDescription(), _startGameButton()],
              ),
            );
          },
        ),
      ),
    );
  }
}
