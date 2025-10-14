import 'package:equatable/equatable.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object?> get props => [];
}

class MakeMoveEvent extends GameEvent {
  final int index;

  const MakeMoveEvent(this.index);

  @override
  List<Object?> get props => [index];
}

class RestartGameEvent extends GameEvent {
  const RestartGameEvent();
}

class ResetScoresEvent extends GameEvent {
  const ResetScoresEvent();
}

class LoadScoresEvent extends GameEvent {
  const LoadScoresEvent();
}

class NewGameEvent extends GameEvent {
  const NewGameEvent();
}

class StartVsAIEvent extends GameEvent {
  final String humanSymbol;
  const StartVsAIEvent({this.humanSymbol = 'X'});

  @override
  List<Object?> get props => [humanSymbol];
}

class SwitchToPvPEvent extends GameEvent {
  const SwitchToPvPEvent();
}
