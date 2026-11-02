import 'package:flutter/material.dart';

class SplashAnimationConstants {
  const SplashAnimationConstants._();

  static const Duration totalDuration = Duration(milliseconds: 4200);

  static const Interval logoOpacityInterval = Interval(
    0.0,
    0.22,
    curve: Curves.easeOut,
  );
  static const Interval logoScaleInterval = Interval(
    0.0,
    0.3,
    curve: Curves.easeOutBack,
  );
  static const Interval glowScaleInterval = Interval(
    0.05,
    0.55,
    curve: Curves.easeOut,
  );
  static const Interval titleOpacityInterval = Interval(
    0.18,
    0.42,
    curve: Curves.easeOut,
  );
  static const Interval titleOffsetInterval = Interval(
    0.18,
    0.44,
    curve: Curves.easeOutCubic,
  );
  static const Interval subtitleOpacityInterval = Interval(
    0.28,
    0.5,
    curve: Curves.easeOut,
  );
  static const Interval progressInterval = Interval(
    0.38,
    0.84,
    curve: Curves.easeInOut,
  );
  static const Interval fadeOutInterval = Interval(
    0.88,
    1.0,
    curve: Curves.easeIn,
  );

  static const double horizontalPadding = 24;
  static const double maxContentWidth = 320;
  static const double glowSize = 220;
  static const double logoContainerSize = 116;
  static const double logoContainerPadding = 18;
  static const double logoBorderRadius = 32;
  static const double progressWidth = 144;
  static const double progressHeight = 4;
  static const double titleSpacing = 28;
  static const double subtitleSpacing = 6;
  static const double progressSpacing = 32;
}
