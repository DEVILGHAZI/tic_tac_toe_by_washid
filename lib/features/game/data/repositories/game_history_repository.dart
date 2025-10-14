import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_history_model.dart';

class GameHistoryRepository {
  static const String _historyKey = 'game_history_list';

  Future<List<GameHistoryModel>> _loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_historyKey);
    if (raw == null || raw.isEmpty) return [];
    final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => GameHistoryModel.fromMap((e as Map).cast<String, dynamic>()))
        .toList().reversed.toList();
  }

  Future<void> _saveAll(List<GameHistoryModel> items) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(items.map((e) => e.toMap()).toList());
    await prefs.setString(_historyKey, encoded);
  }

  Future<void> saveGameResult({required String result, required int totalMoves}) async {
    final items = await _loadAll();
    final isDraw = result == 'draw';
    final winner = isDraw ? '' : result; 
    items.add(GameHistoryModel(
      winner: winner,
      isDraw: isDraw,
      totalMoves: totalMoves,
      completedAt: DateTime.now(),
    ));
    await _saveAll(items);
  }

  Future<Map<String, dynamic>> getStatistics() async {
    final items = await _loadAll();
    final totalGames = items.length;
    final xWins = items.where((e) => !e.isDraw && e.winner == 'X').length;
    final oWins = items.where((e) => !e.isDraw && e.winner == 'O').length;
    final draws = items.where((e) => e.isDraw).length;
    final avgMoves = totalGames == 0
        ? 0.0
        : items.map((e) => e.totalMoves).fold<int>(0, (a, b) => a + b) / totalGames;

    return {
      'history': items,
      'totalGames': totalGames,
      'xWins': xWins,
      'oWins': oWins,
      'draws': draws,
      'avgMovesPerGame': avgMoves.toStringAsFixed(1),
    };
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }
}
