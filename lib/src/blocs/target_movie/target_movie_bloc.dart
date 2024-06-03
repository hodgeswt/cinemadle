import 'package:cinemadle/src/utilities.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tmdb_repository/tmdb_repository.dart';

part 'target_movie_event.dart';
part 'target_movie_state.dart';
part 'target_movie_bloc.g.dart';

class TargetMovieBloc extends HydratedBloc<TargetMovieEvent, TargetMovieState> {
  TargetMovieBloc()
      : super(const TargetMovieState(status: TargetMovieStatus.initial)) {
    on<TargetMovieLoadInitiated>((event, emit) async {
      await _loadingInitiated(event, emit);
    });
  }

  _loadingInitiated(
      TargetMovieLoadInitiated event, Emitter<TargetMovieState> emit) async {
    if (state.status == TargetMovieStatus.loaded &&
        state.uuid == Utilities.getUuid()) {
      emit(state);
    }

    int uuid = Utilities.getUuid();
    int out = uuid;
    int page = (out / 20).round();
    out %= 20;

    emit(
      TargetMovieState.empty
          .copyWith(status: TargetMovieStatus.loading, uuid: uuid),
    );

    try {
      Movie? movie = await TmdbRepository().getMovieFromPage(page, out);

      emit(
        state.copyWith(movie: movie, status: TargetMovieStatus.loaded),
      );
    } catch (err) {
      emit(
        state.copyWith(status: TargetMovieStatus.failed),
      );
    }
  }

  @override
  TargetMovieState? fromJson(Map<String, dynamic> json) {
    return TargetMovieState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(TargetMovieState state) {
    return state.toJson();
  }
}
