import 'package:flutter/material.dart';

import '../../application/use_cases/get_hymn_by_number_use_case.dart';
import '../../domain/entities/hymn.dart';
import '../../domain/exceptions/harpa_api_exception.dart';

class HarpaPage extends StatefulWidget {
  const HarpaPage({
    required this.getHymnByNumberUseCase,
    this.initialHymnNumber,
    super.key,
  });

  final GetHymnByNumberUseCase getHymnByNumberUseCase;
  final int? initialHymnNumber;

  @override
  State<HarpaPage> createState() => _HarpaPageState();
}

class _HarpaPageState extends State<HarpaPage> {
  late final Future<Hymn>? _hymnFuture;

  @override
  void initState() {
    super.initState();
    final hymnNumber = widget.initialHymnNumber;
    _hymnFuture = hymnNumber == null
        ? null
        : widget.getHymnByNumberUseCase.execute(hymnNumber);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hymnFuture = _hymnFuture;

    if (hymnFuture == null) {
      return SafeArea(child: _buildEmptyState(theme));
    }

    return SafeArea(
      child: FutureBuilder<Hymn>(
        future: hymnFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            final error = snapshot.error;
            final message = error is HarpaApiException
                ? error.message
                : 'Não foi possível carregar este hino.';
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
            );
          }

          final hymn = snapshot.data;
          if (hymn == null) {
            return _buildEmptyState(theme);
          }

          return _buildHymn(theme, hymn);
        },
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.library_music_outlined,
              size: 72,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Harpa Cristã',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Pesquise um hino para abrir sua letra aqui.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHymn(ThemeData theme, Hymn hymn) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'HINO ${hymn.number}',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hymn.title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontFamily: 'serif',
              fontWeight: FontWeight.w600,
            ),
          ),
          if (hymn.author.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              hymn.author,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: 24),
          for (final verse in hymn.verses) ...[
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (verse.isChorus)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          'CORO',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    Text(
                      verse.lyrics,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        height: 1.6,
                        fontFamily: 'serif',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
