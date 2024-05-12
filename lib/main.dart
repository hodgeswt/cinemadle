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
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 53, 117, 0)),
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

  String title = Utils.emptyString;
  String caption = Utils.emptyString;

  List<MovieCard> userGuesses = [];

  _updateState() {
    setState(() {
      title = rm.getResource(Resources.title);
      caption = rm.getResource(Resources.caption);
    });
  }

  @override
  Widget build(BuildContext context) {
    rm.loadResources().then((loaded) => {
          if (loaded) {_updateState()}
        });
    movieData = md.getTargetMovie();

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
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: GuessBox(
                            inputCallback: (String movieName) {},
                          ),
                        ),
                        Row(
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
