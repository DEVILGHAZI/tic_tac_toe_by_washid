import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  static const String _prefKey = 'app_theme_mode';

  Future<void> loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getString(_prefKey);
      if (stored == null) {
        emit(ThemeMode.system);
        return;
      }
      switch (stored) {
        case 'light':
          emit(ThemeMode.light);
          break;
        case 'dark':
          emit(ThemeMode.dark);
          break;
        case 'system':
        default:
          emit(ThemeMode.system);
      }
    } catch (_) {
      emit(ThemeMode.system);
    }
  }

  Future<void> setTheme(ThemeMode mode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String value;
      switch (mode) {
        case ThemeMode.light:
          value = 'light';
          break;
        case ThemeMode.dark:
          value = 'dark';
          break;
        case ThemeMode.system:
          value = 'system';
          break;
      }
      await prefs.setString(_prefKey, value);
      emit(mode);
    } catch (_) {
      emit(mode);
    }
  }

  Future<void> toggleTheme() async {
    // Toggle between light and dark explicitly (persisting the choice)
    final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setTheme(next);
  }
}
