class GameHistoryModel {
  final String winner; // 'X', 'O', or '' for draw
  final bool isDraw;
  final int totalMoves;
  final DateTime completedAt;

  GameHistoryModel({
    required this.winner,
    required this.isDraw,
    required this.totalMoves,
    required this.completedAt,
  });

  Map<String, dynamic> toMap() => {
    'winner': winner,
    'isDraw': isDraw,
    'totalMoves': totalMoves,
    'completedAt': completedAt.toIso8601String(),
  };

  factory GameHistoryModel.fromMap(Map<String, dynamic> map) {
    return GameHistoryModel(
      winner: map['winner'] as String? ?? '',
      isDraw: map['isDraw'] as bool? ?? false,
      totalMoves: (map['totalMoves'] as num?)?.toInt() ?? 0,
      completedAt: DateTime.tryParse(map['completedAt'] as String? ?? '') ?? DateTime.now(),
    );
  }
}