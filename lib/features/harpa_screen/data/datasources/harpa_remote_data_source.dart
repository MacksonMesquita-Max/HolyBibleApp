import 'package:dio/dio.dart';

import '../../../../core/infrastructure/network/dio_client.dart';
import '../../../../core/infrastructure/network/harpa_api_endpoints.dart';
import '../../domain/exceptions/harpa_api_exception.dart';
import '../models/hymn_model.dart';

class HarpaRemoteDataSource {
  HarpaRemoteDataSource(this._dioClient);

  final DioClient _dioClient;

  Future<HymnModel> getByNumber(int number) async {
    try {
      final response = await _dioClient.dio.get<Map<String, dynamic>>(
        HarpaApiEndpoints.hymnByNumber(number),
      );
      final data = response.data;

      if (data == null) {
        throw const HarpaApiException('Resposta vazia da API da Harpa.');
      }

      final apiError = data['error'];
      if (apiError != null) {
        throw HarpaApiException(apiError.toString());
      }

      return HymnModel.fromResponse(data);
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        throw const HarpaApiException('Hino não encontrado.');
      }
      throw const HarpaApiException(
        'Não foi possível carregar o hino. Verifique sua conexão.',
      );
    } on FormatException catch (error) {
      throw HarpaApiException(error.message);
    }
  }
}
