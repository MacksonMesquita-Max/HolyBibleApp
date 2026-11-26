import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../shared/widgets/buttons/icon_action_button.dart';
import '../../application/use_cases/get_random_hymn_use_case.dart';
import '../../domain/entities/random_hymn.dart';

class HymnSuggestionCard extends StatefulWidget {
  const HymnSuggestionCard({required this.getRandomHymnUseCase, super.key});

  final GetRandomHymnUseCase getRandomHymnUseCase;

  @override
  State<HymnSuggestionCard> createState() => _HymnSuggestionCardState();
}

class _HymnSuggestionCardState extends State<HymnSuggestionCard> {
  late Future<RandomHymn> _hymnFuture;

  @override
  void initState() {
    super.initState();
    _hymnFuture = widget.getRandomHymnUseCase.execute();
  }

  void _reload() {
    setState(() {
      _hymnFuture = widget.getRandomHymnUseCase.execute();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.brightness == Brightness.light
        ? AppColors.light.surfaceVariant
        : AppColors.dark.surfaceVariant;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'LOUVE AO SENHOR',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                'Hinos para você',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontFamily: 'serif',
                  fontSize: 23,
                  fontWeight: FontWeight.w500,
                  height: 1.15,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Ver todos',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 17,
                  color: theme.colorScheme.onSurface,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: FutureBuilder<RandomHymn>(
            future: _hymnFuture,
            builder: (context, snapshot) {
              final isLoading =
                  snapshot.connectionState == ConnectionState.waiting;
              final hymn = snapshot.data;
              final hasError =
                  snapshot.hasError || (!isLoading && hymn == null);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface.withValues(alpha: 0.7),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.wb_sunny_outlined,
                      size: 20,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '7 DIAS',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (isLoading)
                    Row(
                      children: [
                        SizedBox(
                          width: 15,
                          height: 15,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Buscando um hino...',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontFamily: 'serif',
                          ),
                        ),
                      ],
                    )
                  else if (hasError)
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Não foi possível carregar o hino.',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontFamily: 'serif',
                            ),
                          ),
                        ),
                        IconActionButton(
                          icon: Icons.refresh_rounded,
                          tooltip: 'Tentar novamente',
                          onPressed: _reload,
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    )
                  else
                    Text(
                      hymn!.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontFamily: 'serif',
                        fontWeight: FontWeight.w400,
                        height: 1.2,
                      ),
                    ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.music_note_rounded,
                        size: 15,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Harpa Cristã · Hino aleatório',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Ouvir',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurface,
                          decoration: TextDecoration.underline,
                          decorationThickness: 1.2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
