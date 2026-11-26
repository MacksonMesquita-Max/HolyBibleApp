class HarpaApiException implements Exception {
  const HarpaApiException(this.message);

  final String message;

  @override
  String toString() => message;
}
