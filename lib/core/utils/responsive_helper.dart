import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResponsiveHelper {
  ResponsiveHelper._();

  /// Check if device is tablet
  static bool isTablet(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth >= 600;
  }

  /// Get responsive padding
  static EdgeInsets getScreenPadding(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: 20.w,
      vertical: 16.h,
    );
  }

  /// Get board container size
  static double getBoardSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return (screenWidth - 40).clamp(300.0, 500.0);
  }

  /// Get responsive cell size based on screen width
  static double getCellSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxCellSize = (screenWidth - 80) / 3; // 3 columns with padding
    return maxCellSize.clamp(80.0, 120.0);
  }

  /// Get responsive spacing
  static double getSpacing(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth > 400 ? 12.0 : 8.0;
  }

  /// Get responsive font size for player symbols
  static double getPlayerSymbolSize(BuildContext context) {
    final cellSize = getCellSize(context);
    return cellSize * 0.5;
  }
}