part of 'main_view_bloc.dart';

sealed class MainViewEvent extends Equatable {
  const MainViewEvent();

  @override
  List<Object?> get props => [];
}

class UserGuessAdded extends MainViewEvent {
  const UserGuessAdded(this.id);

  final int id;

  @override
  List<Object> get props => [id];
}

class ResetRequested extends MainViewEvent {
  const ResetRequested();

  @override
  List<Object> get props => [];
}

class FlipAllRequested extends MainViewEvent {
  const FlipAllRequested();

  @override
  List<Object> get props => [];
}

class GuessNotFoundPopupDismissed extends MainViewEvent {
  const GuessNotFoundPopupDismissed();

  @override
  List<Object> get props => [];
}
