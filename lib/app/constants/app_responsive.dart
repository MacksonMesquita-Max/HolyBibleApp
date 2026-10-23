import 'package:flutter/widgets.dart';


/// `mobile`: menor que 600 | `tablet`: 600 a 1023 | `desktop`: 1024 ou mais.
class AppResponsive {
  const AppResponsive._();

  static const double tabletBreakpoint = 600;
  static const double desktopBreakpoint = 1024;
}

extension AppResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;

  bool get isMobile => screenWidth < AppResponsive.tabletBreakpoint;

  bool get isTablet =>
      screenWidth >= AppResponsive.tabletBreakpoint &&
      screenWidth < AppResponsive.desktopBreakpoint;

  bool get isDesktop => screenWidth >= AppResponsive.desktopBreakpoint;

  /// Escolhe um valor conforme o tamanho da tela atual.
  T responsive<T>({required T mobile, T? tablet, T? desktop}) {
    if (isDesktop) return desktop ?? tablet ?? mobile;
    if (isTablet) return tablet ?? mobile;
    return mobile;
  }
}
