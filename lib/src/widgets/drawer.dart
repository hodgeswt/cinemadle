import 'package:cinemadle/src/blocs/target_movie/target_movie_bloc.dart';
import 'package:cinemadle/src/constants.dart';
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

class Destination {
  const Destination(this.label, this.icon, this.selectedIcon);

  final String label;
  final Widget icon;
  final Widget selectedIcon;

  static const List<Destination> all = <Destination>[
    Destination('Instructions', Icon(Icons.description_outlined),
        Icon(Icons.description)),
    Destination('Game', Icon(Icons.movie_outlined), Icon(Icons.movie)),
    Destination('Information', Icon(Icons.info_outlined), Icon(Icons.info)),
  ];
}

Widget drawer(BuildContext context, Views activePage) {
  int ind = activePage.index;
  return BlocProvider(
    create: (context) =>
        TargetMovieBloc()..add(const TargetMovieLoadInitiated()),
    child: BlocBuilder<TargetMovieBloc, TargetMovieState>(
      builder: (context, state) {
        return Container(
          height: MediaQuery.of(context).size.height,
          decoration: Constants.primaryGradientBox(
            hasCornerRadius: true,
            hasBoxShadow: false,
          ),
          child: NavigationDrawer(
            indicatorShape: ShapeBorder.lerp(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                1),
            backgroundColor: Colors.transparent,
            onDestinationSelected: (int selected) {
              _pushReplacement(context, selected, state);
            },
            selectedIndex: ind,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(28, 16, 16, 10),
                child: Text(
                  'Cinemadle',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ...Destination.all.map(
                (Destination destination) {
                  return NavigationDrawerDestination(
                    label: Text(destination.label),
                    icon: destination.icon,
                    selectedIcon: destination.selectedIcon,
                  );
                },
              ),
            ],
          ),
        );
      },
    ),
  );
}

_pushReplacement(BuildContext context, int selected, TargetMovieState state) {
  Widget page;

  switch (Views.values[selected]) {
    case Views.instructions:
      page = InstructionsView();
      break;
    case Views.game:
      page = MainView(
        targetMovie: state.movie!,
        uuid: state.uuid!,
      );
      break;
    case Views.info:
      page = InformationView();
      break;
    default:
      return;
  }
  Navigator.pushReplacement(
    context,
    PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => page,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero),
  );
}
