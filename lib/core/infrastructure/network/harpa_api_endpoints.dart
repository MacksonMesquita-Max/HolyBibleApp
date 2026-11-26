class HarpaApiEndpoints {
  const HarpaApiEndpoints._();

  static const String baseUrl = 'https://harpa-api.onrender.com';

  static const int defaultPage = 1;
  static const int defaultLimit = 10;
  static const int maxLimit = 50;

  static String hymns({
    int page = defaultPage,
    int limit = defaultLimit,
    String sortOrder = 'asc',
  }) {
    return _paginatedPath(
      '/hymns',
      page: page,
      limit: limit,
      sortOrder: sortOrder,
    );
  }

  static String hymnByNumber(int number) {
    return '/hymns/$number';
  }

  static String searchByTitle(
    String query, {
    int page = defaultPage,
    int limit = defaultLimit,
    String sortOrder = 'asc',
  }) {
    return _paginatedPath(
      '/hymns/search/title/${Uri.encodeComponent(query.trim())}',
      page: page,
      limit: limit,
      sortOrder: sortOrder,
    );
  }

  static String searchByVerse(
    String query, {
    int page = defaultPage,
    int limit = defaultLimit,
    String sortOrder = 'asc',
  }) {
    return _paginatedPath(
      '/hymns/search/verse/${Uri.encodeComponent(query.trim())}',
      page: page,
      limit: limit,
      sortOrder: sortOrder,
    );
  }

  static String searchByNumber(
    int number, {
    int page = defaultPage,
    int limit = defaultLimit,
    String sortOrder = 'asc',
  }) {
    return _paginatedPath(
      '/hymns/search/number/$number',
      page: page,
      limit: limit,
      sortOrder: sortOrder,
    );
  }

  static String randomHymn() {
    return '/hymns/random';
  }

  static String _paginatedPath(
    String path, {
    required int page,
    required int limit,
    required String sortOrder,
  }) {
    if (page < 1) {
      throw ArgumentError.value(page, 'page', 'Deve ser maior que zero.');
    }
    if (limit < 1 || limit > maxLimit) {
      throw ArgumentError.value(
        limit,
        'limit',
        'Deve estar entre 1 e $maxLimit.',
      );
    }
    if (sortOrder != 'asc' && sortOrder != 'desc') {
      throw ArgumentError.value(
        sortOrder,
        'sortOrder',
        'Deve ser "asc" ou "desc".',
      );
    }

    final query = Uri(
      queryParameters: {
        'page': '$page',
        'limit': '$limit',
        'sortOrder': sortOrder,
      },
    ).query;

    return '$path?$query';
  }
}
