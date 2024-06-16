part of 'main_view_bloc.dart';

enum MainViewStatus {
  playing,
  win,
  loss,
  guessNotFound,
  fatalError,
  guessLoading
}

@JsonSerializable()
@FlipCardControllerJsonConverter()
@BlurredImageJsonConverter()
class MainViewState extends Equatable {
  const MainViewState({
    this.status = MainViewStatus.playing,
    this.userGuesses,
    this.userGuessesIds,
    this.remainingGuesses = MainViewState.userGuessLimit,
    this.cardFlipControllers,
    this.blur,
    this.results,
    this.uuid,
  });

  static const int userGuessLimit = 10;

  final MainViewStatus status;
  final List<TileCollection>? userGuesses;
  final List<int>? userGuessesIds;
  final int remainingGuesses;
  final Map<int, FlipCardController>? cardFlipControllers;
  final Map<int, BlurredImage>? blur;
  final String? results;
  final int? uuid;

  static MainViewState get empty {
    return const MainViewState(
      remainingGuesses: MainViewState.userGuessLimit,
      userGuesses: [],
      userGuessesIds: [],
      status: MainViewStatus.playing,
      cardFlipControllers: {},
      blur: {},
      results: "",
      uuid: null,
    );
  }

  MainViewState copyWith({
    List<TileCollection>? userGuesses,
    List<int>? userGuessesIds,
    int? remainingGuesses,
    MainViewStatus? status,
    Map<int, FlipCardController>? cardFlipControllers,
    Map<int, BlurredImage>? blur,
    String? results,
    int? uuid,
  }) {
    return MainViewState(
      userGuesses: userGuesses ?? this.userGuesses,
      userGuessesIds: userGuessesIds ?? this.userGuessesIds,
      remainingGuesses: remainingGuesses ?? this.remainingGuesses,
      status: status ?? this.status,
      cardFlipControllers: cardFlipControllers ?? this.cardFlipControllers,
      blur: blur ?? this.blur,
      results: results ?? this.results,
      uuid: uuid ?? this.uuid,
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
        cardFlipControllers,
        blur,
        results,
        uuid,
      ];
}
