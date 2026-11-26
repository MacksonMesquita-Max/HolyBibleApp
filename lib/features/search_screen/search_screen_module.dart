import '../../core/infrastructure/network/bible_api_endpoints.dart';
import '../../core/infrastructure/network/dio_client.dart';
import '../../core/infrastructure/network/harpa_api_endpoints.dart';
import 'application/use_cases/search_content_use_case.dart';
import 'data/datasources/search_remote_data_source.dart';
import 'data/repositories/search_api_repository.dart';
import 'presentation/pages/search_page.dart';

class SearchScreenModule {
  SearchScreenModule._({required this.searchContentUseCase});

  factory SearchScreenModule.create() {
    final repository = SearchApiRepository(
      SearchRemoteDataSource(
        DioClient(baseUrl: BibleApiEndpoints.baseUrl),
        DioClient(baseUrl: HarpaApiEndpoints.baseUrl),
      ),
    );

    return SearchScreenModule._(
      searchContentUseCase: SearchContentUseCase(repository),
    );
  }

  final SearchContentUseCase searchContentUseCase;

  SearchPage buildSearchPage({
    required void Function(String) onOpenBibleReference,
    required void Function(int) onOpenHymn,
  }) {
    return SearchPage(
      searchContentUseCase: searchContentUseCase,
      onOpenBibleReference: onOpenBibleReference,
      onOpenHymn: onOpenHymn,
    );
  }
}
