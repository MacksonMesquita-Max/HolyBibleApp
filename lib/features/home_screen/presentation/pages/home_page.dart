import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/constants/assets.dart';
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
    return Scaffold(
      appBar: AppBar(title: const Text('Verbum - Bíblia Sagrada')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SvgPicture.asset(AppAssets.logo, width: 160, height: 160),
              const SizedBox(height: 24),
              DailyVerseCard(getDailyVerseUseCase: getDailyVerseUseCase),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRouter.bibleRoute),
                icon: const Icon(Icons.menu_book_outlined),
                label: const Text('Abrir a Bíblia'),
              ),
              const SizedBox(height: 12),
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
