class BibleApiEndpoints {
  const BibleApiEndpoints._();

  static const String baseUrl = 'https://bible-api.com';

  static const String defaultTranslation = 'kjv';

  static String passage(String reference) {
    final normalized = reference.trim().replaceAll(RegExp(r'\s+'), '+');
    return '/$normalized';
  }

  static String translations() {
    return '/data';
  }

  static String books(String translation) {
    return '/data/$translation';
  }

  static String chapters({required String translation, required String bookId}) {
    return '/data/$translation/$bookId';
  }

  static String verses({
    required String translation,
    required String bookId,
    required int chapter,
  }) {
    return '/data/$translation/$bookId/$chapter';
  }

  static String randomVerse(
    String translation, {
    List<String> bookIds = const [],
  }) {
    if (bookIds.isEmpty) {
      return '/data/$translation/random';
    }

    return '/data/$translation/random/${bookIds.join(',')}';
  }
}
