import '../../../../core/infrastructure/network/dio_client.dart';
import '../../../../core/infrastructure/network/harpa_api_endpoints.dart';
import '../models/random_hymn_model.dart';

class RandomHymnRemoteDataSource {
  RandomHymnRemoteDataSource(this._dioClient);

  final DioClient _dioClient;

  Future<RandomHymnModel> getRandomHymn() async {
    final response = await _dioClient.dio.get<Map<String, dynamic>>(
      HarpaApiEndpoints.randomHymn(),
    );

    final data = response.data;
    if (data == null) {
      throw const FormatException('Resposta vazia da API da Harpa.');
    }

    return RandomHymnModel.fromJson(data);
  }
}
