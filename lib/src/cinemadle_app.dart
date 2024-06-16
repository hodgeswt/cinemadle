import 'package:cinemadle/src/constants.dart';
import 'package:cinemadle/src/views/loading_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_repository/tmdb_repository.dart';

class CinemadleApp extends StatelessWidget {
  const CinemadleApp({
    super.key,
    required this.tmdbRepository,
  });

  final TmdbRepository tmdbRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: tmdbRepository,
      child: const CinemadleAppView(),
    );
  }
}

class CinemadleAppView extends StatelessWidget {
  const CinemadleAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cinemadle',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Constants.lightGrey),
        useMaterial3: true,
        fontFamily: 'RobotoMono',
      ),
      home: LoadingView(),
    );
  }
}
