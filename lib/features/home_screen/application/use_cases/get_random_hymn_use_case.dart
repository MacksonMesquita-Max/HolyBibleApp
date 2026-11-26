import '../../domain/entities/random_hymn.dart';
import '../ports/random_hymn_repository.dart';

class GetRandomHymnUseCase {
  const GetRandomHymnUseCase(this._repository);

  final RandomHymnRepository _repository;

  Future<RandomHymn> execute() => _repository.getRandomHymn();
}
