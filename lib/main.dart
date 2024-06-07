import 'package:cinemadle/cinemadle_bloc_observer.dart';
import 'package:cinemadle/src/cinemadle_app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tmdb_repository/tmdb_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kDebugMode) {
    Bloc.observer = CinemadleBlocObserver();
  }

  HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: kIsWeb
          ? HydratedStorage.webStorageDirectory
          : await getApplicationDocumentsDirectory());

  TmdbRepository tmdbRepository = TmdbRepository();

  runApp(CinemadleApp(
    tmdbRepository: tmdbRepository,
  ));
}
