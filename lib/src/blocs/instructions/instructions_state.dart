part of 'instructions_bloc.dart';

enum InstructionsStateStatus {
  initial,
  introduction,
  overview,
  detail,
  userScoreDescription,
  mpaRatingDescription,
  releaseDateDescription,
  revenueDescription,
  runtimeDescription,
  genreDescription,
  directorDescription,
  writerDescription,
  firstInCastDescription,
  completed,
}

@JsonSerializable()
class InstructionsState extends Equatable {
  const InstructionsState({
    this.status = InstructionsStateStatus.initial,
    this.index = 0,
    this.title = "Loading...",
    this.content = "Loading...",
    this.canGoBack = false,
    this.canGoForward = true,
  });

  final InstructionsStateStatus status;
  final int index;
  final String title;
  final String content;
  final bool canGoBack;
  final bool canGoForward;

  InstructionsState copyWith({
    InstructionsStateStatus? status,
    int? index,
    String? title,
    String? content,
    bool? canGoBack,
    bool? canGoForward,
  }) {
    return InstructionsState(
      status: status ?? this.status,
      index: index ?? this.index,
      title: title ?? this.title,
      content: content ?? this.content,
      canGoBack: canGoBack ?? this.canGoBack,
      canGoForward: canGoForward ?? this.canGoForward,
    );
  }

  Map<String, dynamic> toJson() => _$InstructionsStateToJson(this);

  factory InstructionsState.fromJson(Map<String, dynamic> json) =>
      _$InstructionsStateFromJson(json);

  @override
  List<Object> get props => [
        status,
        index,
        title,
        content,
        canGoBack,
        canGoForward,
      ];
}
