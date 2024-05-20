part of 'instructions_bloc.dart';

sealed class InstructionsEvent extends Equatable {
  const InstructionsEvent();

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

class SkipInstructionsRequested extends InstructionsEvent {
  const SkipInstructionsRequested();

  @override
  List<Object> get props => [];
}
