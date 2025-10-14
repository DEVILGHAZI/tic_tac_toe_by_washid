import 'dart:ui';
import 'package:digital_guruji_assignment_tic_tac_toe/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/game_state_model.dart';
import '../../../../core/constants/app_colors.dart';

class ScoreBoard extends StatelessWidget {
  final GameStateModel gameState;

  const ScoreBoard({super.key, required this.gameState});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              isDark
                  ? [
                    AppColors.darkSurface,
                    AppColors.darkBackground.withOpacity(0.8),
                  ]
                  : [
                    AppColors.lightBackground,
                    AppColors.white.withOpacity(0.9),
                  ],
        ),
        borderRadius: BorderRadius.circular(24),
        border:
            isDark
                ? Border.all(color: AppColors.white.withOpacity(0.1), width: 1)
                : null,
        boxShadow: [
          BoxShadow(
            color:
                isDark
                    ? AppColors.black.withOpacity(0.3)
                    : AppColors.lightPrimary.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _enhancedTile(
              context: context,
              label: AppStrings.playerX,
              value: gameState.playerXWins,
              icon: Icons.close_rounded,
              gradient: LinearGradient(
                colors:
                    isDark
                        ? [
                          AppColors.darkPrimary,
                          AppColors.darkPrimary.withOpacity(0.7),
                        ]
                        : [AppColors.playerXColor, AppColors.lightPrimary],
              ),
              accentColor:
                  isDark ? AppColors.darkPrimary : AppColors.playerXColor,
            ),
            _divider(isDark),
            _enhancedTile(
              context: context,
              label: AppStrings.playerO,
              value: gameState.playerOWins,
              icon: Icons.circle_outlined,
              gradient: LinearGradient(
                colors:
                    isDark
                        ? [
                          AppColors.darkSecondary,
                          AppColors.darkSecondary.withOpacity(0.7),
                        ]
                        : [AppColors.playerOColor, AppColors.lightSecondary],
              ),
              accentColor:
                  isDark ? AppColors.darkSecondary : AppColors.playerOColor,
            ),
            _divider(isDark),
            _enhancedTile(
              context: context,
              label: AppStrings.draw,
              value: gameState.draws,
              icon: Icons.handshake_outlined,
              gradient: LinearGradient(
                colors:
                    isDark
                        ? [
                          AppColors.drawColor.withOpacity(0.8),
                          AppColors.drawColor.withOpacity(0.6),
                        ]
                        : [AppColors.drawColor, const Color(0xFFFFAB40)],
              ),
              accentColor: AppColors.drawColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider(bool isDark) {
    return Container(
      width: 1.w,
      height: 80.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors:
              isDark
                  ? [
                    AppColors.white.withOpacity(0),
                    AppColors.white.withOpacity(0.2),
                    Colors.white.withOpacity(0),
                  ]
                  : [
                    Colors.grey.shade300.withOpacity(0),
                    Colors.grey.shade400,
                    Colors.grey.shade300.withOpacity(0),
                  ],
        ),
      ),
    );
  }

  Widget _enhancedTile({
    required BuildContext context,
    required String label,
    required int value,
    required IconData icon,
    required Gradient gradient,
    required Color accentColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 56.w,
          height: 56.h,
          decoration: BoxDecoration(
            gradient: gradient,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: accentColor.withOpacity(0.4),
                blurRadius: 12.r,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, color: AppColors.white, size: 32),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color:
                isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        AnimatedFlipCounter(
          value: value,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutCubic,
          textStyle: GoogleFonts.poppins(
            fontSize: 32.sp,
            fontWeight: FontWeight.bold,
            foreground:
                Paint()
                  ..shader = gradient.createShader(
                    Rect.fromLTWH(0, 0, 200.w, 70.h),
                  ),
          ),
        ),
      ],
    );
  }
}

// Animated Counter Widget
class AnimatedFlipCounter extends StatefulWidget {
  final int value;
  final Duration duration;
  final Curve curve;
  final TextStyle textStyle;

  const AnimatedFlipCounter({
    super.key,
    required this.value,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.linear,
    required this.textStyle,
  });

  @override
  State<AnimatedFlipCounter> createState() => _AnimatedFlipCounterState();
}

class _AnimatedFlipCounterState extends State<AnimatedFlipCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;
  int _previousValue = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = IntTween(
      begin: 0,
      end: widget.value,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedFlipCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _previousValue = oldWidget.value;
      _animation = IntTween(
        begin: _previousValue,
        end: widget.value,
      ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Text('${_animation.value}', style: widget.textStyle);
      },
    );
  }
}
