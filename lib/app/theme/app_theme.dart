import 'package:flutter/material.dart';

/// Tema visual padrao da aplicacao.
class AppTheme {
  const AppTheme._();

  /// Cor semente usada para gerar o esquema de cores.
  static const Color seedColor = Colors.brown;

  /// Tema claro da aplicacao.
  static ThemeData get light => ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
      );
}
