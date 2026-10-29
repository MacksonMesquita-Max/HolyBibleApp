import '../../features/authentication/authentication_module.dart';

class AppDependencies {
  AppDependencies._({required this.authenticationModule});

  factory AppDependencies.create() {
    return AppDependencies._(
      authenticationModule: AuthenticationModule.create(),
    );
  }

  final AuthenticationModule authenticationModule;
}
