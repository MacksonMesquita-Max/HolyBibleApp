import 'package:flutter/material.dart';

import 'di/app_dependencies.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class VerbumApp extends StatelessWidget {
  const VerbumApp({super.key});

  static final AppDependencies _dependencies = AppDependencies.create();
  static final AppRouter _router = AppRouter(_dependencies);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Verbum - Bíblia Sagrada',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      initialRoute: AppRouter.loginRoute,
      onGenerateRoute: _router.onGenerateRoute,
    );
  }
}
