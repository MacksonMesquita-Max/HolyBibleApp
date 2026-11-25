import '../../core/infrastructure/network/bible_api_endpoints.dart';
import '../../core/infrastructure/network/dio_client.dart';
import 'application/use_cases/get_daily_verse_use_case.dart';
import 'data/datasources/home_verse_remote_data_source.dart';
import 'data/repositories/remote_daily_verse_repository.dart';
import 'presentation/pages/home_page.dart';

class HomeScreenModule {
  HomeScreenModule._({required this.getDailyVerseUseCase});

  factory HomeScreenModule.create() {
    final repository = RemoteDailyVerseRepository(
      HomeVerseRemoteDataSource(DioClient(baseUrl: BibleApiEndpoints.baseUrl)),
    );

    return HomeScreenModule._(
      getDailyVerseUseCase: GetDailyVerseUseCase(repository),
    );
  }

  final GetDailyVerseUseCase getDailyVerseUseCase;

  HomePage buildHomePage() {
    return HomePage(getDailyVerseUseCase: getDailyVerseUseCase);
  }
}
