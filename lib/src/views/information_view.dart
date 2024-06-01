import 'package:cinemadle/src/constants.dart';
import 'package:cinemadle/src/utilities.dart';
import 'package:cinemadle/src/widgets/cinemadle_app_bar.dart';
import 'package:cinemadle/src/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InformationView extends StatelessWidget {
  const InformationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CinemadleAppBar(),
      drawer: drawer(context, Views.info),
      body: Center(
        child: SizedBox(
          width:
              Utilities.widthCalculator(MediaQuery.of(context).size.width / 2),
          child: ListView(
            children: [
              const Padding(
                padding: Constants.stdPad,
                child: Center(
                  child: Text(
                    "Release Notes",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              FutureBuilder<String>(
                future: _loadReleaseNotes(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: Constants.stdPad,
                      child: Center(
                        child: Text(
                          snapshot.data!,
                        ),
                      ),
                    );
                  } else {
                    return const Padding(
                      padding: Constants.stdPad,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              ),
              const Center(
                child: Padding(
                  padding: Constants.stdPad,
                  child: Divider(),
                ),
              ),
              const Padding(
                padding: Constants.stdPad,
                child: Center(
                  child: Text(
                    "This product uses the TMDB API but is not endorsed or certified by TMDB.",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const Center(
                child: Padding(
                  padding: Constants.stdPad,
                  child: Divider(),
                ),
              ),
              Center(
                child: Image.asset('tmdb_logo.png'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> _loadReleaseNotes() async {
    return await rootBundle.loadString('release_notes.txt');
  }
}
