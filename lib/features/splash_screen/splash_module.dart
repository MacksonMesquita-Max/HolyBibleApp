import 'package:flutter/widgets.dart';
import 'presentation/pages/splash_page.dart';

class SplashModule {
  SplashModule._();

  factory SplashModule.create() => SplashModule._();

  Widget buildSplashPage({
    required void Function(BuildContext context) onCompleted,
  }) {
    return SplashPage(onCompleted: onCompleted);
  }
}
