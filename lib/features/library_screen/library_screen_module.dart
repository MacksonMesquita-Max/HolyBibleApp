import 'package:flutter/widgets.dart';

import 'presentation/pages/library_page.dart';

class LibraryScreenModule {
  LibraryScreenModule._();

  factory LibraryScreenModule.create() => LibraryScreenModule._();

  LibraryPage buildLibraryPage({required Widget bottomNavigationBar}) {
    return LibraryPage(bottomNavigationBar: bottomNavigationBar);
  }
}
