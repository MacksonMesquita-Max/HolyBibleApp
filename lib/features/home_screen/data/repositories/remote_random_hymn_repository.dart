import '../../application/ports/random_hymn_repository.dart';
import '../../domain/entities/random_hymn.dart';
import '../datasources/random_hymn_remote_data_source.dart';

class RemoteRandomHymnRepository implements RandomHymnRepository {
  RemoteRandomHymnRepository(this._remoteDataSource);

  final RandomHymnRemoteDataSource _remoteDataSource;

  @override
  Future<RandomHymn> getRandomHymn() async {
    final model = await _remoteDataSource.getRandomHymn();
    return model.toEntity();
  }
}
