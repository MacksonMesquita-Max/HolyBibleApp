import '../../application/ports/search_repository.dart';
import '../../domain/entities/search_results.dart';
import '../datasources/search_remote_data_source.dart';

class SearchApiRepository implements SearchRepository {
  SearchApiRepository(this._remoteDataSource);

  final SearchRemoteDataSource _remoteDataSource;

  @override
  Future<SearchResults> search(String query) async {
    final model = await _remoteDataSource.search(query);
    return model.toEntity();
  }
}
