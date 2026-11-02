import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../app/constants/assets.dart';
import '../../../../app/theme/app_colors.dart';
import '../constants/splash_animation_constants.dart';

class SplashLogoBlock extends StatelessWidget {
  const SplashLogoBlock({
    required this.logoOpacity,
    required this.logoScale,
    required this.glowScale,
    required this.titleOpacity,
    required this.titleOffset,
    required this.subtitleOpacity,
    required this.progress,
    super.key,
  });

  final Animation<double> logoOpacity;
  final Animation<double> logoScale;
  final Animation<double> glowScale;
  final Animation<double> titleOpacity;
  final Animation<Offset> titleOffset;
  final Animation<double> subtitleOpacity;
  final Animation<double> progress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Transform.scale(
          scale: glowScale.value,
          child: Container(
            width: SplashAnimationConstants.glowSize,
            height: SplashAnimationConstants.glowSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.08),
              border: Border.all(
                color: AppColors.secondary.withValues(alpha: 0.18),
              ),
            ),
            child: Center(
              child: FadeTransition(
                opacity: logoOpacity,
                child: ScaleTransition(
                  scale: logoScale,
                  child: Container(
                    width: SplashAnimationConstants.logoContainerSize,
                    height: SplashAnimationConstants.logoContainerSize,
                    padding: const EdgeInsets.all(
                      SplashAnimationConstants.logoContainerPadding,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.light.surfaceVariant,
                      borderRadius: BorderRadius.circular(
                        SplashAnimationConstants.logoBorderRadius,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: 0.22),
                          blurRadius: 28,
                          offset: const Offset(0, 14),
                        ),
                      ],
                    ),
                    child: SvgPicture.asset(AppAssets.logo),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: SplashAnimationConstants.titleSpacing),
        FadeTransition(
          opacity: titleOpacity,
          child: SlideTransition(
            position: titleOffset,
            child: Text(
              'Verbum',
              style: theme.textTheme.displaySmall?.copyWith(
                color: AppColors.dark.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: SplashAnimationConstants.subtitleSpacing),
        FadeTransition(
          opacity: subtitleOpacity,
          child: Text(
            'BÍBLIA SAGRADA',
            style: theme.textTheme.labelMedium?.copyWith(
              color: AppColors.dark.textSecondary,
              letterSpacing: 4,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: SplashAnimationConstants.progressSpacing),
        Opacity(
          opacity: subtitleOpacity.value,
          child: SizedBox(
            width: SplashAnimationConstants.progressWidth,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: progress.value,
                minHeight: SplashAnimationConstants.progressHeight,
                backgroundColor: AppColors.white.withValues(alpha: 0.08),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.secondary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
