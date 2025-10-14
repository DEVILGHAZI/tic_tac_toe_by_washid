import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Base Colors
  static const Color transparent = Colors.transparent;
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  // Light Theme Colors
  static const Color lightPrimary = Color(0xFF6C63FF);
  static const Color lightSecondary = Color(0xFFFF6584);
  static const Color lightBackground = Color(0xFFF8F9FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightText = Color(0xFF2D3436);
  static const Color lightTextSecondary = Color(0xFF636E72);

  // Dark Theme Colors
  static const Color darkPrimary = Color(0xFF8B83FF);
  static const Color darkSecondary = Color(0xFFFF85A1);
  static const Color darkBackground = Color(0xFF0D0D0D);
  static const Color darkSurface = Color(0xFF1A1A1A);
  static const Color darkText = Color(0xFFE8E8E8);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);

  // Game Colors
  static const Color playerXColor = Color(0xFF6C63FF);
  static const Color playerOColor = Color(0xFFFF6584);
  static const Color winLineColor = Color(0xFFFFD700);
  static const Color drawColor = Color(0xFFFF9500);
  static  Color amberColor = Colors.amber;
  static  Color orangeColor = Colors.orange;

  // Semantic Colors
  static const Color success = Color(0xFF2ECC71); // green
  static const Color error = Color(0xFFE74C3C); // red
  static const Color grey = Color(0xFF9E9E9E);

  // Gradient Colors
  static const List<Color> lightGradient = [
    Color(0xFFE3F2FD),
    Color(0xFFF3E5F5),
  ];

  static const List<Color> darkGradient = [
    Color(0xFF1A1A2E),
    Color(0xFF16213E),
  ];

  // Cell Colors
  static const Color cellEmpty = Color(0xFFE8EAF6);
  static const Color cellEmptyDark = Color(0xFF2A2A3E);
  static const Color cellHover = Color(0xFFD1D5DB);
  static const Color cellHoverDark = Color(0xFF3A3A4E);
}

class AppGradients {
  AppGradients._();

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6C63FF), Color(0xFF8B83FF)],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF6584), Color(0xFFFF85A1)],
  );

  static const LinearGradient winGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
  );
}
