import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF2F2F2F),
      onPrimary: Color(0xFFFDFDFD),
      secondary: Color(0xFFF2F2F2),
      onSecondary: Color(0xFF2F2F2F),
      surface: Color(0xFFFFFFFF),
      onSurface: Color(0xFF1F1F1F),
      surfaceContainer: Color(0xFFF5F5F5),
      onSurfaceVariant: Color(0xFF6F6F6F),
      outline: Color(0xFFE0E0E0),
      error: Color(0xFFD32F2F),
    ),
  );

  static ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFE5E5E5),
      onPrimary: Color(0xFF2F2F2F),
      secondary: Color(0xFF3A3A3A),
      onSecondary: Color(0xFFF5F5F5),
      surface: Color(0xFF0D0D0D),
      onSurface: Color(0xFFF5F5F5),
      surfaceContainer: Color(0xFF2A2A2A),
      onSurfaceVariant: Color(0xFFB0B0B0),
      outline: Color(0x33FFFFFF),
      error: Color(0xFFEF5350),
    ),
  );
}
