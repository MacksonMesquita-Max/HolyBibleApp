import '../../application/ports/bible_repository.dart';
import '../../domain/entities/bible_passage.dart';
import '../datasources/bible_remote_datasource.dart';
import '../mappers/bible_passage_mapper.dart';

class BibleApiRepository implements BibleRepository {
  BibleApiRepository(this._remoteDataSource);

  final BibleRemoteDataSource _remoteDataSource;

  @override
  Future<BiblePassage> getPassage({
    required String reference,
    required String translation,
  }) async {
    final model = await _remoteDataSource.getPassage(
      reference: reference,
      translation: translation,
    );

    return model.toEntity();
  }
}
