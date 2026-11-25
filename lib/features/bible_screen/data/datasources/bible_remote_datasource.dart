import 'package:dio/dio.dart';

import '../../../../core/infrastructure/network/bible_api_endpoints.dart';
import '../../../../core/infrastructure/network/dio_client.dart';
import '../../domain/exceptions/bible_api_exception.dart';
import '../models/bible_passage_model.dart';

class BibleRemoteDataSource {
  BibleRemoteDataSource(this._dioClient);

  final DioClient _dioClient;

  Future<BiblePassageModel> getPassage({
    required String reference,
    required String translation,
  }) async {
    try {
      final response = await _dioClient.dio.get<Map<String, dynamic>>(
        BibleApiEndpoints.passage(reference),
        queryParameters: {'translation': translation},
      );

      final data = response.data;
      if (data == null) {
        throw const BibleApiException('Resposta vazia da API.');
      }

      final apiError = data['error'];
      if (apiError != null) {
        throw BibleApiException(apiError.toString());
      }

      return BiblePassageModel.fromJson(data);
    } on DioException catch (error) {
      throw BibleApiException(_describe(error));
    }
  }

  String _describe(DioException error) {
    if (error.response?.statusCode == 404) {
      final responseData = error.response?.data;
      if (responseData is Map<String, dynamic>) {
        final apiError = responseData['error']?.toString().trim();
        if (apiError != null && apiError.isNotEmpty) {
          return 'Bible API: $apiError';
        }
      }

      return 'A Bible API não encontrou a referência ou tradução solicitada (HTTP 404).';
    }

    return 'Não foi possível consultar a Bíblia agora. Verifique sua conexão.';
  }
}
