import 'package:flutter/material.dart';

import '../../../../app/router/app_router.dart';
import '../../../../shared/widgets/buttons/secondary_button.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  void _signOut(BuildContext context) {
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRouter.loginRoute, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.local_library_outlined,
                size: 72,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Biblioteca',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Essa tela ja esta preparada para receber os materiais salvos e futuras colecoes do app.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              SecondaryButton(
                label: 'Sair do app',
                icon: Icons.logout,
                expand: true,
                onPressed: () => _signOut(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
