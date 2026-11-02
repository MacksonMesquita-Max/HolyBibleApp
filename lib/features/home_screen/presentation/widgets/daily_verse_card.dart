import 'package:flutter/material.dart';

import '../../application/use_cases/get_daily_verse_use_case.dart';
import '../../domain/entities/daily_verse.dart';
import '../../domain/exceptions/daily_verse_exception.dart';

class DailyVerseCard extends StatefulWidget {
  const DailyVerseCard({required this.getDailyVerseUseCase, super.key});

  final GetDailyVerseUseCase getDailyVerseUseCase;

  @override
  State<DailyVerseCard> createState() => _DailyVerseCardState();
}

class _DailyVerseCardState extends State<DailyVerseCard> {
  late Future<DailyVerse> _verseFuture;

  @override
  void initState() {
    super.initState();
    _verseFuture = widget.getDailyVerseUseCase.execute();
  }

  void _reload() {
    setState(() => _verseFuture = widget.getDailyVerseUseCase.execute());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder<DailyVerse>(
          future: _verseFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 160,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (snapshot.hasError) {
              return _buildError(theme, snapshot.error);
            }

            return _buildVerse(theme, snapshot.data!);
          },
        ),
      ),
    );
  }

  Widget _buildError(ThemeData theme, Object? error) {
    final message = error is DailyVerseException
        ? error.message
        : 'Não foi possível carregar o versículo.';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.cloud_off, color: theme.colorScheme.error),
        const SizedBox(height: 12),
        Text(message, textAlign: TextAlign.center),
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: _reload,
          icon: const Icon(Icons.refresh),
          label: const Text('Tentar novamente'),
        ),
      ],
    );
  }

  Widget _buildVerse(ThemeData theme, DailyVerse verse) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(
              Icons.auto_stories_outlined,
              size: 20,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Versículo do dia',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: _reload,
              icon: const Icon(Icons.refresh),
              tooltip: 'Mostrar outro versículo',
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          verse.text,
          style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
        ),
        const SizedBox(height: 12),
        Text(
          verse.reference,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.primary,
          ),
        ),
        Text(
          verse.translationName,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
