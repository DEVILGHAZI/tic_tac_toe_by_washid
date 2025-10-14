import 'package:flutter/material.dart';

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
