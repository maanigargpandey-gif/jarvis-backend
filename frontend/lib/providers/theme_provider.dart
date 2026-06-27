import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;
  bool _isGlassMorphismEnabled = true;
  double _glassOpacity = 0.15;
  double _blurIntensity = 20.0;

  ThemeMode get themeMode => _themeMode;
  bool get isGlassMorphismEnabled => _isGlassMorphismEnabled;
  double get glassOpacity => _glassOpacity;
  double get blurIntensity => _blurIntensity;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  void setGlassMorphism(bool enabled) {
    _isGlassMorphismEnabled = enabled;
    notifyListeners();
  }

  Widget glassMorphismContainer({required Widget child, Color? tint}) {
    if (!_isGlassMorphismEnabled) return child;
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: _blurIntensity, sigmaY: _blurIntensity),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                (tint ?? Colors.white).withOpacity(_glassOpacity),
                (tint ?? Colors.white).withOpacity(_glassOpacity * 0.5),
              ],
            ),
            border: Border.all(
              color: (tint ?? Colors.white).withOpacity(0.2),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: child,
        ),
      ),
    );
  }
}
