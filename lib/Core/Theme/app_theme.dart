import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      colorScheme: const ColorScheme.light(
        primary: AppColors.forestGreen,
        onPrimary: Colors.white,
        secondary: AppColors.softMint,
        onSecondary: AppColors.forestGreen,
        surface: AppColors.lightSurface,
        onSurface: AppColors.lightText,
        error: Color(0xFFBA3939),
      ),

      scaffoldBackgroundColor: AppColors.lightBackground,

      dividerColor: AppColors.stone,

      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: AppColors.lightText,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.lightText,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.lightText,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: AppColors.lightText),
        bodyMedium: TextStyle(fontSize: 14, color: AppColors.lightText),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      colorScheme: const ColorScheme.dark(
        primary: AppColors.softMint,
        onPrimary: AppColors.forestGreen,
        secondary: AppColors.mutedGreen,
        onSecondary: AppColors.darkBackground,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkText,
        error: Color(0xFFFF7777),
      ),

      scaffoldBackgroundColor: AppColors.darkBackground,

      dividerColor: AppColors.deepSage,

      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: AppColors.darkText,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.darkText,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.darkText,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: AppColors.darkText),
        bodyMedium: TextStyle(fontSize: 14, color: AppColors.darkText),
      ),
    );
  }
}
