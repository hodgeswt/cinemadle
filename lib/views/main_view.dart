import 'package:cinemadle/data_model/movie_details.dart';
import 'package:cinemadle/data_model/movie_record.dart';
import 'package:cinemadle/movie_card_data.dart';
import 'package:cinemadle/movie_data.dart';
import 'package:cinemadle/resource_manager.dart';
import 'package:cinemadle/resources.dart';
import 'package:cinemadle/utils.dart';
import 'package:cinemadle/widgets/guess_box.dart';
import 'package:cinemadle/widgets/movie_card.dart';
import 'package:cinemadle/widgets/text_card.dart';
import 'package:flutter/material.dart';

class MainView extends StatefulWidget {
  const MainView({super.key, required this.targetData});

  final MovieCardData targetData;

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final ResourceManager rm = ResourceManager.instance;
  final MovieData md = MovieData.instance;

  List<MovieCard> userGuesses = [];
  List<int> userGuessRecords = [];

  _addUserGuess(String guess) async {
    if (!mounted || int.tryParse(guess) == null) {
      return;
    }

    MovieDetails search = await md.getDetails(int.parse(guess));

    if (search.id == widget.targetData.id) {
      isWin = true;
    }

    if (userGuessRecords.any((x) {
          return x == search.id;
        }) &&
        mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text("${rm.getResource(Resources.guessAlreadyExists)}: $guess"),
      ));
      return;
    }

    MovieCardData cardData = MovieCardData();
    await cardData.loadData(search.id, widget.targetData.id);

    setState(() {
      userGuesses = [
        MovieCard(movieData: cardData, targetData: widget.targetData),
        ...userGuesses
      ];
      userGuessRecords = [search.id, ...userGuessRecords];
    });
  }

  bool isWin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(rm.getResource(Resources.title)),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.zero,
          child: Text(rm.getResource(Resources.caption)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: Align(
          alignment: Alignment.center,
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            if (!isWin) {
              return ListView(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: GuessBox(
                            userGuessRecords: userGuessRecords,
                            inputCallback: (String movieId) {
                              _addUserGuess(movieId);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...userGuesses,
                    ],
                  ),
                ],
              );
            }

            return ListView(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextCard(
                      text: rm.getResource(Resources.winText),
                      width: MediaQuery.of(context).size.width / 2,
                      color: Colors.lightGreen,
                    )
                  ],
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: ElevatedButton(
                          onPressed: () {
                            userGuessRecords = [];
                            userGuesses = [];
                            isWin = false;
                          },
                          child: Text(rm.getResource(Resources.resetButton)),
                        ),
                      ),
                    ]),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    MovieCard(
                      movieData: widget.targetData,
                      targetData: widget.targetData,
                    ),
                  ],
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}