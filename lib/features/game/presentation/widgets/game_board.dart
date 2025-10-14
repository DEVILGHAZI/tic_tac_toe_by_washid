import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../../core/utils/sound_effects.dart';
import '../../data/models/game_state_model.dart';
import '../bloc/game_bloc.dart';
import '../bloc/game_event.dart';
import '../bloc/game_state.dart';
import 'game_cell.dart';

class GameBoard extends StatelessWidget {
  final GameStateModel gameState;
  final List<int>? winningLine;

  const GameBoard({
    super.key,
    required this.gameState,
    this.winningLine,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = ResponsiveHelper.getSpacing(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.darkPrimary.withOpacity(0.5),
                  AppColors.darkSecondary.withOpacity(0.5),
                ]
              : [
                  AppColors.lightPrimary.withOpacity(0.6),
                  AppColors.lightSecondary.withOpacity(0.6),
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? AppColors.black.withOpacity(0.4)
                : AppColors.lightPrimary.withOpacity(0.2),
            blurRadius: 25,
            spreadRadius: 2,
            offset: const Offset(0, 12),
          ),
          // Glow effect
          BoxShadow(
            color: isDark
                ? AppColors.darkPrimary.withOpacity(0.2)
                : AppColors.lightPrimary.withOpacity(0.15),
            blurRadius: 40,
            spreadRadius: -5,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.all(spacing),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(29.r),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? AppColors.black.withOpacity(0.3)
                  : AppColors.white.withOpacity(0.9),
              blurRadius: 15,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: _buildGrid(context, spacing, isDark),
      ),
    );
  }

  Widget _buildGrid(BuildContext context, double spacing, bool isDark) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: spacing * 0.8,
        mainAxisSpacing: spacing * 0.8,
        childAspectRatio: 1,
      ),
      itemCount: 9,
      itemBuilder: (context, index) {
        final isWinningCell = winningLine?.contains(index) ?? false;

        return GameCell(
          value: gameState.board[index],
          index: index,
          isWinningCell: isWinningCell,
          onTap: () async {
            final isAITurn = gameState.isVsAI &&
                gameState.aiPlayer != null &&
                gameState.currentPlayer.symbol == gameState.aiPlayer!.symbol;
            if (gameState.status == GameStatus.playing &&
                gameState.board[index].isEmpty &&
                !isAITurn) {
              if (gameState.currentPlayer.symbol == 'X') {
                await SoundEffects.playMovex();
              } else {
                await SoundEffects.playMoveo();
              }
              context.read<GameBloc>().add(MakeMoveEvent(index));
            }
          },
        );
      },
    );
  }
}
