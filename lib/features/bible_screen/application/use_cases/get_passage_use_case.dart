import '../../domain/entities/bible_passage.dart';
import '../dto/passage_request.dart';
import '../ports/bible_repository.dart';

class GetPassageUseCase {
  const GetPassageUseCase(this._repository);

  final BibleRepository _repository;

  Future<BiblePassage> execute(PassageRequest request) {
    final reference = request.reference.trim();
    if (reference.isEmpty) {
      throw ArgumentError('Informe uma referência bíblica.');
    }

    return _repository.getPassage(
      reference: reference,
      translation: request.translation,
    );
  }
}
