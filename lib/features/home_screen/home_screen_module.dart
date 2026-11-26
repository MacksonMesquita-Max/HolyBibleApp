import '../../core/infrastructure/network/bible_api_endpoints.dart';
import '../../core/infrastructure/network/dio_client.dart';
import '../../core/infrastructure/network/harpa_api_endpoints.dart';
import 'application/use_cases/get_daily_verse_use_case.dart';
import 'application/use_cases/get_random_hymn_use_case.dart';
import 'data/datasources/random_hymn_remote_data_source.dart';
import 'data/datasources/home_verse_remote_data_source.dart';
import 'data/repositories/remote_random_hymn_repository.dart';
import 'data/repositories/remote_daily_verse_repository.dart';
import 'presentation/pages/home_page.dart';

class HomeScreenModule {
  HomeScreenModule._({
    required this.getDailyVerseUseCase,
    required this.getRandomHymnUseCase,
  });

  factory HomeScreenModule.create() {
    final dailyVerseRepository = RemoteDailyVerseRepository(
      HomeVerseRemoteDataSource(DioClient(baseUrl: BibleApiEndpoints.baseUrl)),
    );
    final randomHymnRepository = RemoteRandomHymnRepository(
      RandomHymnRemoteDataSource(DioClient(baseUrl: HarpaApiEndpoints.baseUrl)),
    );

    return HomeScreenModule._(
      getDailyVerseUseCase: GetDailyVerseUseCase(dailyVerseRepository),
      getRandomHymnUseCase: GetRandomHymnUseCase(randomHymnRepository),
    );
  }

  final GetDailyVerseUseCase getDailyVerseUseCase;
  final GetRandomHymnUseCase getRandomHymnUseCase;

  HomePage buildHomePage({required String userName}) {
    return HomePage(
      getDailyVerseUseCase: getDailyVerseUseCase,
      getRandomHymnUseCase: getRandomHymnUseCase,
      userName: userName,
    );
  }
}
