import 'package:equatable/equatable.dart';

enum PlayerType { x, o }

class PlayerModel extends Equatable {
  final String symbol;
  final PlayerType type;
  final int wins;

  const PlayerModel({
    required this.symbol,
    required this.type,
    this.wins = 0,
  });

  PlayerModel copyWith({
    String? symbol,
    PlayerType? type,
    int? wins,
  }) {
    return PlayerModel(
      symbol: symbol ?? this.symbol,
      type: type ?? this.type,
      wins: wins ?? this.wins,
    );
  }

  @override
  List<Object?> get props => [symbol, type, wins];

  static const PlayerModel playerX = PlayerModel(
    symbol: 'X',
    type: PlayerType.x,
  );

  static const PlayerModel playerO = PlayerModel(
    symbol: 'O',
    type: PlayerType.o,
  );
}