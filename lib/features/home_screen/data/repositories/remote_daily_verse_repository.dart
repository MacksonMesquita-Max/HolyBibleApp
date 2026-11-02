import '../../../../core/infrastructure/network/bible_api_endpoints.dart';
import '../../application/ports/daily_verse_repository.dart';
import '../../domain/entities/daily_verse.dart';
import '../datasources/home_verse_remote_data_source.dart';
import '../mappers/daily_verse_mapper.dart';

class RemoteDailyVerseRepository implements DailyVerseRepository {
  RemoteDailyVerseRepository(this._remoteDataSource);

  final HomeVerseRemoteDataSource _remoteDataSource;

  @override
  Future<DailyVerse> getDailyVerse() async {
    final model = await _remoteDataSource.getRandomVerse(
      translation: BibleApiEndpoints.defaultTranslation,
    );

    return model.toEntity();
  }
}
