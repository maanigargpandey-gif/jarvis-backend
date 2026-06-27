import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedLogoBackground extends StatefulWidget {
  const AnimatedLogoBackground({super.key});

  @override
  State<AnimatedLogoBackground> createState() => _AnimatedLogoBackgroundState();
}

class _AnimatedLogoBackgroundState extends State<AnimatedLogoBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _LogoPainter(_controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class _LogoPainter extends CustomPainter {
  final double animationValue;

  _LogoPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF7C4DFF).withOpacity(0.03)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) * 0.3;
    
    // Draw rotating circles
    for (int i = 0; i < 3; i++) {
      final angle = animationValue * 2 * pi + (i * 2 * pi / 3);
      final x = center.dx + cos(angle) * radius * 0.5;
      final y = center.dy + sin(angle) * radius * 0.5;
      
      canvas.drawCircle(Offset(x, y), radius * 0.3, paint);
    }
    
    // Draw central logo shape
    final logoPaint = Paint()
      ..color = const Color(0xFF7C4DFF).withOpacity(0.05)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(center, radius * 0.2, logoPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

