import '../../domain/entities/bible_passage.dart';

/// Contrato de acesso ao texto bíblico, implementado pela camada de dados.
abstract interface class BibleRepository {
  Future<BiblePassage> getPassage({
    required String reference,
    required String translation,
  });
}
