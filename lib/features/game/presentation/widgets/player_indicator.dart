import 'package:digital_guruji_assignment_tic_tac_toe/core/constants/app_colors.dart';
import 'package:digital_guruji_assignment_tic_tac_toe/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/player_model.dart';

class PlayerIndicator extends StatelessWidget {
  final PlayerModel currentPlayer;

  const PlayerIndicator({super.key, required this.currentPlayer});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPlayerX = currentPlayer.symbol == 'X';

    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppStrings.turn,
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(width: 16.w),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (child, animation) {
              return ScaleTransition(
                scale: animation,
                child: RotationTransition(turns: animation, child: child),
              );
            },
            child: _buildPlayerSymbol(
              context: context,
              symbol: currentPlayer.symbol,
              isPlayerX: isPlayerX,
              isDark: isDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerSymbol({
    required BuildContext context,
    required String symbol,
    required bool isPlayerX,
    required bool isDark,
  }) {
    final gradient = isPlayerX
        ? LinearGradient(
            colors: isDark
                ? [
                    AppColors.darkPrimary,
                    AppColors.darkPrimary.withOpacity(0.7),
                  ]
                : [AppColors.playerXColor, AppColors.lightPrimary],
          )
        : LinearGradient(
            colors: isDark
                ? [
                    AppColors.darkSecondary,
                    AppColors.darkSecondary.withOpacity(0.7),
                  ]
                : [AppColors.playerOColor, AppColors.lightSecondary],
          );

    final accentColor = isPlayerX
        ? (isDark ? AppColors.darkPrimary : AppColors.playerXColor)
        : (isDark ? AppColors.darkSecondary : AppColors.playerOColor);

    return Container(
      key: ValueKey(symbol), // Important for AnimatedSwitcher
      width: 40.w,
      height: 40.h,
      decoration: BoxDecoration(
        gradient: gradient,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.5),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          isPlayerX ? Icons.close_rounded : Icons.circle_outlined,
          color: AppColors.white,
          size: 30.sp,
        ),
      ),
    );
  }
}
