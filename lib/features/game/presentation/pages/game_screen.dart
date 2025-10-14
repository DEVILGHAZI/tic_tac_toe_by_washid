import 'package:digital_guruji_assignment_tic_tac_toe/core/constants/app_colors.dart';
import 'package:digital_guruji_assignment_tic_tac_toe/core/theme/theme_cubit.dart';
import 'package:digital_guruji_assignment_tic_tac_toe/core/widgets/primary_button.dart';
import 'package:digital_guruji_assignment_tic_tac_toe/features/game/presentation/pages/draw_screen.dart';
import 'package:digital_guruji_assignment_tic_tac_toe/features/game/presentation/pages/win_screen.dart';
import 'package:digital_guruji_assignment_tic_tac_toe/features/game/presentation/widgets/show_settings_dilog.dart';
import 'package:digital_guruji_assignment_tic_tac_toe/features/home/widget/grid_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/animated_background.dart';
import '../../../../core/widgets/confirm_dilog.dart';
import '../../../../core/utils/enum.dart';
import '../../../../core/utils/sound_effects.dart';
import '../bloc/game_bloc.dart';
import '../bloc/game_event.dart';
import '../bloc/game_state.dart';
import '../widgets/game_board.dart';
import '../widgets/player_indicator.dart';
import '../widgets/score_board.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;
  late AnimationController _floatingController;
  late Animation<double> _floatingAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _floatingController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _floatingAnimation = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _slideController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SoundEffects.stopLoop();
        return true;
      },
      child: Scaffold(
        body: AnimatedBackground(
          child: SafeArea(
            child: BlocConsumer<GameBloc, GameState>(
              listener: (context, state) {
                if (state is GameWon) {
                  SoundEffects.playWinLoop();
                  Future.delayed(const Duration(milliseconds: 500), () {
                    if (context.mounted) {
                      _showResultDialog(context, state);
                    }
                  });
                } else if (state is GameDraw) {
                  SoundEffects.playDrawLoop();
                  Future.delayed(const Duration(milliseconds: 500), () {
                    if (context.mounted) {
                      _showResultDialog(context, state);
                    }
                  });
                }
              },
              builder: (context, state) {
                if (state is GameLoading) {
                  return _buildLoadingState();
                }

                if (state is GameError) {
                  return _buildErrorState(context, state);
                }

                if (state is GameInProgress ||
                    state is GameWon ||
                    state is GameDraw) {
                  final gameState =
                      state is GameInProgress
                          ? state.gameState
                          : state is GameWon
                          ? state.gameState
                          : (state as GameDraw).gameState;

                  return Stack(
                    children: [
                      _buildGridPattern(
                        context.watch<ThemeCubit>().state == ThemeMode.dark,
                      ),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Column(
                            children: [
                              SizedBox(height: 12.h),
                              _buildAnimatedAppBar(context),
                              SizedBox(height: 16.h),
                              ScaleTransition(
                                scale: Tween<double>(
                                  begin: 0.8,
                                  end: 1.0,
                                ).animate(
                                  CurvedAnimation(
                                    parent: _slideController,
                                    curve: const Interval(
                                      0.2,
                                      0.6,
                                      curve: Curves.easeOut,
                                    ),
                                  ),
                                ),
                                child: ScoreBoard(gameState: gameState),
                              ),
                              if (state is GameInProgress)
                                ScaleTransition(
                                  scale: _pulseAnimation,
                                  child: PlayerIndicator(
                                    currentPlayer: gameState.currentPlayer,
                                  ),
                                ),
                              Expanded(
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                    ),
                                    child: GameBoard(
                                      gameState: gameState,
                                      winningLine:
                                          state is GameWon
                                              ? state.winningLine
                                              : null,
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 24.h),
                              _buildActionButtons(context, state),
                              SizedBox(height: 20.h),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }

                return _buildLoadingState();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGridPattern(bool isDark) {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _floatingAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: isDark ? 0.03 : 0.05,
            child: CustomPaint(
              painter: GridPatternPainter(
                offset: _floatingAnimation.value,
                color: isDark ? Colors.white : Colors.black,
              ),
              size: Size.infinite,
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0).animate(
              CurvedAnimation(
                parent: _pulseController,
                curve: Curves.easeInOut,
              ),
            ),
            child: Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor.withOpacity(0.3),
                    Theme.of(context).primaryColor.withOpacity(0.1),
                  ],
                ),
              ),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            AppStrings.loadingGame,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, GameError state) {
    return Center(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.error.withOpacity(0.2),
                ),
                child: Icon(
                  Icons.error_rounded,
                  size: 64.sp,
                  color: AppColors.error,
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                AppStrings.oops,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              SizedBox(height: 12.h),
              Text(
                state.message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(height: 24.h),
              ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text(AppStrings.goBack),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-0.5, 0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOut),
        ),
        child: Row(
          children: [
            ScaleTransition(
              scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: _slideController,
                  curve: const Interval(0.0, 0.3, curve: Curves.elasticOut),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor.withOpacity(0.2),
                      Theme.of(context).primaryColor.withOpacity(0.1),
                    ],
                  ),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: () {
                    SoundEffects.stopLoop();
                    Navigator.of(context).pop();
                  },
                  iconSize: 26.sp,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            const Spacer(),
            FadeTransition(
              opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: _slideController,
                  curve: const Interval(0.2, 0.5, curve: Curves.easeInOut),
                ),
              ),
              child: Text(
                AppStrings.appName,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            const Spacer(),
            ScaleTransition(
              scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: _slideController,
                  curve: const Interval(0.3, 0.6, curve: Curves.elasticOut),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor.withOpacity(0.2),
                      Theme.of(context).primaryColor.withOpacity(0.1),
                    ],
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.settings_rounded),
                      onPressed: () => SettingsDialog.show(context),
                      iconSize: 26.sp,
                      color: Theme.of(context).primaryColor,
                    ),
                    BlocBuilder<GameBloc, GameState>(
                      builder: (context, state) {
                        final isVsAI =
                            state is GameInProgress
                                ? state.gameState.isVsAI
                                : state is GameWon
                                ? state.gameState.isVsAI
                                : state is GameDraw
                                ? state.gameState.isVsAI
                                : false;
                        return IconButton(
                          tooltip:
                              isVsAI ? 'Switch to PvP' : AppStrings.playVsAI,
                          icon: Icon(
                            isVsAI
                                ? Icons.people_rounded
                                : Icons.smart_toy_rounded,
                          ),
                          onPressed: () async {
                            if (isVsAI) {
                              // Switch to PvP mode
                              final confirm = await showConfirmDialog(
                                context: context,
                                title: AppStrings.switchToPvPTitle,
                                message: AppStrings.switchToPvPMessage,
                                confirmText: AppStrings.switchMode,
                                cancelText: AppStrings.cancel,
                                icon: Icons.people_rounded,
                                iconColor: AppColors.lightPrimary,
                                confirmButtonType: ButtonType.primary,
                              );
                              if (confirm == true) {
                                context.read<GameBloc>().add(
                                  const SwitchToPvPEvent(),
                                );
                              }
                            } else {
                              // Switch to AI mode
                              final confirm = await showConfirmDialog(
                                context: context,
                                title: AppStrings.switchToAITitle,
                                message: AppStrings.switchToAIMessage,
                                confirmText: AppStrings.switchMode,
                                cancelText: AppStrings.cancel,
                                icon: Icons.smart_toy_rounded,
                                iconColor: AppColors.success,
                                confirmButtonType: ButtonType.success,
                              );
                              if (confirm == true) {
                                context.read<GameBloc>().add(
                                  const StartVsAIEvent(humanSymbol: 'X'),
                                );
                              }
                            }
                          },
                          iconSize: 26.sp,
                          color:
                              isVsAI
                                  ? AppColors.success
                                  : Theme.of(context).primaryColor,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, GameState state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _slideController,
            curve: const Interval(0.4, 0.8, curve: Curves.easeOut),
          ),
        ),
        child: Column(
          children: [
            AppPrimaryGradientButton(
              label: AppStrings.restart,
              type: ButtonType.primary,
              icon: Icons.refresh_rounded,
              onPressed: () {
                SoundEffects.stopLoop();
                context.read<GameBloc>().add(const RestartGameEvent());
              },
              size: ButtonSize.large,
              width: double.infinity,
              height: 55,
              padding: EdgeInsets.all(0),
              borderRadius: BorderRadius.circular(30),
            ),
            if (state is GameWon || state is GameDraw) ...[
              SizedBox(height: 12.h),
              AppPrimaryGradientButton(
                label: AppStrings.newGame,
                type: ButtonType.success,
                icon: Icons.arrow_forward_rounded,
                onPressed: () {
                  SoundEffects.stopLoop();
                  context.read<GameBloc>().add(const RestartGameEvent());
                },
                fontSize: 15.sp,
                size: ButtonSize.large,
                width: double.infinity,
                height: 55.h,
                padding: EdgeInsets.all(0),
                borderRadius: BorderRadius.circular(30),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showResultDialog(BuildContext context, GameState state) {
    if (state is GameWon) {
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) => WinScreen(
                winner: state.winner.symbol,
                scoresx: state.gameState.playerXWins,
                scoreso: state.gameState.playerOWins,
                isVsAI: state.gameState.isVsAI,
                aiPlayer: state.gameState.aiPlayer?.symbol,
                onPlayAgain: () {
                  SoundEffects.stopLoop();
                  Navigator.of(context).pop();
                  context.read<GameBloc>().add(const RestartGameEvent());
                },
                onQuit: () {
                  SoundEffects.stopLoop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    } else if (state is GameDraw) {
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) => DrawScreen(
                scores: state.gameState.draws,
                onPlayAgain: () {
                  SoundEffects.stopLoop();
                  Navigator.of(context).pop();
                  context.read<GameBloc>().add(const RestartGameEvent());
                },
                onQuit: () {
                  SoundEffects.stopLoop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    }
  }
}
