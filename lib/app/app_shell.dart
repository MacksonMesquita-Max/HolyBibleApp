import 'package:flutter/material.dart';

import 'constants/assets.dart';
import '../../shared/widgets/verbum_top_bar.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    required this.body,
    required this.bottomNavigationBar,
    super.key,
  });

  final Widget body;
  final Widget bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VerbumTopBar(logoAsset: AppAssets.logo),
      body: body,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
