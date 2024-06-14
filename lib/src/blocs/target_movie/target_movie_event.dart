part of 'target_movie_bloc.dart';

sealed class TargetMovieEvent extends Equatable {
  const TargetMovieEvent();

  @override
  List<Object> get props => [];
}

final class TargetMovieLoadInitiated extends TargetMovieEvent {
  const TargetMovieLoadInitiated();
}
