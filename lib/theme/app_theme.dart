import 'package:flutter/material.dart';

/// Soft teal + white health palette (design tokens from the Figma file).
class LumaColors {
  static const teal = Color(0xFF1FA89A);
  static const tealDark = Color(0xFF0F6F66);
  static const tealLight = Color(0xFFDDF4F1);
  static const background = Color(0xFFF6FBFA);
  static const ink = Color(0xFF12302D);
  static const muted = Color(0xFF6C8884);
  static const danger = Color(0xFFD9534F);
}

class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: LumaColors.teal,
          primary: LumaColors.teal,
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: LumaColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: LumaColors.background,
          foregroundColor: LumaColors.ink,
          elevation: 0,
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0xFFE3F0EE)),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: LumaColors.teal,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
      );
}
