import 'package:cinemadle/src/blocs/target_movie/target_movie_bloc.dart';
import 'package:cinemadle/src/constants.dart';
import 'package:cinemadle/src/views/failed_loading_view.dart';
import 'package:cinemadle/src/views/main_view.dart';
import 'package:cinemadle/src/widgets/cinemadle_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoadingView extends StatelessWidget {
  LoadingView({super.key});

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
            body: _buildBody(),
          ),
        ),
      ],
    );
  }

  BlocProvider<TargetMovieBloc> _buildBody() {
    return BlocProvider<TargetMovieBloc>(
      create: (context) =>
          TargetMovieBloc()..add(const TargetMovieLoadInitiated()),
      child: BlocConsumer<TargetMovieBloc, TargetMovieState>(
        builder: (context, state) {
          return const Center(child: CircularProgressIndicator());
        },
        listener: (BuildContext context, TargetMovieState state) {
          if (state.status == TargetMovieStatus.loading ||
              state.status == TargetMovieStatus.initial) {
            return;
          }

          if (state.status == TargetMovieStatus.loaded) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MainView(
                  targetMovie: state.movie!,
                  uuid: state.uuid!,
                ),
              ),
            );
            return;
          }

          if (state.status == TargetMovieStatus.failed) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const FailedLoadingView(),
              ),
            );
            return;
          }
        },
      ),
    );
  }
}
