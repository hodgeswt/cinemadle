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
    this.remainingGuesses = 10,
    this.tileData,
    this.cardFlipControllers,
    this.blur,
    this.allowFlip,
    this.results,
  });

  final MainViewStatus status;
  final List<Movie>? userGuesses;
  final List<int>? userGuessesIds;
  final int remainingGuesses;
  final Map<int, MovieTileData>? tileData;
  final Map<int, FlipCardController>? cardFlipControllers;
  final Map<int, BlurredImage>? blur;
  final List<bool>? allowFlip;
  final String? results;

  static MainViewState get empty {
    return const MainViewState(
      remainingGuesses: 10,
      userGuesses: [],
      userGuessesIds: [],
      status: MainViewStatus.playing,
      tileData: {},
      cardFlipControllers: {},
      blur: {},
      allowFlip: [],
      results: "",
    );
  }

  MainViewState copyWith({
    List<Movie>? userGuesses,
    List<int>? userGuessesIds,
    int? remainingGuesses,
    MainViewStatus? status,
    Map<int, MovieTileData>? tileData,
    Map<int, FlipCardController>? cardFlipControllers,
    Map<int, BlurredImage>? blur,
    List<bool>? allowFlip,
    String? results,
  }) {
    return MainViewState(
      userGuesses: userGuesses ?? this.userGuesses,
      userGuessesIds: userGuessesIds ?? this.userGuessesIds,
      remainingGuesses: remainingGuesses ?? this.remainingGuesses,
      status: status ?? this.status,
      tileData: tileData ?? this.tileData,
      cardFlipControllers: cardFlipControllers ?? this.cardFlipControllers,
      blur: blur ?? this.blur,
      allowFlip: allowFlip ?? this.allowFlip,
      results: results ?? this.results,
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
        tileData,
        cardFlipControllers,
        blur,
        allowFlip,
        results,
      ];
}
