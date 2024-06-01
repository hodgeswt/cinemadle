part of 'instructions_bloc.dart';

sealed class InstructionsEvent extends Equatable {
  const InstructionsEvent();

  @override
  List<Object> get props => [];
}

class InitialLoadRequested extends InstructionsEvent {
  const InitialLoadRequested();

  @override
  List<Object> get props => [];
}

class NextInstructionRequested extends InstructionsEvent {
  const NextInstructionRequested();

  @override
  List<Object> get props => [];
}

class PreviousInstructionRequested extends InstructionsEvent {
  const PreviousInstructionRequested();

  @override
  List<Object> get props => [];
}
