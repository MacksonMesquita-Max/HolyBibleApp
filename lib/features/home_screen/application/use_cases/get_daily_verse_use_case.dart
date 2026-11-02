import '../../domain/entities/daily_verse.dart';
import '../ports/daily_verse_repository.dart';

class GetDailyVerseUseCase {
  const GetDailyVerseUseCase(this._repository);

  final DailyVerseRepository _repository;

  Future<DailyVerse> execute() => _repository.getDailyVerse();
}
