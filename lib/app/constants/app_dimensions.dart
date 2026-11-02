import 'package:flutter/widgets.dart';

import 'app_responsive.dart';

/// Tokens genéricos de dimensão e espaçamento, resolvidos por tamanho de tela.
class AppDimensions {
  const AppDimensions({
    required this.contentMaxWidth,
    required this.screenPadding,
    required this.cardPadding,
    required this.cardRadius,
    required this.brandMarkSize,
    required this.actionHeight,
    required this.sectionSpacing,
    required this.headingSpacing,
    required this.fieldPadding,
  });

  factory AppDimensions.of(BuildContext context) {
    final fieldPaddingValue = context.responsive<double>(
      mobile: 18,
      tablet: 20,
      desktop: 22,
    );

    return AppDimensions(
      contentMaxWidth: context.responsive<double>(
        mobile: double.infinity,
        tablet: 460,
        desktop: 520,
      ),
      screenPadding: context.responsive<double>(
        mobile: 24,
        tablet: 32,
        desktop: 40,
      ),
      cardPadding: context.responsive<double>(
        mobile: 28,
        tablet: 32,
        desktop: 36,
      ),
      cardRadius: context.responsive<double>(
        mobile: 28,
        tablet: 32,
        desktop: 36,
      ),
      brandMarkSize: context.responsive<double>(
        mobile: 86,
        tablet: 94,
        desktop: 104,
      ),
      actionHeight: context.responsive<double>(
        mobile: 56,
        tablet: 60,
        desktop: 62,
      ),
      sectionSpacing: context.responsive<double>(
        mobile: 20,
        tablet: 22,
        desktop: 24,
      ),
      headingSpacing: context.responsive<double>(
        mobile: 28,
        tablet: 30,
        desktop: 32,
      ),
      fieldPadding: EdgeInsets.symmetric(
        horizontal: fieldPaddingValue,
        vertical: fieldPaddingValue,
      ),
    );
  }

  final double contentMaxWidth;
  final double screenPadding;
  final double cardPadding;
  final double cardRadius;
  final double brandMarkSize;
  final double actionHeight;
  final double sectionSpacing;
  final double headingSpacing;
  final EdgeInsets fieldPadding;
}
