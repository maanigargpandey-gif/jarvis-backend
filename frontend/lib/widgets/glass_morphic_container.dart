import 'dart:ui';
import 'package:flutter/material.dart';

class GlassMorphicContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double blur;
  final double opacity;
  final LinearGradient? gradient;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  
  const GlassMorphicContainer({
    super.key, required this.child, this.borderRadius = 20.0, this.blur = 20.0,
    this.opacity = 0.15, this.gradient, this.borderColor, this.padding,
    this.width, this.height,
  });
  
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: width, height: height, padding: padding ?? const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            gradient: gradient ?? LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [Colors.white.withOpacity(opacity), Colors.white.withOpacity(opacity * 0.5)],
            ),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: borderColor ?? Colors.white.withOpacity(0.2), width: 1.5),
          ),
          child: child,
        ),
      ),
    );
  }
}
