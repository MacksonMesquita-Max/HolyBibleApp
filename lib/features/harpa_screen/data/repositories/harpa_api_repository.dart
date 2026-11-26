import '../../application/ports/hymn_repository.dart';
import '../../domain/entities/hymn.dart';
import '../datasources/harpa_remote_data_source.dart';

class HarpaApiRepository implements HymnRepository {
  HarpaApiRepository(this._remoteDataSource);

  final HarpaRemoteDataSource _remoteDataSource;

  @override
  Future<Hymn> getByNumber(int number) async {
    final model = await _remoteDataSource.getByNumber(number);
    return model.toEntity();
  }
}
