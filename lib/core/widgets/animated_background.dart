import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AnimatedBackground extends StatefulWidget {
  final Widget child;
  
  const AnimatedBackground({
    super.key,
    required this.child,
  });

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      AppColors.darkGradient[0],
                      AppColors.darkGradient[1],
                      AppColors.darkGradient[0],
                    ]
                  : [
                      AppColors.lightGradient[0],
                      AppColors.lightGradient[1],
                      AppColors.lightGradient[0],
                    ],
              stops: [
                0.0,
                _animation.value,
                1.0,
              ],
            ),
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}