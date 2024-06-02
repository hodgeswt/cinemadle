import 'package:cinemadle/src/blocs/target_movie/target_movie_bloc.dart';
import 'package:cinemadle/src/views/information_view.dart';
import 'package:cinemadle/src/views/instructions_view.dart';
import 'package:cinemadle/src/views/main_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum Views {
  instructions,
  game,
  info,
}

NavigationDrawer drawer(BuildContext context, Views activePage) {
  return NavigationDrawer(
    children: [
      const DrawerHeader(
        child: Center(
          child: Text(
            'Cinemadle',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
            ),
          ),
        ),
      ),
      BlocProvider(
        create: (context) => TargetMovieBloc(),
        child: BlocBuilder<TargetMovieBloc, TargetMovieState>(
          builder: (context, state) {
            return ListTile(
              title: Text(
                'Instructions',
                style: TextStyle(
                    color: activePage == Views.instructions
                        ? Colors.grey
                        : Colors.black),
              ),
              onTap: activePage == Views.instructions
                  ? null
                  : () {
                      _pushReplacement(
                        context,
                        InstructionsView(targetMovie: state.movie!),
                      );
                    },
            );
          },
        ),
      ),
      BlocProvider(
        create: (context) => TargetMovieBloc(),
        child: BlocBuilder<TargetMovieBloc, TargetMovieState>(
          builder: (context, state) {
            return ListTile(
              title: Text(
                'Game',
                style: TextStyle(
                    color:
                        activePage == Views.game ? Colors.grey : Colors.black),
              ),
              onTap: activePage == Views.game
                  ? null
                  : () {
                      _pushReplacement(
                        context,
                        MainView(
                          targetMovie: state.movie!,
                          uuid: state.uuid!,
                        ),
                      );
                    },
            );
          },
        ),
      ),
      ListTile(
        title: Text(
          'Info',
          style: TextStyle(
              color: activePage == Views.info ? Colors.grey : Colors.black),
        ),
        onTap: activePage == Views.info
            ? null
            : () {
                _pushReplacement(
                  context,
                  const InformationView(),
                );
              },
      )
    ],
  );
}

_pushReplacement(BuildContext context, Widget page) {
  Navigator.pushReplacement(
    context,
    PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => page,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero),
  );
}
