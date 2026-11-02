/// Falha ao consultar a API da Bíblia (referência inválida, rede, etc.).
class BibleApiException implements Exception {
  const BibleApiException(this.message);

  final String message;

  @override
  String toString() => message;
}
