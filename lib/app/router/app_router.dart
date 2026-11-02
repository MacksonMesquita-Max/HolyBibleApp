import 'package:flutter/material.dart';

import '../di/app_dependencies.dart';
import '../../features/home_screen/presentation/pages/home_page.dart';

class AppRouter {
  AppRouter(this._dependencies);

  final AppDependencies _dependencies;

  static const String splashRoute = '/';
  static const String loginRoute = '/login';
  static const String homeRoute = '/home';

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashRoute:
        return MaterialPageRoute<void>(
          builder: (_) => _dependencies.splashModule.buildSplashPage(
            onCompleted: (context) {
              Navigator.of(context).pushReplacementNamed(loginRoute);
            },
          ),
          settings: settings,
        );
      case homeRoute:
        return MaterialPageRoute<void>(
          builder: (_) => const HomePage(),
          settings: settings,
        );
      case loginRoute:
      default:
        return MaterialPageRoute<void>(
          builder: (_) => _dependencies.authenticationModule.buildLoginPage(),
          settings: settings,
        );
    }
  }
}
