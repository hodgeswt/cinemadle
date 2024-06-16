import 'package:cinemadle/src/constants.dart';
import 'package:cinemadle/src/widgets/cinemadle_app_bar.dart';
import 'package:cinemadle/src/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InformationView extends StatelessWidget {
  InformationView({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: Constants.darkGradientBox(hasBorderRadius: false),
          child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.transparent,
            appBar: CinemadleAppBar(
              scaffoldKey: _scaffoldKey,
            ),
            endDrawer: drawer(context, Views.info),
            body: _buildBody(context),
          ),
        ),
      ],
    );
  }

  Center _buildBody(BuildContext context) {
    return Center(
      child: SizedBox(
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
                    color: Colors.white,
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
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
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
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.white,
                  ),
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
    );
  }

  Future<String> _loadReleaseNotes() async {
    return await rootBundle.loadString('release_notes.txt');
  }
}
