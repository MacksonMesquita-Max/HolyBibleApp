import 'package:flutter/material.dart';

import 'theme/app_theme.dart';

/// Widget raiz da aplicacao.
///
/// Concentra a configuracao global (tema e rota inicial). As telas reais
/// devem ser implementadas dentro de `features/`.
class HolyBibleApp extends StatelessWidget {
  const HolyBibleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bíblia Sagrada',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const _PlaceholderPage(),
    );
  }
}

/// Tela temporaria exibida enquanto as features nao sao implementadas.
class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bíblia Sagrada')),
      body: const Center(
        child: Text('Ambiente pronto para desenvolvimento.'),
      ),
    );
  }
}
