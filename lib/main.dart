import 'package:cinemadle/data_model/movie_record.dart';
import 'package:cinemadle/data_model/paginated_results.dart';
import 'package:cinemadle/movie_data.dart';
import 'package:cinemadle/resource_manager.dart';
import 'package:cinemadle/resources.dart';
import 'package:cinemadle/utils.dart';
import 'package:cinemadle/widgets/guess_box.dart';
import 'package:cinemadle/widgets/movie_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
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
  List<String> userGuessTitles = [];

  _updateState() {
    setState(() {
      title = rm.getResource(Resources.title);
      caption = rm.getResource(Resources.caption);
    });
  }

  _addUserGuess(String guess) async {
    if (!mounted) {
      return;
    }
    PaginatedResults search = await md.searchMovie(guess);

    // Flutter tools don't care that we do the early
    // return on mounted...
    if (search.results.first.title != guess && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${rm.getResource(Resources.guessDoesNotExist)}: $guess"),
      ));
      return;
    }

    if (userGuessTitles.any((x) {
          return x == guess;
        }) &&
        mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text("${rm.getResource(Resources.guessAlreadyExists)}: $guess"),
      ));
      return;
    }

    setState(() {
      userGuesses = [
        MovieCard(movie: search.results.first, target: target),
        ...userGuesses
      ];
      userGuessTitles = [search.results.first.title, ...userGuessTitles];
    });
  }

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
                                  inputCallback: (String movieName) {
                                    _addUserGuess(movieName);
                                  },
                                ),
                              ),
                            ),
                            Text(snapshot.requireData.title),
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
