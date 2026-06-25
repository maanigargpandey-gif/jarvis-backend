import 'package:flutter/material.dart';

class GlowingWaveform extends StatefulWidget {
  final bool isActive;
  final double height;
  final Color? color;
  
  const GlowingWaveform({super.key, required this.isActive, this.height = 40, this.color});
  
  @override
  _GlowingWaveformState createState() => _GlowingWaveformState();
}

class _GlowingWaveformState extends State<GlowingWaveform> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 2), vsync: this);
    if (widget.isActive) _controller.repeat();
  }
  
  @override
  void didUpdateWidget(GlowingWaveform oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) _controller.repeat();
    else if (!widget.isActive && oldWidget.isActive) _controller.stop();
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
          painter: WaveformPainter(
            progress: _controller.value,
            color: widget.color ?? Theme.of(context).colorScheme.primary,
            isActive: widget.isActive,
          ),
          size: Size(double.infinity, widget.height),
        );
      },
    );
  }
}

class WaveformPainter extends CustomPainter {
  final double progress;
  final Color color;
  final bool isActive;
  
  WaveformPainter({required this.progress, required this.color, required this.isActive});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..style = PaintingStyle.fill;
    final path = Path();
    final width = size.width;
    final height = size.height;
    final bars = 20;
    final barWidth = width / bars;
    
    for (int i = 0; i < bars; i++) {
      double amplitude = isActive ? (0.3 + 0.7 * (0.5 + 0.5 * (progress * 2 * 3.14159 + i * 0.3).sin)) : 0.1;
      final barHeight = height * amplitude;
      final x = i * barWidth;
      final y = (height - barHeight) / 2;
      path.addRRect(RRect.fromRectAndRadius(Rect.fromLTWH(x + 2, y, barWidth - 4, barHeight), const Radius.circular(2)));
    }
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(WaveformPainter oldDelegate) => true;
}
