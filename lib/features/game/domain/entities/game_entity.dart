import 'package:equatable/equatable.dart';

class GameEntity extends Equatable {
  final String id;
  final List<String> board;
  final String currentPlayer;
  final String? winner;
  final bool isDraw;
  final DateTime createdAt;
  final DateTime? completedAt;

  const GameEntity({
    required this.id,
    required this.board,
    required this.currentPlayer,
    this.winner,
    this.isDraw = false,
    required this.createdAt,
    this.completedAt,
  });

  @override
  List<Object?> get props => [
        id,
        board,
        currentPlayer,
        winner,
        isDraw,
        createdAt,
        completedAt,
      ];

  GameEntity copyWith({
    String? id,
    List<String>? board,
    String? currentPlayer,
    String? winner,
    bool? isDraw,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return GameEntity(
      id: id ?? this.id,
      board: board ?? this.board,
      currentPlayer: currentPlayer ?? this.currentPlayer,
      winner: winner ?? this.winner,
      isDraw: isDraw ?? this.isDraw,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'board': board,
      'currentPlayer': currentPlayer,
      'winner': winner,
      'isDraw': isDraw,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory GameEntity.fromJson(Map<String, dynamic> json) {
    return GameEntity(
      id: json['id'] as String,
      board: List<String>.from(json['board'] as List),
      currentPlayer: json['currentPlayer'] as String,
      winner: json['winner'] as String?,
      isDraw: json['isDraw'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
    );
  }
}