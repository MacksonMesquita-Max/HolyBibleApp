import '../../core/infrastructure/network/dio_client.dart';
import '../../core/infrastructure/network/harpa_api_endpoints.dart';
import 'application/use_cases/get_hymn_by_number_use_case.dart';
import 'data/datasources/harpa_remote_data_source.dart';
import 'data/repositories/harpa_api_repository.dart';
import 'presentation/pages/harpa_page.dart';

class HarpaScreenModule {
  HarpaScreenModule._({required this.getHymnByNumberUseCase});

  factory HarpaScreenModule.create() {
    final repository = HarpaApiRepository(
      HarpaRemoteDataSource(DioClient(baseUrl: HarpaApiEndpoints.baseUrl)),
    );

    return HarpaScreenModule._(
      getHymnByNumberUseCase: GetHymnByNumberUseCase(repository),
    );
  }

  final GetHymnByNumberUseCase getHymnByNumberUseCase;

  HarpaPage buildHarpaPage({int? initialHymnNumber}) {
    return HarpaPage(
      getHymnByNumberUseCase: getHymnByNumberUseCase,
      initialHymnNumber: initialHymnNumber,
    );
  }
}
