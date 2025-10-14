import 'package:shared_preferences/shared_preferences.dart';

class GameRepository {
  static const String _playerXWinsKey = 'player_x_wins';
  static const String _playerOWinsKey = 'player_o_wins';
  static const String _drawsKey = 'draws';

  Future<Map<String, int>> getScores() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'playerXWins': prefs.getInt(_playerXWinsKey) ?? 0,
      'playerOWins': prefs.getInt(_playerOWinsKey) ?? 0,
      'draws': prefs.getInt(_drawsKey) ?? 0,
    };
  }

  Future<void> incrementPlayerXWins(int current) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_playerXWinsKey, current + 1);
  }

  Future<void> incrementPlayerOWins(int current) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_playerOWinsKey, current + 1);
  }

  Future<void> incrementDraws(int current) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_drawsKey, current + 1);
  }

  Future<void> resetScores() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_playerXWinsKey, 0);
    await prefs.setInt(_playerOWinsKey, 0);
    await prefs.setInt(_drawsKey, 0);
  }
}
