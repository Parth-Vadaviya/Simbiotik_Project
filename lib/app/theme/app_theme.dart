import 'package:flutter/material.dart';

class AppTheme {
  // Core palette — clean dark surfaces, single accent
  static const Color scaffold = Color(0xFF0F1117);
  static const Color surface = Color(0xFF1A1D27);
  static const Color surfaceElevated = Color(0xFF1F2235);
  static const Color cardSurface = Color(0xFF1C1F2E);
  static const Color accent = Color(0xFF5B6EF5);
  static const Color accentDim = Color(0xFF3D4EC4);
  static const Color amber = Color(0xFFFFB703);
  static const Color textPrimary = Color(0xFFECEEF8);
  static const Color textSecondary = Color(0xFF7A82A8);
  static const Color textMuted = Color(0xFF4E5470);
  static const Color border = Color(0xFF262A3E);
  static const Color borderLight = Color(0xFF2E3350);
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color tagBg = Color(0xFF232640);

  // Avatar palette — distinct colors per letter bucket
  static const List<Color> avatarColors = [
    Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFFEC4899),
    Color(0xFF06B6D4), Color(0xFF10B981), Color(0xFFF59E0B),
    Color(0xFFEF4444), Color(0xFF3B82F6),
  ];

  static Color avatarColor(String name) {
    if (name.isEmpty) return avatarColors[0];
    return avatarColors[name.codeUnitAt(0) % avatarColors.length];
  }

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: scaffold,
        colorScheme: const ColorScheme.dark(
          primary: accent,
          secondary: amber,
          surface: surface,
          error: error,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: surface,
          foregroundColor: textPrimary,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.w800),
          headlineMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.w700),
          titleLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.w600, fontSize: 18),
          titleMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.w500, fontSize: 15),
          bodyLarge: TextStyle(color: textPrimary, fontSize: 15, height: 1.65),
          bodyMedium: TextStyle(color: textSecondary, fontSize: 13, height: 1.5),
          labelLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.w600, fontSize: 15),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: surface,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: accent, width: 1.5),
          ),
          hintStyle: const TextStyle(color: textMuted, fontSize: 14),
          prefixIconColor: textMuted,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: accent,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            shadowColor: Colors.transparent,
          ),
        ),
        dividerTheme: const DividerThemeData(color: border, thickness: 1, space: 0),
      );
}
