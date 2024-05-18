import 'package:cinemadle/constants.dart';
import 'package:cinemadle/views/loading_view.dart';
import 'package:flutter/material.dart';

main() {
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
        colorScheme: ColorScheme.fromSeed(seedColor: Constants.lightGrey),
        useMaterial3: true,
      ),
      home: const LoadingView(),
    );
  }
}
