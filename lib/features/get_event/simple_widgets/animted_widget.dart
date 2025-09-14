import 'package:flutter/material.dart';

class AnimatedFlipCard extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration totalDuration;

  const AnimatedFlipCard({
    super.key,
    required this.child,
    required this.index,
    this.totalDuration = const Duration(seconds: 2),
  });

  @override
  State<AnimatedFlipCard> createState() => _AnimatedFlipCardState();
}

class _AnimatedFlipCardState extends State<AnimatedFlipCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.totalDuration,
      vsync: this,
    );

    _flipAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          widget.index * 0.1,
          widget.index * 0.1 + 0.6,
          curve: Curves.easeInOutBack,
        ),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _flipAnimation,
      builder: (context, child) {
        final angle = _flipAnimation.value * 3.1416;
        final transform = Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateY(angle);
        return Transform(
          transform: transform,
          alignment: Alignment.center,
          child: angle <= 3.1416 / 2 ? widget.child : widget.child,
        );
      },
    );
  }
}
