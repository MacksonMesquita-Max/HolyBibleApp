import '../../domain/entities/search_results.dart';
import '../ports/search_repository.dart';

class SearchContentUseCase {
  const SearchContentUseCase(this._repository);

  final SearchRepository _repository;

  Future<SearchResults> execute(String query) {
    final normalizedQuery = query.trim();
    if (normalizedQuery.isEmpty) {
      throw ArgumentError.value(
        query,
        'query',
        'A pesquisa não pode estar vazia.',
      );
    }

    return _repository.search(normalizedQuery);
  }
}
