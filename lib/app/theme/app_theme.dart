import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get light =>
      _buildTheme(brightness: Brightness.light, palette: AppColors.light);

  static ThemeData get dark =>
      _buildTheme(brightness: Brightness.dark, palette: AppColors.dark);

  static ThemeData _buildTheme({
    required Brightness brightness,
    required AppPalette palette,
  }) {
    final baseScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: brightness,
    );

    final colorScheme = baseScheme.copyWith(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      error: AppColors.error,
      surface: palette.surface,
      onSurface: palette.textPrimary,
      onSurfaceVariant: palette.textSecondary,
      outline: palette.border,
      outlineVariant: palette.border,
      shadow: AppColors.black,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: palette.background,
      cardColor: palette.surface,
      shadowColor: AppColors.black,
      textTheme: AppTextStyles.base.apply(
        bodyColor: palette.textPrimary,
        displayColor: palette.textPrimary,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.error),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.onSurface,
        contentTextStyle: TextStyle(color: colorScheme.surface),
      ),
    );
  }
}
