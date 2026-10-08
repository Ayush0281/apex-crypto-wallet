import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Primary Backgrounds
  static const Color background = Color(0xFF0B0E14);
  static const Color surface = Color(0xFF121722);
  static const Color card = Color(0xFF1A1F2C);
  static const Color cardElevated = Color(0xFF22293A);
  static const Color cardBorder = Color(0x1AFFFFFF); // 10% white
  static const Color cardBorderGlow = Color(0x3300E676);

  // Accent Colors
  static const Color primary = Color(0xFF00E676); // Neon Green
  static const Color primaryGlow = Color(0x6600E676);
  static const Color secondary = Color(0xFF00E5FF); // Electric Cyan
  static const Color accentPurple = Color(0xFF7C4DFF); // Neon Violet
  static const Color accentOrange = Color(0xFFFF9100); // Amber / BTC orange

  // Status & Utility
  static const Color green = Color(0xFF00E676);
  static const Color red = Color(0xFFFF5252);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF90A0B7);
  static const Color textMuted = Color(0xFF5E6D82);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF00E676), Color(0xFF00B0FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1E2536), Color(0xFF141926)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient balanceCardGradient = LinearGradient(
    colors: [Color(0xFF1A233A), Color(0xFF121727), Color(0xFF0F1B2E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient purpleGradient = LinearGradient(
    colors: [Color(0xFF7C4DFF), Color(0xFFB388FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient btcGradient = LinearGradient(
    colors: [Color(0xFFF7931A), Color(0xFFFFAB40)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient ethGradient = LinearGradient(
    colors: [Color(0xFF627EEA), Color(0xFF8C9EFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient solGradient = LinearGradient(
    colors: [Color(0xFF14F195), Color(0xFF9945FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient adaGradient = LinearGradient(
    colors: [Color(0xFF0033AD), Color(0xFF2979FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        error: AppColors.red,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: AppColors.textPrimary,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(
        ThemeData.dark().textTheme.copyWith(
          displayLarge: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
          displayMedium: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
          headlineLarge: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700),
          headlineMedium: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
          titleLarge: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
          titleMedium: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
          bodyLarge: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
          bodyMedium: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
          bodySmall: const TextStyle(color: AppColors.textMuted, fontSize: 12),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.cardBorder, width: 1),
        ),
      ),
    );
  }
}
