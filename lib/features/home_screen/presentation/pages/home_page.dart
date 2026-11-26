import 'package:flutter/material.dart';

import '../../../../shared/formatters/portuguese_date_formatter.dart';
import '../../../../shared/widgets/cards/page_header_card.dart';
import '../../application/use_cases/get_daily_verse_use_case.dart';
import '../widgets/daily_verse_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    required this.getDailyVerseUseCase,
    required this.userName,
    super.key,
  });

  final GetDailyVerseUseCase getDailyVerseUseCase;
  final String userName;

  String get _firstName {
    final trimmedName = userName.trim();
    if (trimmedName.isEmpty) {
      return 'Visitante';
    }

    return trimmedName.split(RegExp(r'\s+')).first;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PageHeaderCard(
              eyebrow: PortugueseDateFormatter.format(DateTime.now()),
              title: 'Bom dia, $_firstName.',
              subtitle: 'Reserve um momento para a Palavra hoje.',
            ),
            const SizedBox(height: 24),
            DailyVerseCard(getDailyVerseUseCase: getDailyVerseUseCase),
          ],
        ),
      ),
    );
  }
}
