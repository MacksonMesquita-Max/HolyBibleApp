import 'package:flutter/material.dart';

import 'router/app_router.dart';
import 'theme/app_theme.dart';

class VerbumApp extends StatelessWidget {
  const VerbumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Verbum - Bíblia Sagrada',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRouter.loginRoute,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
