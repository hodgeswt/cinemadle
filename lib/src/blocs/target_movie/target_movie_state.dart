part of 'target_movie_bloc.dart';

enum TargetMovieStatus { initial, loading, loaded, failed }

@JsonSerializable()
class TargetMovieState extends Equatable {
  const TargetMovieState({this.movie, this.status = TargetMovieStatus.initial});

  final Movie? movie;

  final TargetMovieStatus status;

  TargetMovieState copyWith({
    Movie? movie,
    TargetMovieStatus? status,
  }) {
    return TargetMovieState(
      movie: movie ?? this.movie,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() => _$TargetMovieStateToJson(this);

  factory TargetMovieState.fromJson(Map<String, dynamic> json) =>
      _$TargetMovieStateFromJson(json);

  @override
  List<Object?> get props => [movie, status];
}
