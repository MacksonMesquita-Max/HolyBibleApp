import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';

class ScriptureVerseCard extends StatelessWidget {
  const ScriptureVerseCard({
    required this.label,
    this.text,
    this.reference,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
    this.onBookmark,
    this.onShare,
    this.isBookmarked = false,
    super.key,
  });

  final String label;
  final String? text;
  final String? reference;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final VoidCallback? onBookmark;
  final VoidCallback? onShare;
  final bool isBookmarked;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardRadius = BorderRadius.circular(24);

    return Container(
      decoration: BoxDecoration(
        borderRadius: cardRadius,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.verseCardStart, AppColors.verseCardEnd],
        ),
      ),
      child: ClipRRect(
        borderRadius: cardRadius,
        child: Stack(
          children: [
            Positioned(
              top: -38,
              right: -28,
              child: Transform.rotate(
                angle: -0.22,
                child: Icon(
                  Icons.auto_stories_rounded,
                  size: 208,
                  color: AppColors.verseCardForeground.withValues(alpha: 0.055),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        size: 16,
                        color: AppColors.verseCardMuted,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          label.toUpperCase(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppColors.verseCardMuted,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.3,
                          ),
                        ),
                      ),
                      _buildActionButton(
                        icon: isBookmarked
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_border_rounded,
                        tooltip: isBookmarked
                            ? 'Remover dos salvos'
                            : 'Salvar versículo',
                        onPressed: onBookmark,
                      ),
                      const SizedBox(width: 6),
                      _buildActionButton(
                        icon: Icons.share_outlined,
                        tooltip: 'Compartilhar versículo',
                        onPressed: onShare,
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  if (isLoading)
                    const SizedBox(
                      height: 142,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.verseCardForeground,
                        ),
                      ),
                    )
                  else if (errorMessage != null)
                    _buildError(theme)
                  else if (text != null && reference != null)
                    _buildVerse(theme, text!, reference!)
                  else
                    const SizedBox(height: 142),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerse(ThemeData theme, String verseText, String verseReference) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '“${verseText.trim()}”',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: AppColors.verseCardForeground,
            fontFamily: 'serif',
            fontWeight: FontWeight.w400,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Text(
              verseReference.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppColors.verseCardMuted,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 38,
              height: 1,
              color: AppColors.verseCardForeground.withValues(alpha: 0.28),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildError(ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          errorMessage!,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.verseCardForeground,
          ),
        ),
        if (onRetry != null) ...[
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Tentar novamente'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.verseCardForeground,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback? onPressed,
  }) {
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: Icon(icon, size: 20),
      style: IconButton.styleFrom(
        minimumSize: const Size(42, 42),
        padding: EdgeInsets.zero,
        foregroundColor: AppColors.verseCardForeground.withValues(alpha: 0.9),
        disabledForegroundColor: AppColors.verseCardForeground.withValues(
          alpha: 0.58,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: AppColors.verseCardForeground.withValues(alpha: 0.2),
          ),
        ),
      ),
    );
  }
}
