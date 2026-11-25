import 'package:dio/dio.dart';

import '../../../../core/infrastructure/network/bible_api_endpoints.dart';
import '../../../../core/infrastructure/network/dio_client.dart';
import '../../domain/exceptions/daily_verse_exception.dart';
import '../models/daily_verse_model.dart';

class HomeVerseRemoteDataSource {
  HomeVerseRemoteDataSource(this._dioClient);

  final DioClient _dioClient;

  Future<DailyVerseModel> getRandomVerse({required String translation}) async {
    try {
      final response = await _dioClient.dio.get<Map<String, dynamic>>(
        BibleApiEndpoints.randomVerse(translation),
      );

      final data = response.data;
      if (data == null) {
        throw const DailyVerseException('Resposta vazia da API.');
      }

      final apiError = data['error'];
      if (apiError != null) {
        throw DailyVerseException(apiError.toString());
      }

      return DailyVerseModel.fromJson(data);
    } on DioException catch (error) {
      throw DailyVerseException(_describe(error, translation));
    }
  }

  String _describe(DioException error, String translation) {
    if (error.response?.statusCode == 404) {
      final responseData = error.response?.data;
      if (responseData is Map<String, dynamic>) {
        final apiError = responseData['error']?.toString().trim();
        if (apiError != null && apiError.isNotEmpty) {
          return 'Bible API: $apiError';
        }
      }

      return 'A Bible API não encontrou a tradução "$translation" ou o endpoint solicitado (HTTP 404).';
    }

    return 'Não foi possível carregar o versículo. Verifique sua conexão.';
  }
}
