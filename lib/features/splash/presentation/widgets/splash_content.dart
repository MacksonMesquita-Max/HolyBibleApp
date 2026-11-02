import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../constants/splash_animation_constants.dart';
import 'splash_logo_block.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({
    required this.controller,
    super.key,
  });

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    final logoOpacity = CurvedAnimation(
      parent: controller,
      curve: SplashAnimationConstants.logoOpacityInterval,
    );
    final logoScale = Tween<double>(begin: 0.82, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: SplashAnimationConstants.logoScaleInterval,
      ),
    );
    final glowScale = Tween<double>(begin: 0.88, end: 1.12).animate(
      CurvedAnimation(
        parent: controller,
        curve: SplashAnimationConstants.glowScaleInterval,
      ),
    );
    final titleOpacity = CurvedAnimation(
      parent: controller,
      curve: SplashAnimationConstants.titleOpacityInterval,
    );
    final titleOffset = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: SplashAnimationConstants.titleOffsetInterval,
      ),
    );
    final subtitleOpacity = CurvedAnimation(
      parent: controller,
      curve: SplashAnimationConstants.subtitleOpacityInterval,
    );
    final progress = CurvedAnimation(
      parent: controller,
      curve: SplashAnimationConstants.progressInterval,
    );
    final contentFadeOut = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: controller,
        curve: SplashAnimationConstants.fadeOutInterval,
      ),
    );

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Opacity(
          opacity: contentFadeOut.value,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -0.1),
                radius: 0.95,
                colors: [
                  AppColors.dark.surface,
                  AppColors.dark.background,
                ],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SplashAnimationConstants.horizontalPadding,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: SplashAnimationConstants.maxContentWidth,
                    ),
                    child: SplashLogoBlock(
                      logoOpacity: logoOpacity,
                      logoScale: logoScale,
                      glowScale: glowScale,
                      titleOpacity: titleOpacity,
                      titleOffset: titleOffset,
                      subtitleOpacity: subtitleOpacity,
                      progress: progress,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
