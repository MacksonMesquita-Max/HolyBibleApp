import '../../features/app_navigation_bar/app_navigation_bar_module.dart';
import '../../features/authentication_screen/authentication_module.dart';
import '../../features/bible_screen/bible_screen_module.dart';
import '../../features/harpa_screen/harpa_screen_module.dart';
import '../../features/home_screen/home_screen_module.dart';
import '../../features/library_screen/library_screen_module.dart';
import '../../features/splash_screen/splash_module.dart';

class AppDependencies {
  AppDependencies._({
    required this.appNavigationBarModule,
    required this.authenticationModule,
    required this.splashModule,
    required this.bibleModule,
    required this.homeModule,
    required this.harpaModule,
    required this.libraryModule,
  });

  factory AppDependencies.create() {
    return AppDependencies._(
      appNavigationBarModule: AppNavigationBarModule.create(),
      authenticationModule: AuthenticationModule.create(),
      splashModule: SplashModule.create(),
      bibleModule: BibleScreenModule.create(),
      homeModule: HomeScreenModule.create(),
      harpaModule: HarpaScreenModule.create(),
      libraryModule: LibraryScreenModule.create(),
    );
  }

  final AppNavigationBarModule appNavigationBarModule;
  final AuthenticationModule authenticationModule;
  final SplashModule splashModule;
  final BibleScreenModule bibleModule;
  final HomeScreenModule homeModule;
  final HarpaScreenModule harpaModule;
  final LibraryScreenModule libraryModule;
}
