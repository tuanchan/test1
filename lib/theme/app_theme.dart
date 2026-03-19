import 'package:flutter/material.dart';

class AppColors {
  static const accent = Color(0xFFFF4A00);
  static const accentDim = Color(0x2EFF4A00);
  static const background = Color(0xFF0A0A0A);
  static const surface = Color(0xFF141414);
  static const elevated = Color(0xFF1B1B1B);
  static const border = Color(0x14FFFFFF);
  static const textPrimary = Color(0xFFF5F5F5);
  static const textSecondary = Color(0xFFA1A1AA);
  static const success = Color(0xFF22C55E);
  static const warningDue = Color(0xFFFF6B35);
}

class AppTextStyles {
  static const largeTitle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
    decoration: TextDecoration.none,
  );

  static const title1 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
    decoration: TextDecoration.none,
  );

  static const title2 = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.2,
    decoration: TextDecoration.none,
  );

  static const body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.4,
    decoration: TextDecoration.none,
  );

  static const bodySecondary = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.4,
    decoration: TextDecoration.none,
  );

  static const caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: 0.1,
    decoration: TextDecoration.none,
  );

  static const label = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    letterSpacing: 0.3,
    decoration: TextDecoration.none,
  );
}

ThemeData buildAppTheme() {
  const base = TextStyle(
    decoration: TextDecoration.none,
    decorationColor: Colors.transparent,
    fontFamily: 'System',
    color: AppColors.textPrimary,
  );

  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.accent,
      surface: AppColors.surface,
      background: AppColors.background,
    ),
    textTheme: TextTheme(
      displayLarge: base, displayMedium: base, displaySmall: base,
      headlineLarge: base, headlineMedium: base, headlineSmall: base,
      titleLarge: base, titleMedium: base, titleSmall: base,
      bodyLarge: base, bodyMedium: base, bodySmall: base,
      labelLarge: base, labelMedium: base, labelSmall: base,
    ),
  );
}
