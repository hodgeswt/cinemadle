import 'package:cinemadle/src/constants.dart';
import 'package:cinemadle/src/widgets/cinemadle_app_bar.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cinemadle',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Constants.lightGrey),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: CinemadleAppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
