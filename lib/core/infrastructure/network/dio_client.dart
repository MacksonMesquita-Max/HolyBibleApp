import 'package:dio/dio.dart';

/// Cliente HTTP central da aplicacao, baseado no Dio.
///
/// Concentra a configuracao de base URL, timeouts e interceptadores,
/// servindo como ponto unico de configuracao das requisicoes de rede.
class DioClient {
  DioClient({String? baseUrl}) : _dio = _buildDio(baseUrl ?? defaultBaseUrl);

  /// URL base padrao das requisicoes.
  static const String defaultBaseUrl = 'https://bible-api.com';

  final Dio _dio;

  /// Instancia do Dio configurada para uso na aplicacao.
  Dio get dio => _dio;

  static Dio _buildDio(String baseUrl) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        responseType: ResponseType.json,
      ),
    );

    dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );

    return dio;
  }
}
