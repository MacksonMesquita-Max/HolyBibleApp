import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'constants/assets.dart';
import 'theme/app_theme.dart';

/// Widget raiz da aplicacao: define tema e rota inicial.
class VerbumApp extends StatelessWidget {
  const VerbumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Verbum - Bíblia Sagrada',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const _PlaceholderPage(),
    );
  }
}

/// Tela temporaria exibida enquanto as telas reais nao existem em `features/`.
class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verbum - Bíblia Sagrada')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(AppAssets.logo, width: 160, height: 160),
            const SizedBox(height: 24),
            const Text('Ambiente pronto para desenvolvimento.'),
          ],
        ),
      ),
    );
  }
}
