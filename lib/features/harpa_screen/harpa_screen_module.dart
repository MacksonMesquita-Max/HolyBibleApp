import 'package:flutter/widgets.dart';

import 'presentation/pages/harpa_page.dart';

class HarpaScreenModule {
  HarpaScreenModule._();

  factory HarpaScreenModule.create() => HarpaScreenModule._();

  HarpaPage buildHarpaPage({required Widget bottomNavigationBar}) {
    return HarpaPage(bottomNavigationBar: bottomNavigationBar);
  }
}
