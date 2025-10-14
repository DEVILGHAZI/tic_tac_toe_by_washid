import 'package:digital_guruji_assignment_tic_tac_toe/core/constants/app_colors.dart';
import 'package:digital_guruji_assignment_tic_tac_toe/core/constants/app_strings.dart';
import 'package:digital_guruji_assignment_tic_tac_toe/core/widgets/primary_button.dart';
import 'package:digital_guruji_assignment_tic_tac_toe/features/game/presentation/widgets/score_item.dart';
import 'package:digital_guruji_assignment_tic_tac_toe/core/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WinScreen extends StatefulWidget {
  final String winner;
  final int scoresx;
  final int scoreso;
  final VoidCallback onPlayAgain;
  final VoidCallback onQuit;
  final bool isVsAI;
  final String? aiPlayer;

  const WinScreen({
    super.key,
    required this.winner,
    required this.scoresx,
    required this.scoreso,
    required this.onPlayAgain,
    required this.onQuit,
    this.isVsAI = false,
    this.aiPlayer,
  });

  @override
  State<WinScreen> createState() => _WinScreenState();
}

class _WinScreenState extends State<WinScreen> with TickerProviderStateMixin {
  late AnimationController _confettiController;
  late AnimationController _scaleController;
  late AnimationController _floatController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _confettiController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _floatController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _floatAnimation = Tween<double>(begin: 0, end: 20).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _scaleController.forward();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _scaleController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  String _getWinMessage() {
    if (widget.isVsAI && widget.aiPlayer == widget.winner) {
      return AppStrings.aiWon;
    } else if (widget.isVsAI && widget.aiPlayer != widget.winner) {
      return AppStrings.youWon;
    } else {
      return AppStrings.youWon; // PvP mode - both players are human
    }
  }

  String _getPlayerText() {
    if (widget.isVsAI && widget.aiPlayer == widget.winner) {
      return 'AI (${widget.winner})';
    } else if (widget.isVsAI && widget.aiPlayer != widget.winner) {
      return 'You (${widget.winner})';
    } else {
      return 'Player ${widget.winner}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.1),
              Theme.of(context).primaryColor.withOpacity(0.05),
            ],
          ),
        ),
        child: Stack(
          children: [
            _buildConfetti(),
            SafeArea(
              child: Column(
                children: [
                  const Spacer(flex: 1),
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      padding: EdgeInsets.all(32.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Colors.amber.shade300,
                            Colors.orange.shade400,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.amberColor.withOpacity(0.4),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.emoji_events_rounded,
                        size: 80.sp,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),
                  AnimatedBuilder(
                    animation: _floatAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, -_floatAnimation.value),
                        child: child,
                      );
                    },
                    child: Column(
                      children: [
                        Text(
                          _getWinMessage(),
                          style: Theme.of(
                            context,
                          ).textTheme.displayMedium?.copyWith(
                            fontSize: 42.sp,
                            fontWeight: FontWeight.w900,
                            color: Colors.amber.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          _getPlayerText(),
                          style: Theme.of(
                            context,
                          ).textTheme.headlineSmall?.copyWith(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 50.h),
                  _buildScoreDisplay(context),
                  const Spacer(flex: 2),
                  _buildActionButtons(context),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreDisplay(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor.withOpacity(0.15),
            Theme.of(context).primaryColor.withOpacity(0.05),
          ],
        ),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.2),
          width: 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ScoreItem(
            label: AppStrings.playerX,
            score: widget.scoresx,
            color:
                widget.winner == 'O'
                    ? AppColors.playerOColor
                    : Colors.greenAccent,
          ),
          Container(
            width: 2,
            height: 60.h,
            color: Theme.of(context).primaryColor.withOpacity(0.2),
          ),
          ScoreItem(
            label: AppStrings.playerO,
            score: widget.scoreso,
            color:
                widget.winner == 'X'
                    ? AppColors.playerOColor
                    : Colors.greenAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          AppPrimaryGradientButton(
            label: AppStrings.playAgain,
            type: ButtonType.primary,
            icon: Icons.play_arrow_rounded,
            onPressed: widget.onPlayAgain,
            size: ButtonSize.large,
            width: double.infinity,
            height: 55,
            padding: EdgeInsets.all(0),
            borderRadius: BorderRadius.circular(30),
          ),
          SizedBox(height: 12.h),
          AppPrimaryGradientButton(
            label: AppStrings.backToHome,
            icon: Icons.home_rounded,
            gradient: LinearGradient(
              colors: [AppColors.transparent, AppColors.transparent],
            ),
            size: ButtonSize.large,
            width: double.infinity,
            height: 55,
            padding: EdgeInsets.all(0),
            shadowColor: AppColors.transparent,
            borderRadius: BorderRadius.circular(30),
            borderColor: Theme.of(context).primaryColor,
            textColor: Theme.of(context).primaryColor,
            iconColor: Theme.of(context).primaryColor,
            fontSize: 15,
            onPressed: widget.onQuit,
          ),
        ],
      ),
    );
  }

  Widget _buildConfetti() {
    return Stack(
      children: List.generate(
        20,
        (index) => AnimatedBuilder(
          animation: _confettiController,
          builder: (context, child) {
            final progress = _confettiController.value;
            final randomX = (index * 37) % 100 / 100;
            final randomDelay = index * 0.05;
            final adjustedProgress = (progress - randomDelay) % 1;

            if (adjustedProgress < 0) return SizedBox();

            return Positioned(
              left: MediaQuery.of(context).size.width * randomX,
              top: MediaQuery.of(context).size.height * (adjustedProgress - 1),
              child: Opacity(
                opacity:
                    (1 - adjustedProgress) > 0.3
                        ? 1
                        : (1 - adjustedProgress) / 0.3,
                child: Transform.rotate(
                  angle: adjustedProgress * 6.28,
                  child: Icon(
                    [
                      Icons.celebration,
                      Icons.star,
                      Icons.favorite,
                      Icons.emoji_events,
                    ][index % 4],
                    color:
                        [
                          Colors.yellow,
                          Colors.red,
                          Colors.blue,
                          Colors.green,
                        ][index % 4],
                    size: 24.sp,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
