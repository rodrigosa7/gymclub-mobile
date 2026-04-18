import 'package:flutter/material.dart';

class GymClubTheme {
  // Surface colors
  static const Color surface = Color(0xFF0e0e0e);
  static const Color surfaceContainerLow = Color(0xFF131313);
  static const Color surfaceContainer = Color(0xFF1a1a1a);
  static const Color surfaceContainerHigh = Color(0xFF20201f);
  static const Color surfaceContainerHighest = Color(0xFF262626);

  // Primary - Neon Lime
  static const Color primary = Color(0xFFf4ffc9);
  static const Color primaryContainer = Color(0xFFcefc22);
  static const Color onPrimary = Color(0xFF526700);
  static const Color onPrimaryFixed = Color(0xFF3b4a00);

  // Secondary - Cyan
  static const Color secondary = Color(0xFF00e3fd);
  static const Color secondaryContainer = Color(0xFF006875);
  static const Color onSecondary = Color(0xFF004d57);

  // Tertiary - Electric Pink
  static const Color tertiary = Color(0xFFff6e84);
  static const Color tertiaryContainer = Color(0xFFfb2a60);
  static const Color tertiaryFixed = Color(0xFFff909e);
  static const Color tertiaryDim = Color(0xFFe51152);

  // Secondary colors
  static const Color secondaryDim = Color(0xFF00d4ec);
  static const Color onSecondaryContainer = Color(0xFFffffff);

// Tertiary - Electric Pink
  static const Color onTertiaryContainer = Color(0xFFffffff);

  // Text colors
  static const Color onSurface = Color(0xFFffffff);
  static const Color onSurfaceVariant = Color(0xFFadaaaa);

  // Error
  static const Color error = Color(0xFFff7351);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: surface,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        primaryContainer: primaryContainer,
        onPrimary: onPrimary,
        secondary: secondary,
        secondaryContainer: secondaryContainer,
        onSecondary: onSecondary,
        tertiary: tertiary,
        tertiaryContainer: tertiaryContainer,
        surface: surface,
        onSurface: onSurface,
        onSurfaceVariant: onSurfaceVariant,
        error: error,
      ),
      fontFamily: 'Manrope',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'SpaceGrotesk',
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: onSurface,
        ),
        displayMedium: TextStyle(
          fontFamily: 'SpaceGrotesk',
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: onSurface,
        ),
        displaySmall: TextStyle(
          fontFamily: 'SpaceGrotesk',
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: onSurface,
        ),
        headlineLarge: TextStyle(
          fontFamily: 'SpaceGrotesk',
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'SpaceGrotesk',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Manrope',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Manrope',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: onSurface,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Manrope',
          fontSize: 16,
          color: onSurface,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Manrope',
          fontSize: 14,
          color: onSurface,
        ),
        labelLarge: TextStyle(
          fontFamily: 'Manrope',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
        labelMedium: TextStyle(
          fontFamily: 'Manrope',
          fontSize: 12,
          color: onSurfaceVariant,
        ),
        labelSmall: TextStyle(
          fontFamily: 'Manrope',
          fontSize: 10,
          color: onSurfaceVariant,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: secondary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: error, width: 2),
        ),
        labelStyle: const TextStyle(color: onSurfaceVariant),
        hintStyle: const TextStyle(color: onSurfaceVariant),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimaryFixed,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9999),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Manrope',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'SpaceGrotesk',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
        iconTheme: IconThemeData(color: onSurface),
      ),
    );
  }

  // Gradient for primary buttons
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryContainer],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}