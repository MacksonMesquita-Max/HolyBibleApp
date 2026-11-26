import 'package:flutter/material.dart';

import 'constants/assets.dart';
import '../../shared/widgets/verbum_top_bar.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    required this.body,
    required this.bottomNavigationBar,
    required this.onSearch,
    super.key,
  });

  final Widget body;
  final Widget bottomNavigationBar;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: VerbumTopBar(logoAsset: AppAssets.logo, onSearch: onSearch),
      body: body,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
