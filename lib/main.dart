import 'package:cinemadle/data_model/movie_details.dart';
import 'package:cinemadle/data_model/movie_record.dart';
import 'package:cinemadle/movie_data.dart';
import 'package:cinemadle/resource_manager.dart';
import 'package:cinemadle/resources.dart';
import 'package:cinemadle/utils.dart';
import 'package:cinemadle/widgets/guess_box.dart';
import 'package:cinemadle/widgets/movie_card.dart';
import 'package:cinemadle/widgets/text_card.dart';
import 'package:flutter/material.dart';

main() {
  runApp(const CinemadleApp());
}

class CinemadleApp extends StatelessWidget {
  const CinemadleApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Cinemadle",
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
          useMaterial3: true,
        ),
        home: const CinemadleHome(
          title: "Cinemadle",
        ));
  }
}

class CinemadleHome extends StatefulWidget {
  const CinemadleHome({super.key, required this.title});

  final String title;

  @override
  State<CinemadleHome> createState() => _CinemadleHomeState();
}

class _CinemadleHomeState extends State<CinemadleHome> {
  final ResourceManager rm = ResourceManager.instance;
  final MovieData md = MovieData.instance;

  late final Future<bool> resourcesLoaded;

  late Future<MovieRecord> movieData;
  MovieRecord? target;

  String title = Utils.emptyString;
  String caption = Utils.emptyString;

  List<MovieCard> userGuesses = [];
  List<int> userGuessRecords = [];

  _updateState() {
    setState(() {
      title = rm.getResource(Resources.title);
      caption = rm.getResource(Resources.caption);
    });
  }

  _addUserGuess(String guess) async {
    if (!mounted || int.tryParse(guess) == null) {
      return;
    }
    MovieDetails search = await md.getDetails(int.parse(guess));

    if (search.id == target?.id) {
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

    setState(() {
      // TODO: adjust the movie card so it just takes in
      // the id, as that's all that it uses anyway...
      // This is hacky but I'm too lazy to rewrite the whole app
      MovieRecord rec = MovieRecord(
        adult: false,
        backdropPath: null,
        genreIds: [],
        id: search.id,
        originalLanguage: "",
        originalTitle: "",
        overview: "",
        popularity: 0.0,
        releaseDate: "",
        title: "",
        video: false,
        voteAverage: 0.0,
        voteCount: 0,
        posterPath: null,
      );

      userGuesses = [MovieCard(movie: rec, target: target), ...userGuesses];
      userGuessRecords = [search.id, ...userGuessRecords];
    });
  }

  bool isWin = false;

  @override
  Widget build(BuildContext context) {
    rm.loadResources().then((loaded) => {
          if (loaded) {_updateState()}
        });
    movieData = md.getTargetMovie().then((t) {
      setState(() {
        target = t;
      });

      return t;
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.zero,
          child: Text(caption),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: Align(
          alignment: Alignment.center,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return FutureBuilder<MovieRecord>(
                future: movieData,
                builder: (BuildContext context,
                    AsyncSnapshot<MovieRecord> snapshot) {
                  if (snapshot.hasData) {
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

                    return ListView(children: <Widget>[
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
                                child:
                                    Text(rm.getResource(Resources.resetButton)),
                              ),
                            ),
                          ]),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          MovieCard(movie: target!, target: target),
                        ],
                      ),
                    ]);
                  } else {
                    return Text(
                      rm.getResource(Resources.loading),
                    );
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
