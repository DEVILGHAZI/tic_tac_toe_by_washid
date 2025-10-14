import 'package:digital_guruji_assignment_tic_tac_toe/core/constants/app_colors.dart';
import 'package:digital_guruji_assignment_tic_tac_toe/core/widgets/circular_icon_button.dart';
import 'package:digital_guruji_assignment_tic_tac_toe/core/widgets/primary_button.dart';
import 'package:digital_guruji_assignment_tic_tac_toe/features/game/presentation/pages/game_histoy_screen.dart';
import 'package:digital_guruji_assignment_tic_tac_toe/features/home/widget/grid_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:digital_guruji_assignment_tic_tac_toe/core/utils/enum.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/theme_cubit.dart';
import '../../core/widgets/animated_background.dart';
import '../../core/utils/sound_effects.dart';
import '../game/presentation/bloc/game_bloc.dart';
import '../game/presentation/bloc/game_event.dart';
import '../game/presentation/pages/game_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _titleController;
  late AnimationController _buttonController;
  late AnimationController _floatingController;
  late AnimationController _pulseController;
  late AnimationController _glowController;
  late Animation<double> _titleScaleAnimation;
  late Animation<Offset> _titleSlideAnimation;
  late Animation<double> _buttonFadeAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    SoundEffects.playStart(loop: true);
  }

  void _initializeAnimations() {
    _titleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _titleScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _titleController, curve: Curves.elasticOut),
    );

    _titleSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _titleController, curve: Curves.easeOutCubic),
    );

    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _buttonFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );
    _floatingController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat(reverse: true);

    _floatingAnimation = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.3, end: 0.6).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _titleController.forward().then((_) {
      _buttonController.forward();
    });
  }

  @override
  void dispose() {
    SoundEffects.stopLoop();
    _titleController.dispose();
    _buttonController.dispose();
    _floatingController.dispose();
    _pulseController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;

    return Scaffold(
      body: AnimatedBackground(
        child: SafeArea(
          child: Stack(
            children: [
              _buildGridPattern(isDark),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                child: Column(
                  children: [
                    _buildHeader(context, isDark),
                    const Spacer(),
                    _buildAnimatedTitle(),
                    SizedBox(height: 60.h),
                    _buildAnimatedButtons(context),
                    SizedBox(height: 12.h),
                    _buildAIModeButtons(context),
                    const Spacer(),
                    _buildFooter(context),
                  ],
                ),
              ),
              _buildFloatingDecorations(isDark),
            ],
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

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AnimatedBuilder(
          animation: _buttonController,
          builder: (context, child) {
            return Transform.scale(
              scale:
                  Tween<double>(begin: 0.0, end: 1.0)
                      .animate(
                        CurvedAnimation(
                          parent: _buttonController,
                          curve: const Interval(
                            0.0,
                            0.5,
                            curve: Curves.elasticOut,
                          ),
                        ),
                      )
                      .value,
              child: CircularIconButton(
                icon:
                    isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                iconColor: Theme.of(context).primaryColor,
                onPressed: () {
                  context.read<ThemeCubit>().toggleTheme();
                },
              ),
            );
          },
        ),

        AnimatedBuilder(
          animation: _buttonController,
          builder: (context, child) {
            return Transform.scale(
              scale:
                  Tween<double>(begin: 0.0, end: 1.0)
                      .animate(
                        CurvedAnimation(
                          parent: _buttonController,
                          curve: const Interval(
                            0.2,
                            0.7,
                            curve: Curves.elasticOut,
                          ),
                        ),
                      )
                      .value,
              child: CircularIconButton(
                icon: Icons.history,
                iconColor: Theme.of(context).primaryColor,
                onPressed: () {
                  _showHistoryBottomSheet(context);
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAnimatedTitle() {
    return SlideTransition(
      position: _titleSlideAnimation,
      child: ScaleTransition(
        scale: _titleScaleAnimation,
        child: Column(
          children: [
            AnimatedBuilder(
              animation: _glowAnimation,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).primaryColor.withOpacity(_glowAnimation.value * 0.4),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: child,
                );
              },
              child: Text(
                AppStrings.appName,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 52.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 16.h),
            AnimatedBuilder(
              animation: _floatingAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _floatingAnimation.value * 0.5),
                  child: Opacity(
                    opacity: 0.9,
                    child: Text(
                      'Challenge Your Friend!',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 17.sp,
                        letterSpacing: 0.5,
                        color: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.color?.withOpacity(0.85),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedButtons(BuildContext context) {
    return FadeTransition(
      opacity: _buttonFadeAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.4),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _buttonController,
            curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
          ),
        ),
        child: Column(
          children: [
            _buildButtonWithHoverEffect(
              context: context,
              label: AppStrings.startGame,
              icon: Icons.play_arrow,
              type: ButtonType.primary,
              delay: 0.0,
              onPressed: () async {
                SoundEffects.stopLoop();
                context.read<GameBloc>().add(const LoadScoresEvent());
                await Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder:
                        (context, animation, secondaryAnimation) =>
                            const GameScreen(),
                    transitionsBuilder: (
                      context,
                      animation,
                      secondaryAnimation,
                      child,
                    ) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                  ),
                );
                SoundEffects.playStart(loop: true);
              },
            ),
            SizedBox(height: 16.h),
            _buildButtonWithHoverEffect(
              context: context,
              label: AppStrings.continueGame,
              icon: Icons.restore_rounded,
              type: ButtonType.secondary,
              delay: 0.15,
              onPressed: () async {
                SoundEffects.stopLoop();
                await Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder:
                        (context, animation, secondaryAnimation) =>
                            const GameScreen(),
                    transitionsBuilder: (
                      context,
                      animation,
                      secondaryAnimation,
                      child,
                    ) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                  ),
                );
                SoundEffects.playStart(loop: true);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonWithHoverEffect({
    required BuildContext context,
    required String label,
    required IconData icon,
    required ButtonType type,
    required double delay,
    required VoidCallback onPressed,
  }) {
    return AnimatedBuilder(
      animation: _buttonController,
      builder: (context, child) {
        final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _buttonController,
            curve: Interval(delay, delay + 0.5, curve: Curves.easeOut),
          ),
        );

        return Transform.scale(scale: animation.value, child: child);
      },
      child: AppPrimaryGradientButton(
        label: label,
        icon: icon,
        width: double.infinity,
        height: 55,
        padding: EdgeInsets.all(0),
        borderRadius: BorderRadius.circular(30),
        size: ButtonSize.large,
        type: type,
        enableShadow: type == ButtonType.primary,
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildAIModeButtons(BuildContext context) {
    return FadeTransition(
      opacity: _buttonFadeAnimation,
      child: AnimatedBuilder(
        animation: _buttonController,
        builder: (context, child) {
          return Transform.scale(
            scale:
                Tween<double>(begin: 0.0, end: 1.0)
                    .animate(
                      CurvedAnimation(
                        parent: _buttonController,
                        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
                      ),
                    )
                    .value,
            child: child,
          );
        },
        child: Column(
          children: [
            AppPrimaryGradientButton(
              label: AppStrings.playVsAI,
              icon: Icons.smart_toy_rounded,
              width: double.infinity,
              height: 55,
              padding: EdgeInsets.all(0),
              borderRadius: BorderRadius.circular(30),
              size: ButtonSize.large,
              type: ButtonType.success,
              enableShadow: true,
              onPressed: () async {
                SoundEffects.stopLoop();
                context.read<GameBloc>().add(
                  const StartVsAIEvent(humanSymbol: 'X'),
                );
                await Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder:
                        (context, animation, secondaryAnimation) =>
                            const GameScreen(),
                    transitionsBuilder: (
                      context,
                      animation,
                      secondaryAnimation,
                      child,
                    ) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                  ),
                );
                SoundEffects.playStart(loop: true);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return FadeTransition(
      opacity: _buttonFadeAnimation,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: Theme.of(context).primaryColor.withOpacity(0.08),
              border: Border.all(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Text(
              'Made with ❤️ using Flutter By Washid',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w400,
                letterSpacing: 0.3,
              ),
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _buildFloatingDecorations(bool isDark) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            Positioned(
              top: 120.h,
              right: 20.w,
              child: AnimatedBuilder(
                animation: Listenable.merge([
                  _floatingAnimation,
                  _pulseAnimation,
                  _glowAnimation,
                ]),
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(
                      _floatingAnimation.value * 1.5,
                      _floatingAnimation.value * 0.8,
                    ),
                    child: Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
                        width: 90.w,
                        height: 90.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Theme.of(context).primaryColor.withOpacity(
                                _glowAnimation.value * 0.4,
                              ),
                              Theme.of(context).primaryColor.withOpacity(0.05),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'X',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 48.sp,
                              color: Theme.of(
                                context,
                              ).primaryColor.withOpacity(0.6),
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            Positioned(
              bottom: 180.h,
              left: 15.w,
              child: AnimatedBuilder(
                animation: Listenable.merge([
                  _floatingAnimation,
                  _pulseAnimation,
                  _glowAnimation,
                ]),
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(
                      -_floatingAnimation.value * 1.2,
                      _floatingAnimation.value,
                    ),
                    child: Transform.scale(
                      scale: _pulseAnimation.value * 0.95,
                      child: Container(
                        width: 75.w,
                        height: 75.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppColors.orangeColor.withOpacity(
                                _glowAnimation.value * 0.35,
                              ),
                              AppColors.orangeColor.withOpacity(0.08),
                              AppColors.transparent,
                            ],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'O',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 42.sp,
                              color: AppColors.orangeColor.withOpacity(0.5),
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            Positioned(
              top: 200.h,
              left: 30.w,
              child: AnimatedBuilder(
                animation: Listenable.merge([
                  _floatingAnimation,
                  _glowAnimation,
                ]),
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(
                      -_floatingAnimation.value * 0.8,
                      _floatingAnimation.value * 1.5,
                    ),
                    child: Opacity(
                      opacity: _glowAnimation.value * 0.7,
                      child: Text(
                        'X',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 28.sp,
                          color: Theme.of(
                            context,
                          ).primaryColor.withOpacity(0.3),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              bottom: 250.h,
              right: 40.w,
              child: AnimatedBuilder(
                animation: Listenable.merge([
                  _floatingAnimation,
                  _glowAnimation,
                ]),
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(
                      _floatingAnimation.value,
                      -_floatingAnimation.value * 0.7,
                    ),
                    child: Opacity(
                      opacity: _glowAnimation.value * 0.6,
                      child: Text(
                        'O',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 24.sp,
                          color: AppColors.orangeColor.withOpacity(0.35),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showHistoryBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return HistoryScreen();
      },
    );
  }
}
