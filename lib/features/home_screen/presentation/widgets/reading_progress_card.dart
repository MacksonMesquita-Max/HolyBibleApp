import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

class ReadingProgressCard extends StatelessWidget {
  const ReadingProgressCard({
    required this.testamentName,
    required this.bookName,
    required this.readingReference,
    required this.excerpt,
    required this.completedVerses,
    required this.totalVerses,
    super.key,
  });

  final String testamentName;
  final String bookName;
  final String readingReference;
  final String excerpt;
  final int completedVerses;
  final int totalVerses;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final safeTotal = totalVerses < 0 ? 0 : totalVerses;
    final safeCompleted = completedVerses.clamp(0, safeTotal);
    final progress = safeTotal == 0 ? 0.0 : safeCompleted / safeTotal;
    final percentage = (progress * 100).floor();

    return Card(
      margin: EdgeInsets.zero,
      color: theme.colorScheme.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.65),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _BookCover(testamentName: testamentName, bookName: bookName),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ÚLTIMA LEITURA',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    readingReference,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontFamily: 'serif',
                      fontWeight: FontWeight.w500,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    excerpt,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontFamily: 'serif',
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 4,
                      color: AppColors.verseCardStart,
                      backgroundColor: theme.colorScheme.outlineVariant
                          .withValues(alpha: 0.35),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '$safeCompleted de $safeTotal versículos',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$percentage%',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookCover extends StatelessWidget {
  const _BookCover({required this.testamentName, required this.bookName});

  final String testamentName;
  final String bookName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 82,
      height: 148,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.16),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            testamentName.toUpperCase(),
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontSize: 8,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              height: 1.2,
            ),
          ),
          Icon(
            Icons.menu_book_outlined,
            size: 28,
            color: theme.colorScheme.onPrimary.withValues(alpha: 0.85),
          ),
          Text(
            bookName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontFamily: 'serif',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
