part of 'main_view_bloc.dart';

enum MainViewStatus { playing, win, loss, guessNotFound, fatalError }

@JsonSerializable()
class MainViewState extends Equatable {
  const MainViewState({
    this.status = MainViewStatus.playing,
    this.userGuesses,
    this.userGuessesIds,
    this.remainingGuesses = 10,
    this.tileColors,
  });

  final MainViewStatus status;
  final List<Movie>? userGuesses;
  final List<int>? userGuessesIds;
  final int remainingGuesses;
  final Map<int, MovieTileColors>? tileColors;

  static MainViewState get empty {
    return const MainViewState(
      remainingGuesses: 10,
      userGuesses: [],
      userGuessesIds: [],
      status: MainViewStatus.playing,
      tileColors: {},
    );
  }

  MainViewState copyWith({
    List<Movie>? userGuesses,
    List<int>? userGuessesIds,
    int? remainingGuesses,
    MainViewStatus? status,
    Map<int, MovieTileColors>? tileColors,
  }) {
    return MainViewState(
      userGuesses: userGuesses ?? this.userGuesses,
      userGuessesIds: userGuessesIds ?? this.userGuessesIds,
      remainingGuesses: remainingGuesses ?? this.remainingGuesses,
      status: status ?? this.status,
      tileColors: tileColors ?? this.tileColors,
    );
  }

  Map<String, dynamic> toJson() => _$MainViewStateToJson(this);

  factory MainViewState.fromJson(Map<String, dynamic> json) =>
      _$MainViewStateFromJson(json);

  @override
  List<Object?> get props => [
        status,
        userGuesses,
        remainingGuesses,
        userGuessesIds,
        tileColors,
      ];
}
