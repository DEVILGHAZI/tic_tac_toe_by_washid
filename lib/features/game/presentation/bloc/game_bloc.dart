import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/game_logic.dart';
import '../../../../core/utils/sound_effects.dart';
import '../../data/models/game_state_model.dart';
import '../../data/models/player_model.dart';
import '../../data/repositories/game_repository.dart';
import '../../data/repositories/game_history_repository.dart';
import 'game_event.dart';
import 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final GameRepository gameRepository;
  final GameHistoryRepository historyRepository = GameHistoryRepository();
  GameStateModel _currentGameState = GameStateModel.initial();
  int _moveCount = 0;

  GameBloc({required this.gameRepository}) : super(const GameInitial()) {
    on<LoadScoresEvent>(_onLoadScores);
    on<MakeMoveEvent>(_onMakeMove);
    on<RestartGameEvent>(_onRestartGame);
    on<ResetScoresEvent>(_onResetScores);
    on<NewGameEvent>(_onNewGame);
    on<StartVsAIEvent>(_onStartVsAI);
    on<SwitchToPvPEvent>(_onSwitchToPvP);
  }

  Future<void> _onLoadScores(
    LoadScoresEvent event,
    Emitter<GameState> emit,
  ) async {
    try {
      emit(const GameLoading());
      final scores = await gameRepository.getScores();
      
      _currentGameState = GameStateModel.initial().copyWith(
        playerXWins: scores['playerXWins'] ?? 0,
        playerOWins: scores['playerOWins'] ?? 0,
        draws: scores['draws'] ?? 0,
      );
      _moveCount = 0;
      
      emit(GameInProgress(_currentGameState));
    } catch (e) {
      emit(GameError(e.toString()));
    }
  }

  Future<void> _onMakeMove(
    MakeMoveEvent event,
    Emitter<GameState> emit,
  ) async {
    if (state is! GameInProgress) return;
    
    final currentState = (state as GameInProgress).gameState;
    
    // Check if cell is already occupied
    if (currentState.board[event.index].isNotEmpty) return;
    
    // Check if game is already over
    if (currentState.status != GameStatus.playing) return;

    // Make the move
    final newBoard = List<String>.from(currentState.board);
    newBoard[event.index] = currentState.currentPlayer.symbol;
    _moveCount += 1;

    // Check for winner
    final winningLine = GameLogic.checkWinner(newBoard);
    
    if (winningLine != null) {
      // Game won
      final winner = currentState.currentPlayer;
      int newPlayerXWins = currentState.playerXWins;
      int newPlayerOWins = currentState.playerOWins;
      
      if (winner.type == PlayerType.x) {
        newPlayerXWins++;
        await gameRepository.incrementPlayerXWins(currentState.playerXWins);
      } else {
        newPlayerOWins++;
        await gameRepository.incrementPlayerOWins(currentState.playerOWins);
      }
      
      _currentGameState = currentState.copyWith(
        board: newBoard,
        status: GameStatus.won,
        winningLine: winningLine,
        winner: winner,
        playerXWins: newPlayerXWins,
        playerOWins: newPlayerOWins,
      );
      
      // persist history
      await historyRepository.saveGameResult(
        result: winner.symbol,
        totalMoves: _moveCount,
      );
      
      emit(GameWon(
        gameState: _currentGameState,
        winner: winner,
        winningLine: winningLine,
      ));
    } else if (GameLogic.isBoardFull(newBoard)) {
      // Game draw
      final newDraws = currentState.draws + 1;
      await gameRepository.incrementDraws(currentState.draws);
      
      _currentGameState = currentState.copyWith(
        board: newBoard,
        status: GameStatus.draw,
        draws: newDraws,
      );
      
      // persist history
      await historyRepository.saveGameResult(
        result: 'draw',
        totalMoves: _moveCount,
      );
      
      emit(GameDraw(_currentGameState));
    } else {
      // Continue game with next player
      final nextPlayer = currentState.currentPlayer.type == PlayerType.x
          ? PlayerModel.playerO
          : PlayerModel.playerX;
      
      _currentGameState = currentState.copyWith(
        board: newBoard,
        currentPlayer: nextPlayer,
      );
      
      emit(GameInProgress(_currentGameState));

      // If vs AI and it's now AI's turn, make AI move automatically
      if (_currentGameState.isVsAI &&
          _currentGameState.aiPlayer != null &&
          _currentGameState.currentPlayer.symbol == _currentGameState.aiPlayer!.symbol &&
          _currentGameState.status == GameStatus.playing) {
        await Future.delayed(const Duration(milliseconds: 400));
        final aiIndex = GameLogic.getAIMove(
          List<String>.from(_currentGameState.board),
          _currentGameState.aiPlayer!.symbol,
        );
        if (aiIndex >= 0) {
          // Play respective move sound before AI moves
          if (_currentGameState.aiPlayer!.symbol == 'X') {
            await SoundEffects.playMovex();
          } else {
            await SoundEffects.playMoveo();
          }
          add(MakeMoveEvent(aiIndex));
        }
      }
    }
  }

  Future<void> _onRestartGame(
    RestartGameEvent event,
    Emitter<GameState> emit,
  ) async {
    _currentGameState = GameStateModel.initial().copyWith(
      playerXWins: _currentGameState.playerXWins,
      playerOWins: _currentGameState.playerOWins,
      draws: _currentGameState.draws,
      isVsAI: _currentGameState.isVsAI,
      aiPlayer: _currentGameState.aiPlayer,
    );
    _moveCount = 0;
    
    emit(GameInProgress(_currentGameState));

    // If restarting vs AI and AI is 'X', let AI start
    if (_currentGameState.isVsAI &&
        _currentGameState.aiPlayer?.symbol == 'X' &&
        _currentGameState.status == GameStatus.playing) {
      await Future.delayed(const Duration(milliseconds: 800));
      final aiIndex = GameLogic.getAIMove(
        List<String>.from(_currentGameState.board),
        'X',
      );
      if (aiIndex >= 0) {
        // AI is 'X' here
        await SoundEffects.playMovex();
        add(MakeMoveEvent(aiIndex));
      }
    }
  }

  Future<void> _onResetScores(
    ResetScoresEvent event,
    Emitter<GameState> emit,
  ) async {
    try {
      await gameRepository.resetScores();
      
      _currentGameState = GameStateModel.initial();
      _moveCount = 0;
      
      emit(GameInProgress(_currentGameState));
    } catch (e) {
      emit(GameError(e.toString()));
    }
  }

  Future<void> _onNewGame(
    NewGameEvent event,
    Emitter<GameState> emit,
  ) async {
    add(const RestartGameEvent());
  }

  Future<void> _onStartVsAI(
    StartVsAIEvent event,
    Emitter<GameState> emit,
  ) async {
    try {
      emit(const GameLoading());
      final scores = await gameRepository.getScores();

      final humanIsX = event.humanSymbol.toUpperCase() == 'X';
      final aiPlayer = humanIsX ? PlayerModel.playerO : PlayerModel.playerX;

      // Always start fresh when switching to AI mode
      _currentGameState = GameStateModel.initial().copyWith(
        playerXWins: scores['playerXWins'] ?? 0,
        playerOWins: scores['playerOWins'] ?? 0,
        draws: scores['draws'] ?? 0,
        isVsAI: true,
        aiPlayer: aiPlayer,
        currentPlayer: PlayerModel.playerX,
      );
      _moveCount = 0;

      emit(GameInProgress(_currentGameState));

      // If AI is 'X', make the first move
      if (_currentGameState.aiPlayer?.symbol == 'X' &&
          _currentGameState.status == GameStatus.playing) {
        await Future.delayed(const Duration(milliseconds: 800));
        final aiIndex = GameLogic.getAIMove(
          List<String>.from(_currentGameState.board),
          'X',
        );
        if (aiIndex >= 0) {
          // AI is 'X' here
          await SoundEffects.playMovex();
          add(MakeMoveEvent(aiIndex));
        }
      }
    } catch (e) {
      emit(GameError(e.toString()));
    }
  }

  Future<void> _onSwitchToPvP(
    SwitchToPvPEvent event,
    Emitter<GameState> emit,
  ) async {
    try {
      emit(const GameLoading());
      final scores = await gameRepository.getScores();

      // Switch to PvP mode and restart game
      _currentGameState = GameStateModel.initial().copyWith(
        playerXWins: scores['playerXWins'] ?? 0,
        playerOWins: scores['playerOWins'] ?? 0,
        draws: scores['draws'] ?? 0,
        isVsAI: false,
        aiPlayer: null,
        currentPlayer: PlayerModel.playerX,
      );
      _moveCount = 0;

      emit(GameInProgress(_currentGameState));
    } catch (e) {
      emit(GameError(e.toString()));
    }
  }
}