import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  // Overwriting the theme with Avant-Garde Minimalist settings
  static ThemeData get lightTheme {
    final baseTheme = ThemeData.dark();

    return baseTheme.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      colorScheme: baseTheme.colorScheme.copyWith(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.cardDark,
        onSurface: AppColors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.primary),
      ),
      // Clean, very thin, minimalist high-fashion layout
      textTheme: GoogleFonts.poppinsTextTheme(
        // Poppins rendered thin acts nicely, normally Montserrat or PlayfairDisplay
        baseTheme.textTheme.copyWith(
          displayLarge: const TextStyle(
            fontSize: 56,
            fontWeight: FontWeight.w300, // Ultralight/thin for high fashion
            color: AppColors.white,
            letterSpacing: 8, // Very wide letter spacing
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
          shadowColor:
              Colors.transparent, // Disable shadows for ultra-flat modernism
          elevation: 0,
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
          shape: const ContinuousRectangleBorder(), // Sharp 90-degree corners
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 0.5),
          shadowColor: Colors.transparent,
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
        fillColor: AppColors.cardDark,
        hintStyle: const TextStyle(
          color: AppColors.textBody,
          letterSpacing: 2,
          fontWeight: FontWeight.w300,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: AppColors.cardLight, width: 0.5),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: AppColors.cardLight, width: 0.5),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(
            color: AppColors.accent,
            width: 1,
          ), // Gentle rose gold focus
        ),
      ),
    );
  }
}
