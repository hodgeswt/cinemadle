part of 'target_movie_bloc.dart';

enum TargetMovieStatus { initial, loading, loaded, failed }

@JsonSerializable()
class TargetMovieState extends Equatable {
  const TargetMovieState({
    this.movie,
    this.uuid,
    this.status = TargetMovieStatus.initial,
  });

  final Movie? movie;
  final int? uuid;

  final TargetMovieStatus status;

  TargetMovieState copyWith({
    Movie? movie,
    int? uuid,
    TargetMovieStatus? status,
  }) {
    return TargetMovieState(
      movie: movie ?? this.movie,
      uuid: uuid ?? this.uuid,
      status: status ?? this.status,
    );
  }

  static TargetMovieState get empty {
    return const TargetMovieState(
      movie: null,
      uuid: null,
      status: TargetMovieStatus.initial,
    );
  }

  Map<String, dynamic> toJson() => _$TargetMovieStateToJson(this);

  factory TargetMovieState.fromJson(Map<String, dynamic> json) =>
      _$TargetMovieStateFromJson(json);

  @override
  List<Object?> get props => [
        movie,
        status,
        uuid,
      ];
}
