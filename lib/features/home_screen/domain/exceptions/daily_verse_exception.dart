/// Falha ao obter o versículo do dia (rede, resposta inválida, etc.).
class DailyVerseException implements Exception {
  const DailyVerseException(this.message);

  final String message;

  @override
  String toString() => message;
}
