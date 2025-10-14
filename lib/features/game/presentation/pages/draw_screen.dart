import 'package:digital_guruji_assignment_tic_tac_toe/core/constants/app_colors.dart';
import 'package:digital_guruji_assignment_tic_tac_toe/core/constants/app_strings.dart';
import 'package:digital_guruji_assignment_tic_tac_toe/core/widgets/primary_button.dart';
import 'package:digital_guruji_assignment_tic_tac_toe/features/game/presentation/widgets/score_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:digital_guruji_assignment_tic_tac_toe/core/utils/enum.dart';

class DrawScreen extends StatefulWidget {
  final int scores;
  final VoidCallback onPlayAgain;
  final VoidCallback onQuit;

  const DrawScreen({
    super.key,
    required this.scores,
    required this.onPlayAgain,
    required this.onQuit,
  });

  @override
  State<DrawScreen> createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> with TickerProviderStateMixin {
  late AnimationController _shakeController;
  late AnimationController _scaleController;
  late AnimationController _pulseController;
  late Animation<double> _shakeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _shakeAnimation = Tween<double>(begin: -5, end: 5).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _scaleController.forward();
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _scaleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark ? AppColors.darkGradient : AppColors.lightGradient,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 1),
              _buildAnimatedIcon(isDark),
              SizedBox(height: 40.h),
              _buildDrawText(isDark),
              SizedBox(height: 50.h),
              _buildScoreDisplay(context, isDark),
              const Spacer(flex: 2),
              _buildActionButtons(),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedIcon(bool isDark) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: AnimatedBuilder(
        animation: _shakeAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(_shakeAnimation.value, 0),
            child: child,
          );
        },
        child: Container(
          padding: EdgeInsets.all(32.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors:
                  isDark
                      ? [
                        AppColors.drawColor.withOpacity(0.8),
                        AppColors.drawColor.withOpacity(0.6),
                      ]
                      : [AppColors.drawColor, const Color(0xFFFFAB40)],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.drawColor.withOpacity(isDark ? 0.3 : 0.4),
                blurRadius: 30,
                spreadRadius: isDark ? 0 : 5,
              ),
            ],
          ),
          child: Icon(
            Icons.handshake_rounded,
            size: 80.sp,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildDrawText(bool isDark) {
    return ScaleTransition(
      scale: _pulseAnimation,
      child: Column(
        children: [
          Text(
            AppStrings.itsADraw,
            style: GoogleFonts.poppins(
              fontSize: 42.sp,
              fontWeight: FontWeight.w900,
              foreground:
                  Paint()
                    ..shader = LinearGradient(
                      colors:
                          isDark
                              ? [
                                AppColors.drawColor,
                                AppColors.drawColor.withOpacity(0.7),
                              ]
                              : [AppColors.drawColor, const Color(0xFFFFAB40)],
                    ).createShader(const Rect.fromLTWH(0, 0, 300, 70)),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12.h),
          Text(
            AppStrings.wellPlayedBoth,
            style: GoogleFonts.poppins(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color:
                  isDark
                      ? AppColors.drawColor.withOpacity(0.9)
                      : AppColors.drawColor.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreDisplay(BuildContext context, bool isDark) {
    return Container(
      padding: EdgeInsets.all(24.w),
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        color:
            isDark
                ? AppColors.darkSurface.withOpacity(0.5)
                : AppColors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color:
              isDark
                  ? AppColors.drawColor.withOpacity(0.3)
                  : AppColors.drawColor.withOpacity(0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color:
                isDark
                    ? AppColors.black.withOpacity(0.3)
                    : AppColors.drawColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ScoreItem(
            label: AppStrings.draw,
            score: widget.scores,
            color: AppColors.drawColor,
          ),
          Container(
            width: 2,
            height: 60.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.drawColor.withOpacity(0),
                  AppColors.drawColor.withOpacity(0.3),
                  AppColors.drawColor.withOpacity(0),
                ],
              ),
            ),
          ),
          Column(
            children: [
              Text(
                AppStrings.playerX,
                style: GoogleFonts.poppins(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color:
                      isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                AppStrings.playerO,
                style: GoogleFonts.poppins(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color:
                      isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          AppPrimaryGradientButton(
            label: AppStrings.playAgain,
            icon: Icons.play_arrow_rounded,
            type: ButtonType.warning,
            size: ButtonSize.large,
            width: double.infinity,
            onPressed: widget.onPlayAgain,
            height: 55,
            padding: EdgeInsets.all(0),
            borderRadius: BorderRadius.circular(30),
          ),
          SizedBox(height: 12.h),
          AppPrimaryGradientButton(
            label: AppStrings.backToHome,
            icon: Icons.home_rounded,
            type: ButtonType.warning,
            size: ButtonSize.large,
            width: double.infinity,
            height: 55,
            padding: EdgeInsets.all(0),
            shadowColor: AppColors.transparent,
            borderRadius: BorderRadius.circular(30),
            fontSize: 15,
            outlined: true,
            onPressed: widget.onQuit,
          ),
        ],
      ),
    );
  }
}
