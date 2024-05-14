import 'dart:async';

import 'package:cinemadle/movie_card_data.dart';
import 'package:cinemadle/movie_data.dart';
import 'package:cinemadle/resource_manager.dart';
import 'package:cinemadle/resources.dart';
import 'package:cinemadle/widgets/game_start.dart';
import 'package:flutter/material.dart';

class LoadingView extends StatefulWidget {
  const LoadingView({super.key});

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {
  final ResourceManager rm = ResourceManager.instance;
  final MovieData md = MovieData.instance;

  late MovieCardData targetData;

  Future<bool> _loadTargetData() async {
    int targetId = await md.getTargetMovie();
    MovieCardData td = MovieCardData();
    td.loadData(targetId, targetId);
    setState(() {
      targetData = td;
    });

    return true;
  }

  Future<bool> _doLoad() async {
    await rm.loadResources();
    return _loadTargetData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

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
          body: GameStart(targetData: targetData),
        );
      },
      future: _doLoad(),
    );
  }
}
