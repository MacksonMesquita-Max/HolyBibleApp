import 'package:flutter/material.dart';

import '../../../../shared/widgets/cards/scripture_verse_card.dart';
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
    setState(() {
      _verseFuture = widget.getDailyVerseUseCase.execute();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DailyVerse>(
      future: _verseFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ScriptureVerseCard(
            label: 'Versículo do dia',
            isLoading: true,
          );
        }

        if (snapshot.hasError) {
          final error = snapshot.error;
          final message = error is DailyVerseException
              ? error.message
              : 'Não foi possível carregar o versículo.';

          return ScriptureVerseCard(
            label: 'Versículo do dia',
            errorMessage: message,
            onRetry: _reload,
          );
        }

        final verse = snapshot.data;
        if (verse == null) {
          return ScriptureVerseCard(
            label: 'Versículo do dia',
            errorMessage: 'Não foi possível carregar o versículo.',
            onRetry: _reload,
          );
        }

        return ScriptureVerseCard(
          label: 'Versículo do dia',
          text: verse.text,
          reference: verse.reference,
        );
      },
    );
  }
}
