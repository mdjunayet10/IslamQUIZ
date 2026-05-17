import 'package:flutter/material.dart';

class AppTheme {
  static const Color midnight = Color(0xFF06140F);
  static const Color deepNavy = Color(0xFF071A2C);
  static const Color emerald = Color(0xFF0B6B4B);
  static const Color emeraldDark = Color(0xFF073D31);
  static const Color gold = Color(0xFFC9A227);
  static const Color softGold = Color(0xFFE8D48A);
  static const Color card = Color(0xE611241C);
  static const Color cardBorder = Color(0x33E8D48A);
  static const Color text = Color(0xFFF7F3E8);
  static const Color mutedText = Color(0xFFBDB6A3);
  static const Color correct = Color(0xFF32D583);
  static const Color wrong = Color(0xFFFF6B6B);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: midnight,
      colorScheme: const ColorScheme.dark(
        primary: gold,
        secondary: emerald,
        surface: card,
        error: wrong,
      ),
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 34,
          height: 1.05,
          fontWeight: FontWeight.w900,
          color: text,
          letterSpacing: -0.8,
        ),
        headlineMedium: TextStyle(
          fontSize: 26,
          height: 1.1,
          fontWeight: FontWeight.w800,
          color: text,
        ),
        titleLarge: TextStyle(
          fontSize: 21,
          fontWeight: FontWeight.w800,
          color: text,
        ),
        titleMedium: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: text,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          height: 1.45,
          color: text,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          height: 1.45,
          color: mutedText,
        ),
        labelLarge: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w800,
          color: text,
        ),
      ),
    );
  }
}
