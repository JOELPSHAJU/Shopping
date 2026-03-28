import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  // ─── DARK (current premium dark mode) ───────────────────────────────────
  static ThemeData get darkTheme {
    final base = ThemeData.dark();
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.cardDark,
        onSurface: AppColors.white,
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.primary),
      ),
      textTheme: GoogleFonts.poppinsTextTheme(
        base.textTheme.copyWith(
          displayLarge: const TextStyle(
            fontSize: 56,
            fontWeight: FontWeight.w300,
            color: AppColors.white,
            letterSpacing: 8,
          ),
          headlineMedium: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w400,
            color: AppColors.white,
            letterSpacing: 6,
          ),
          titleLarge: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AppColors.primary,
            letterSpacing: 2,
          ),
          bodyLarge: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w300,
            color: AppColors.textBody,
            letterSpacing: 0.5,
          ),
          bodyMedium: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w300,
            color: AppColors.textBody,
            letterSpacing: 1,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.black,
          elevation: 0,
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
          shape: const ContinuousRectangleBorder(),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 0.5),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
          shape: const ContinuousRectangleBorder(),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: AppColors.cardLight, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: AppColors.cardLight, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: AppColors.accent, width: 1),
        ),
      ),
    );
  }

  // ─── LIGHT (clean ivory high-fashion) ───────────────────────────────────
  static ThemeData get lightTheme {
    final base = ThemeData.light();
    const bg = Color(0xFFF8F5F0); // Warm ivory
    const card = Color(0xFFEFEBE5);
    const cardEl = Color(0xFFE5E0D8);
    const textMain = Color(0xFF1A1A1A);
    const textMuted = Color(0xFF888480);
    const accentLight = Color(0xFFB8956A); // Warm tan/gold

    return base.copyWith(
      scaffoldBackgroundColor: bg,
      primaryColor: textMain,
      colorScheme: base.colorScheme.copyWith(
        primary: textMain,
        secondary: textMuted,
        surface: card,
        onSurface: textMain,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bg,
        elevation: 0,
        iconTheme: IconThemeData(color: textMain),
        foregroundColor: textMain,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(
        base.textTheme.copyWith(
          displayLarge: const TextStyle(
            fontSize: 56,
            fontWeight: FontWeight.w300,
            color: textMain,
            letterSpacing: 8,
          ),
          headlineMedium: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w400,
            color: textMain,
            letterSpacing: 6,
          ),
          titleLarge: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: textMain,
            letterSpacing: 2,
          ),
          bodyLarge: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w300,
            color: textMuted,
            letterSpacing: 0.5,
          ),
          bodyMedium: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w300,
            color: textMuted,
            letterSpacing: 1,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: textMain,
          foregroundColor: bg,
          elevation: 0,
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
          shape: const ContinuousRectangleBorder(),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textMain,
          side: const BorderSide(color: textMain, width: 0.5),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
          shape: const ContinuousRectangleBorder(),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: card,
        hintStyle: const TextStyle(color: textMuted),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: cardEl, width: 0.5),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: cardEl, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: accentLight, width: 1),
        ),
      ),
    );
  }
}
