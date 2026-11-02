import 'package:flutter/material.dart';

import '../../features/app_navigation_bar/app_navigation_bar_module.dart';
import '../di/app_dependencies.dart';

class AppRouter {
  AppRouter(this._dependencies);

  final AppDependencies _dependencies;

  static const String splashRoute = '/';
  static const String loginRoute = '/login';
  static const String homeRoute = '/home';
  static const String bibleRoute = '/bible';
  static const String harpaRoute = '/harpa';
  static const String libraryRoute = '/library';

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
          builder: (context) => _dependencies.homeModule.buildHomePage(
            bottomNavigationBar: _buildBottomNavigationBar(
              context,
              AppNavigationDestination.home,
            ),
          ),
          settings: settings,
        );
      case bibleRoute:
        return MaterialPageRoute<void>(
          builder: (context) => _dependencies.bibleModule.buildBiblePage(
            bottomNavigationBar: _buildBottomNavigationBar(
              context,
              AppNavigationDestination.bible,
            ),
          ),
          settings: settings,
        );
      case harpaRoute:
        return MaterialPageRoute<void>(
          builder: (context) => _dependencies.harpaModule.buildHarpaPage(
            bottomNavigationBar: _buildBottomNavigationBar(
              context,
              AppNavigationDestination.harpa,
            ),
          ),
          settings: settings,
        );
      case libraryRoute:
        return MaterialPageRoute<void>(
          builder: (context) => _dependencies.libraryModule.buildLibraryPage(
            bottomNavigationBar: _buildBottomNavigationBar(
              context,
              AppNavigationDestination.library,
            ),
          ),
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

  Widget _buildBottomNavigationBar(
    BuildContext context,
    AppNavigationDestination currentDestination,
  ) {
    return _dependencies.appNavigationBarModule.buildNavigationBar(
      currentDestination: currentDestination,
      onDestinationSelected: (destination) {
        if (destination == currentDestination) {
          return;
        }

        Navigator.of(
          context,
        ).pushReplacementNamed(_routeForDestination(destination));
      },
    );
  }

  String _routeForDestination(AppNavigationDestination destination) {
    switch (destination) {
      case AppNavigationDestination.home:
        return homeRoute;
      case AppNavigationDestination.bible:
        return bibleRoute;
      case AppNavigationDestination.harpa:
        return harpaRoute;
      case AppNavigationDestination.library:
        return libraryRoute;
    }
  }
}
