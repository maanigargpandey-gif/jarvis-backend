import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ZarvishTheme {
  static ThemeData get cyberpunkDark {
    return ThemeData.dark().copyWith(
      // 1. Dark Ash Grey Background (Master Prompt से)
      scaffoldBackgroundColor: const Color(0xFF121215), 
      
      // 2. Emerald Green & Electric Blue Accents
      primaryColor: const Color(0xFF00FF41), // Hacker Green
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF00FF41),
        secondary: Color(0xFF00E5FF), // Electric Blue (Figma Standard)
        surface: Color(0xFF1E1E24), // Frosted Glass Base
      ),
      
      // 3. Typography (Crisp Hacker Font)
      textTheme: GoogleFonts.firaCodeTextTheme(ThemeData.dark().textTheme),
      
      // 4. App Bar Styling
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0A0A0C), // Deepest Black
        elevation: 0,
        centerTitle: true,
      ),
      
      // 5. Floating Action & Icons
      iconTheme: const IconThemeData(
        color: Color(0xFF00FF41),
      ),
    );
  }
}
