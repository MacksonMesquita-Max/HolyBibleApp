import 'package:flutter/material.dart';

import '../../../../shared/formatters/portuguese_date_formatter.dart';
import '../../../../shared/widgets/cards/page_header_card.dart';
import '../../application/use_cases/get_daily_verse_use_case.dart';
import '../../application/use_cases/get_random_hymn_use_case.dart';
import '../widgets/daily_verse_card.dart';
import '../widgets/hymn_suggestion_card.dart';
import '../widgets/reading_progress_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    required this.getDailyVerseUseCase,
    required this.getRandomHymnUseCase,
    required this.userName,
    super.key,
  });

  final GetDailyVerseUseCase getDailyVerseUseCase;
  final GetRandomHymnUseCase getRandomHymnUseCase;
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
    final theme = Theme.of(context);

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
            const SizedBox(height: 32),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SUA JORNADA',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Continue de onde parou',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontFamily: 'serif',
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          height: 1.15,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Semantics(
                  button: true,
                  enabled: false,
                  label: 'Abrir Bíblia',
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 2,
                        vertical: 4,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Abrir Bíblia',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 17,
                            color: theme.colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const ReadingProgressCard(
              testamentName: 'Novo Testamento',
              bookName: 'João',
              readingReference: 'João 1',
              excerpt: 'No princípio era o Verbo, e o Verbo estava com Deus...',
              completedVerses: 12,
              totalVerses: 51,
            ),
            const SizedBox(height: 32),
            HymnSuggestionCard(getRandomHymnUseCase: getRandomHymnUseCase),
          ],
        ),
      ),
    );
  }
}
