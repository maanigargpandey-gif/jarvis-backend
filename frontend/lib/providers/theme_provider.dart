import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;
  String _fontFamily = 'Inter';
  String _headerFontFamily = 'Rajdhani';
  double _glassOpacity = 0.15;
  double _blurIntensity = 20.0;
  bool _isGlassMorphismEnabled = true;
  
  ThemeMode get themeMode => _themeMode;
  String get fontFamily => _fontFamily;
  String get headerFontFamily => _headerFontFamily;
  double get glassOpacity => _glassOpacity;
  double get blurIntensity => _blurIntensity;
  bool get isGlassMorphismEnabled => _isGlassMorphismEnabled;
  
  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
    print('🔮 Theme toggled to: ${_themeMode == ThemeMode.dark ? "Dark" : "Light"}');
  }
  
  void setThemeMode(String mode) {
    switch (mode.toLowerCase()) {
      case 'light': _themeMode = ThemeMode.light; break;
      case 'dark': _themeMode = ThemeMode.dark; break;
      case 'system': _themeMode = ThemeMode.system; break;
    }
    notifyListeners();
  }
  
  void setGlassMorphism(bool enabled) {
    _isGlassMorphismEnabled = enabled;
    notifyListeners();
  }
  
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.indigo,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF6C63FF),
      secondary: Color(0xFF00BFA6),
      surface: Colors.white,
      error: Color(0xFFE53935),
    ),
    textTheme: GoogleFonts.interTextTheme(),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white.withOpacity(0.8),
      elevation: 0,
      iconTheme: const IconThemeData(color: Color(0xFF2D3142)),
      titleTextStyle: GoogleFonts.rajdhani(
        fontSize: 24, fontWeight: FontWeight.w700, color: const Color(0xFF2D3142),
      ),
    ),
    cardTheme: CardTheme(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white,
    ),
  );
  
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.indigo,
    scaffoldBackgroundColor: const Color(0xFF0A0E21),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF7C4DFF),
      secondary: Color(0xFF00E5FF),
      surface: Color(0xFF1A1A2E),
      error: Color(0xFFCF6679),
    ),
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF0A0E21).withOpacity(0.8),
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: GoogleFonts.rajdhani(
        fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white,
      ),
    ),
    cardTheme: CardTheme(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: const Color(0xFF1A1A2E),
    ),
  );
  
  Widget glassMorphismContainer({required Widget child, Color? tint}) {
    if (!_isGlassMorphismEnabled) return child;
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: _blurIntensity, sigmaY: _blurIntensity),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [
                (tint ?? Colors.white).withOpacity(_glassOpacity),
                (tint ?? Colors.white).withOpacity(_glassOpacity * 0.5),
              ],
            ),
            border: Border.all(color: (tint ?? Colors.white).withOpacity(0.2), width: 1.5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: child,
        ),
      ),
    );
  }
}
