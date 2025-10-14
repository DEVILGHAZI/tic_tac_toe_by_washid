import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/animated_background.dart';
import '../../core/utils/sound_effects.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _controller.forward();
    SoundEffects.playStart();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        SoundEffects.stopLoop();
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder:
                (context, animation, secondaryAnimation) => const HomeScreen(),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: AnimatedBackground(
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // X and O Icons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSymbol('X', AppColors.playerXColor, isDark),
                          SizedBox(width: 20.w),
                          _buildSymbol('O', AppColors.playerOColor, isDark),
                        ],
                      ),
                      SizedBox(height: 40.h),

                      // App Name
                      Text(
                        AppStrings.appName,
                        style: Theme.of(context).textTheme.displayMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20.h),

                      // Loading Indicator
                      SizedBox(
                        width: 40.w,
                        height: 40.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isDark
                                ? AppColors.darkPrimary
                                : AppColors.lightPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSymbol(String symbol, Color color, bool isDark) {
    return Container(
      width: 80.w,
      height: 80.h,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: Text(
          symbol,
          style: TextStyle(
            fontSize: 48.sp,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }
}
