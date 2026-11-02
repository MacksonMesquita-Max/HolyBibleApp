class BibleApiEndpoints {
  const BibleApiEndpoints._();

  static const String baseUrl = 'https://bible-api.com';

  /// Tradução usada por padrão no app.
  static const String defaultTranslation = 'almeida';

  /// Busca por referência livre, ex.: "João 3:16" ou "matt 25:31-33,46".
  /// GET /{reference}?translation={translation}
  static String passage(String reference) {
    final normalized = reference.trim().replaceAll(RegExp(r'\s+'), '+');
    return '/$normalized';
  }

  /// Traduções disponíveis na API.
  /// GET /data
  static String translations() {
    return '/data';
  }

  /// Livros de uma tradução.
  /// GET /data/{translation}
  static String books(String translation) {
    return '/data/$translation';
  }

  /// Capítulos de um livro.
  /// GET /data/{translation}/{bookId}
  static String chapters({required String translation, required String bookId}) {
    return '/data/$translation/$bookId';
  }

  /// Versículos de um capítulo.
  /// GET /data/{translation}/{bookId}/{chapter}
  static String verses({
    required String translation,
    required String bookId,
    required int chapter,
  }) {
    return '/data/$translation/$bookId/$chapter';
  }

  /// Versículo aleatório de uma tradução.
  /// GET /data/{translation}/random
  /// GET /data/{translation}/random/{bookIds}
  ///
  /// `bookIds` aceita códigos de livros (ex.: `['MAT', 'MRK']`) ou os valores
  /// especiais `OT` (Antigo Testamento) e `NT` (Novo Testamento).
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
