import 'package:cinemadle/data_model/movie_record.dart';
import 'package:cinemadle/data_model/paginated_results.dart';
import 'package:cinemadle/movie_data.dart';
import 'package:cinemadle/resource_manager.dart';
import 'package:cinemadle/resources.dart';
import 'package:cinemadle/utils.dart';
import 'package:cinemadle/widgets/movie_card.dart';
import 'package:cinemadle/widgets/text_card.dart';
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

  late Future<PaginatedResults> movieData;

  String title = Utils.emptyString;
  String caption = Utils.emptyString;

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
    movieData = md.getPopular();

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
      body: Align(
        alignment: Alignment.center,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return FutureBuilder<PaginatedResults>(
              future: movieData,
              builder: (BuildContext context,
                  AsyncSnapshot<PaginatedResults> snapshot) {
                if (snapshot.hasData) {
                  List<MovieRecord> dat = snapshot.requireData.results;
                  return ListView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MovieCard(
                              movie: dat[index],
                            ),
                          ],
                        );
                      });
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
    );
  }
}
