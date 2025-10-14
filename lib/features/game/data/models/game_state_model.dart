import 'package:equatable/equatable.dart';
import '../../presentation/bloc/game_state.dart';
import 'player_model.dart';

class GameStateModel extends Equatable {
  final List<String> board; // length 9
  final PlayerModel currentPlayer;
  final GameStatus status;
  final List<int>? winningLine;
  final PlayerModel? winner;
  final int playerXWins;
  final int playerOWins;
  final int draws;
  final bool isVsAI;
  final PlayerModel? aiPlayer;

  const GameStateModel({
    required this.board,
    required this.currentPlayer,
    required this.status,
    this.winningLine,
    this.winner,
    this.playerXWins = 0,
    this.playerOWins = 0,
    this.draws = 0,
    this.isVsAI = false,
    this.aiPlayer,
  });

  factory GameStateModel.initial() => GameStateModel(
        board: List.filled(9, ''),
        currentPlayer: PlayerModel.playerX,
        status: GameStatus.playing,
        winningLine: null,
        winner: null,
        playerXWins: 0,
        playerOWins: 0,
        draws: 0,
        isVsAI: false,
        aiPlayer: null,
      );

  // Expose scores as a map for UI screens that expect it
  Map<String, int> get scores => {
        'playerXWins': playerXWins,
        'playerOWins': playerOWins,
        'draws': draws,
      };

  GameStateModel copyWith({
    List<String>? board,
    PlayerModel? currentPlayer,
    GameStatus? status,
    List<int>? winningLine,
    PlayerModel? winner,
    int? playerXWins,
    int? playerOWins,
    int? draws,
    bool? isVsAI,
    PlayerModel? aiPlayer,
  }) {
    return GameStateModel(
      board: board ?? this.board,
      currentPlayer: currentPlayer ?? this.currentPlayer,
      status: status ?? this.status,
      winningLine: winningLine ?? this.winningLine,
      winner: winner ?? this.winner,
      playerXWins: playerXWins ?? this.playerXWins,
      playerOWins: playerOWins ?? this.playerOWins,
      draws: draws ?? this.draws,
      isVsAI: isVsAI ?? this.isVsAI,
      aiPlayer: aiPlayer ?? this.aiPlayer,
    );
  }

  @override
  List<Object?> get props => [
        board,
        currentPlayer,
        status,
        winningLine,
        winner,
        playerXWins,
        playerOWins,
        draws,
      ];
}
