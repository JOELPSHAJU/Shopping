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
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.lightBackground,
      primaryColor: AppColors.lightTextTitle,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.lightTextTitle,
        secondary: AppColors.lightTextBody,
        surface: AppColors.lightCard,
        onSurface: AppColors.lightTextTitle,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.lightTextTitle),
        foregroundColor: AppColors.lightTextTitle,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(
        base.textTheme.copyWith(
          displayLarge: const TextStyle(
            fontSize: 56,
            fontWeight: FontWeight.w300,
            color: AppColors.lightTextTitle,
            letterSpacing: 8,
          ),
          headlineMedium: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w400,
            color: AppColors.lightTextTitle,
            letterSpacing: 6,
          ),
          titleLarge: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AppColors.lightTextTitle,
            letterSpacing: 2,
          ),
          bodyLarge: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w300,
            color: AppColors.lightTextBody,
            letterSpacing: 0.5,
          ),
          bodyMedium: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w300,
            color: AppColors.lightTextBody,
            letterSpacing: 1,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightTextTitle,
          foregroundColor: AppColors.lightBackground,
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
          foregroundColor: AppColors.lightTextTitle,
          side: const BorderSide(color: AppColors.lightTextTitle, width: 0.5),
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
        fillColor: AppColors.lightCard,
        hintStyle: TextStyle(color: AppColors.lightTextBody),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: AppColors.lightBorder, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: AppColors.lightBorder, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: AppColors.accent, width: 1),
        ),
      ),
    );
  }
}
