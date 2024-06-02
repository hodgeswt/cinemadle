import 'package:cinemadle/src/blocs/target_movie/target_movie_bloc.dart';
import 'package:cinemadle/src/views/failed_loading_view.dart';
import 'package:cinemadle/src/views/main_view.dart';
import 'package:cinemadle/src/widgets/cinemadle_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CinemadleAppBar(),
      body: BlocProvider<TargetMovieBloc>(
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
      ),
    );
  }
}
