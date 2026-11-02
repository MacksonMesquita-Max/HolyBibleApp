import 'package:flutter/material.dart';

import '../../app_navigation_bar_module.dart';

class VerbumNavigationBar extends StatelessWidget {
  const VerbumNavigationBar({
    required this.currentDestination,
    required this.onDestinationSelected,
    super.key,
  });

  final AppNavigationDestination currentDestination;
  final ValueChanged<AppNavigationDestination> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: AppNavigationDestination.values.indexOf(
        currentDestination,
      ),
      onDestinationSelected: (index) {
        onDestinationSelected(AppNavigationDestination.values[index]);
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Inicio',
        ),
        NavigationDestination(
          icon: Icon(Icons.menu_book_outlined),
          selectedIcon: Icon(Icons.menu_book),
          label: 'Biblia',
        ),
        NavigationDestination(
          icon: Icon(Icons.library_music_outlined),
          selectedIcon: Icon(Icons.library_music),
          label: 'Harpa Crista',
        ),
        NavigationDestination(
          icon: Icon(Icons.local_library_outlined),
          selectedIcon: Icon(Icons.local_library),
          label: 'Biblioteca',
        ),
      ],
    );
  }
}
