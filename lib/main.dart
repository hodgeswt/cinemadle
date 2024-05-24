import 'package:bloc/bloc.dart';
import 'package:cinemadle/cinemadle_bloc_observer.dart';
import 'package:cinemadle/src/cinemadle_app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  if (kDebugMode) {
    Bloc.observer = CinemadleBlocObserver();
  }
  runApp(const CinemadleApp());
}
