/// Entrada do caso de uso de leitura de uma passagem.
class PassageRequest {
  const PassageRequest({
    required this.reference,
    this.translation = defaultTranslation,
  });

  static const String defaultTranslation = 'almeida';

  final String reference;
  final String translation;
}
