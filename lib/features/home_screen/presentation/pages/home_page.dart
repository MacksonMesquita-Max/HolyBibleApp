import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/constants/assets.dart';
import '../../../../app/router/app_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _signOut(BuildContext context) {
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRouter.loginRoute, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Verbum - Bíblia Sagrada')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(AppAssets.logo, width: 160, height: 160),
              const SizedBox(height: 24),
              Text(
                'Ambiente pronto para desenvolvimento.',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Esta tela agora pertence à feature home_screen e é exibida depois do login mockado.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => _signOut(context),
                icon: const Icon(Icons.logout),
                label: const Text('Sair do app'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
