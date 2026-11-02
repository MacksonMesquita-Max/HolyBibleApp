import 'package:flutter/material.dart';

import 'presentation/widgets/verbum_navigation_bar.dart';

enum AppNavigationDestination { home, bible, harpa, library }

class AppNavigationBarModule {
  AppNavigationBarModule._();

  factory AppNavigationBarModule.create() => AppNavigationBarModule._();

  Widget buildNavigationBar({
    required AppNavigationDestination currentDestination,
    required ValueChanged<AppNavigationDestination> onDestinationSelected,
  }) {
    return VerbumNavigationBar(
      currentDestination: currentDestination,
      onDestinationSelected: onDestinationSelected,
    );
  }
}
