import '../../domain/entities/hymn.dart';
import '../ports/hymn_repository.dart';

class GetHymnByNumberUseCase {
  const GetHymnByNumberUseCase(this._repository);

  final HymnRepository _repository;

  Future<Hymn> execute(int number) {
    if (number < 1) {
      throw ArgumentError.value(
        number,
        'number',
        'O número deve ser positivo.',
      );
    }

    return _repository.getByNumber(number);
  }
}
