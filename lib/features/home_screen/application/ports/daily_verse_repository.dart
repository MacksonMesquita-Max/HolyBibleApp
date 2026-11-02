import '../../domain/entities/daily_verse.dart';

/// Contrato de acesso ao versículo do dia, implementado pela camada de dados.
abstract interface class DailyVerseRepository {
  Future<DailyVerse> getDailyVerse();
}
