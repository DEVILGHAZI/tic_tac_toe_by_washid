import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_helper.dart';

class GameCell extends StatelessWidget {
  final String value; 
  final int index;
  final bool isWinningCell;
  final VoidCallback onTap;

  const GameCell({
    super.key,
    required this.value,
    required this.index,
    required this.isWinningCell,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = ResponsiveHelper.getCellSize(context);

    Color symbolColor;
    if (value == 'X') {
      symbolColor = AppColors.playerXColor;
    } else if (value == 'O') {
      symbolColor = AppColors.playerOColor;
    } else {
      symbolColor = isDark ? AppColors.white.withOpacity(0.7) : AppColors.black.withOpacity(0.54);
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isDark ? AppColors.cellEmptyDark : AppColors.cellEmpty,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: isWinningCell
              ? [
                  BoxShadow(
                    color: AppColors.winLineColor.withOpacity(0.5),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Center(
          child: AnimatedScale(
            duration: const Duration(milliseconds: 200),
            scale: value.isEmpty ? 0.0 : 1.0,
            child: Text(
              value,
              style: TextStyle(
                fontSize: ResponsiveHelper.getPlayerSymbolSize(context),
                fontWeight: FontWeight.w800,
                color: isWinningCell ? AppColors.winLineColor : symbolColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}