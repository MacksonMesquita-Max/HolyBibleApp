import 'package:flutter/material.dart';

/// Paleta de cores do aplicativo.
/// As telas devem consumir as cores por meio do tema
class AppColors {
  const AppColors._();

  // Marca.
  static const Color primary = Colors.brown;
  static const Color secondary = Color(0xFF8D6E63);

  // Feedback.
  static const Color success = Color(0xFF2E7D32);
  static const Color error = Color(0xFFC62828);
  static const Color info = Color(0xFF1565C0);

  // Neutras.
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color gray = Color(0xFF9E9E9E);
  static const Color grayLight = Color(0xFFF5F5F5);
  static const Color grayDark = Color(0xFF616161);

  // Paletas de tema (superficie e texto).
  static const AppLightPalette light = AppLightPalette();
  static const AppDarkPalette dark = AppDarkPalette();
}

abstract class AppPalette {
  Color get background;
  Color get surface;
  Color get surfaceVariant;
  Color get border;
  Color get textPrimary;
  Color get textSecondary;
}

class AppLightPalette implements AppPalette {
  const AppLightPalette();

  @override
  final Color background = const Color(0xFFF8F5F2);
  @override
  final Color surface = AppColors.white;
  @override
  final Color surfaceVariant = const Color(0xFFF1E8E1);
  @override
  final Color border = const Color(0xFFD9CBC0);
  @override
  final Color textPrimary = AppColors.black;
  @override
  final Color textSecondary = const Color(0xFF6E5C53);
}

class AppDarkPalette implements AppPalette {
  const AppDarkPalette();

  @override
  final Color background = const Color(0xFF121212);
  @override
  final Color surface = const Color(0xFF1E1E1E);
  @override
  final Color surfaceVariant = const Color(0xFF2A2A2A);
  @override
  final Color border = const Color(0xFF2C2C2C);
  @override
  final Color textPrimary = const Color(0xFFF5F5F5);
  @override
  final Color textSecondary = const Color(0xFFBDBDBD);
}
