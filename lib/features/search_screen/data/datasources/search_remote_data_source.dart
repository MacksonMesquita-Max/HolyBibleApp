import 'package:dio/dio.dart';

import '../../../../core/infrastructure/network/bible_api_endpoints.dart';
import '../../../../core/infrastructure/network/dio_client.dart';
import '../../../../core/infrastructure/network/harpa_api_endpoints.dart';
import '../models/search_results_model.dart';

class SearchRemoteDataSource {
  SearchRemoteDataSource(this._bibleClient, this._harpaClient);

  final DioClient _bibleClient;
  final DioClient _harpaClient;

  Future<SearchResultsModel> search(String query) async {
    final isBibleReferenceQuery = RegExp(r'\d').hasMatch(query);
    final bibleFuture = isBibleReferenceQuery
        ? _searchBibleReference(query)
        : Future.value(const _BibleSearchOutcome());

    final harpaPaths = [
      HarpaApiEndpoints.searchByTitle(query),
      HarpaApiEndpoints.searchByVerse(query),
    ];
    final hymnNumber = int.tryParse(query);
    if (hymnNumber != null) {
      harpaPaths.add(HarpaApiEndpoints.searchByNumber(hymnNumber));
    }

    final harpaFuture = Future.wait<_HarpaSearchOutcome>(
      harpaPaths.map(_searchHarpa),
    );
    final bibleResult = await bibleFuture;
    final harpaResults = await harpaFuture;
    final successfulHarpaResponses = harpaResults
        .where((result) => result.response != null)
        .map((result) => result.response!)
        .toList(growable: false);
    final harpaUnavailable = harpaResults.every((result) => !result.succeeded);

    return SearchResultsModel.fromResponses(
      isBibleReferenceQuery: isBibleReferenceQuery,
      bibleUnavailable: bibleResult.unavailable,
      harpaUnavailable: harpaUnavailable,
      bibleResponse: bibleResult.response,
      harpaResponses: successfulHarpaResponses,
    );
  }

  Future<_BibleSearchOutcome> _searchBibleReference(String query) async {
    try {
      final response = await _bibleClient.dio.get<Map<String, dynamic>>(
        BibleApiEndpoints.passage(query),
        queryParameters: {'translation': BibleApiEndpoints.defaultTranslation},
      );
      final data = response.data;

      if (data == null || data['error'] != null) {
        return const _BibleSearchOutcome();
      }

      return _BibleSearchOutcome(response: data);
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        return const _BibleSearchOutcome();
      }
      return const _BibleSearchOutcome(unavailable: true);
    } on FormatException {
      return const _BibleSearchOutcome(unavailable: true);
    }
  }

  Future<_HarpaSearchOutcome> _searchHarpa(String path) async {
    try {
      final response = await _harpaClient.dio.get<Map<String, dynamic>>(path);
      final data = response.data;

      if (data == null || data['errors'] != null) {
        return const _HarpaSearchOutcome();
      }

      return _HarpaSearchOutcome(response: data);
    } on DioException {
      return const _HarpaSearchOutcome();
    } on FormatException {
      return const _HarpaSearchOutcome();
    }
  }
}

class _BibleSearchOutcome {
  const _BibleSearchOutcome({this.response, this.unavailable = false});

  final Map<String, dynamic>? response;
  final bool unavailable;
}

class _HarpaSearchOutcome {
  const _HarpaSearchOutcome({this.response}) : succeeded = response != null;

  final Map<String, dynamic>? response;
  final bool succeeded;
}
