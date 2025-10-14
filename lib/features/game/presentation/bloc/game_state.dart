import 'package:equatable/equatable.dart';
import '../../data/models/game_state_model.dart';
import '../../data/models/player_model.dart';

enum GameStatus { playing, won, draw }

abstract class GameState extends Equatable {
  const GameState();

  @override
  List<Object?> get props => [];
}

class GameInitial extends GameState {
  const GameInitial();
}

class GameLoading extends GameState {
  const GameLoading();
}

class GameError extends GameState {
  final String message;
  const GameError(this.message);

  @override
  List<Object?> get props => [message];
}

class GameInProgress extends GameState {
  final GameStateModel gameState;
  const GameInProgress(this.gameState);

  @override
  List<Object?> get props => [gameState];
}

class GameWon extends GameState {
  final GameStateModel gameState;
  final PlayerModel winner;
  final List<int> winningLine;
  const GameWon({required this.gameState, required this.winner, required this.winningLine});

  @override
  List<Object?> get props => [gameState, winner, winningLine];
}

class GameDraw extends GameState {
  final GameStateModel gameState;
  const GameDraw(this.gameState);

  @override
  List<Object?> get props => [gameState];
}
