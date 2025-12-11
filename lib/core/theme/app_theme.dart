// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:google_fonts/google_fonts.dart';

// Project imports:
import 'package:meu_curriculo_flutter/core/constants/app_constants.dart';

class AppTheme {
  // Cores Light
  static const Color _lightBackground = Color(0xFFF9F9F9);
  static const Color _lightSurface = Colors.white;
  static const Color _lightText = Color(0xFF1A1A1A);

  // Cores Dark (Cyberpunk/Professional)
  static const Color _darkBackground = Color(0xFF121212);
  static const Color _darkSurface = Color(0xFF1E1E1E);
  static const Color _darkText = Color(0xFFE0E0E0);

  static ThemeData get lightTheme => _buildTheme(
    brightness: Brightness.light,
    background: _lightBackground,
    surface: _lightSurface,
    textColor: _lightText,
  );

  static ThemeData get darkTheme => _buildTheme(
    brightness: Brightness.dark,
    background: _darkBackground,
    surface: _darkSurface,
    textColor: _darkText,
  );

  static ThemeData _buildTheme({
    required final Brightness brightness,
    required final Color background,
    required final Color surface,
    required final Color textColor,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(AppColors.primary),
        brightness: brightness,
        surface: surface,
      ),
      textTheme: GoogleFonts.poppinsTextTheme().apply(
        bodyColor: textColor,
        displayColor: textColor,
      ),
      cardTheme: CardThemeData(
        elevation: 0, // Design flat é mais moderno
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: brightness == Brightness.dark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.05),
          ),
        ),
        color: surface,
        surfaceTintColor: Colors.transparent,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(AppColors.primary),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 4,
          shadowColor: const Color(AppColors.primary).withValues(alpha: 0.4),
        ),
      ),
      iconTheme: IconThemeData(color: textColor),
    );
  }
}
