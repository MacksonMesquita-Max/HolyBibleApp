import '../../features/authentication_screen/authentication_module.dart';
import '../../features/bible_screen/bible_screen_module.dart';
import '../../features/home_screen/home_screen_module.dart';
import '../../features/splash_screen/splash_module.dart';

class AppDependencies {
  AppDependencies._({
    required this.authenticationModule,
    required this.splashModule,
    required this.bibleModule,
    required this.homeModule,
  });

  factory AppDependencies.create() {
    return AppDependencies._(
      authenticationModule: AuthenticationModule.create(),
      splashModule: SplashModule.create(),
      bibleModule: BibleScreenModule.create(),
      homeModule: HomeScreenModule.create(),
    );
  }

  final AuthenticationModule authenticationModule;
  final SplashModule splashModule;
  final BibleScreenModule bibleModule;
  final HomeScreenModule homeModule;
}
