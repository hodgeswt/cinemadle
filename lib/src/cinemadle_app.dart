import 'package:cinemadle/src/constants.dart';
import 'package:cinemadle/src/views/loading_view.dart';
import 'package:flutter/material.dart';

class CinemadleApp extends StatelessWidget {
  const CinemadleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cinemadle',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Constants.lightGrey),
        useMaterial3: true,
      ),
      home: const LoadingView(),
    );
  }
}
