import 'package:flutter/material.dart';

// Button / Card press scale feedback animation
class AnimatedScalePress extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const AnimatedScalePress({super.key, required this.child, required this.onTap});

  @override
  State<AnimatedScalePress> createState() => _AnimatedScalePressState();
}

class _AnimatedScalePressState extends State<AnimatedScalePress> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.95),
      onTapUp: (_) {
        setState(() => _scale = 1.0);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: widget.child,
      ),
    );
  }
}

// Custom pulsing loader animation
class PulseLoadingIndicator extends StatefulWidget {
  const PulseLoadingIndicator({super.key});

  @override
  State<PulseLoadingIndicator> createState() => _PulseLoadingIndicatorState();
}

class _PulseLoadingIndicatorState extends State<PulseLoadingIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScaleTransition(
        scale: _animation,
        child: Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 199, 36, 14),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.restaurant_menu, color: Colors.white, size: 30),
        ),
      ),
    );
  }
}