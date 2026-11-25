import 'package:flutter/material.dart';

import '../../../../app/router/app_router.dart';
import '../../application/use_cases/get_daily_verse_use_case.dart';
import '../widgets/daily_verse_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({required this.getDailyVerseUseCase, super.key});

  final GetDailyVerseUseCase getDailyVerseUseCase;

  void _signOut(BuildContext context) {
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRouter.loginRoute, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DailyVerseCard(getDailyVerseUseCase: getDailyVerseUseCase),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => _signOut(context),
              icon: const Icon(Icons.logout),
              label: const Text('Sair do app'),
            ),
          ],
        ),
      ),
    );
  }
}
