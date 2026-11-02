import '../../features/authentication/authentication_module.dart';
import '../../features/splash/splash_module.dart';

class AppDependencies {
  AppDependencies._({
    required this.authenticationModule,
    required this.splashModule,
  });

  factory AppDependencies.create() {
    return AppDependencies._(
      authenticationModule: AuthenticationModule.create(),
      splashModule: SplashModule.create(),
    );
  }

  final AuthenticationModule authenticationModule;
  final SplashModule splashModule;
}
