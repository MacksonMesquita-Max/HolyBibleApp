import 'package:flutter/material.dart';

import '../../features/authentication/data/repositories/mock_authentication_repository.dart';
import '../../features/authentication/presentation/pages/login_page.dart';
import '../../features/home_screen/presentation/pages/home_page.dart';

class AppRouter {
  const AppRouter._();

  static const String loginRoute = '/';
  static const String homeRoute = '/home';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute<void>(
          builder: (_) => const HomePage(),
          settings: settings,
        );
      case loginRoute:
      default:
        return MaterialPageRoute<void>(
          builder: (_) => LoginPage(
            authenticationRepository: MockAuthenticationRepository(),
          ),
          settings: settings,
        );
    }
  }
}
