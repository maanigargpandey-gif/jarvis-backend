import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ZarvishTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.indigo,
    scaffoldBackgroundColor: const Color(0xFFF5F5F7),
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
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF2D3142),
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
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    ),
    cardTheme: CardTheme(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: const Color(0xFF1A1A2E),
    ),
  );
}
