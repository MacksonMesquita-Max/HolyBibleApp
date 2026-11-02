import '../../core/infrastructure/network/bible_api_endpoints.dart';
import '../../core/infrastructure/network/dio_client.dart';
import 'package:flutter/widgets.dart';
import 'application/use_cases/get_passage_use_case.dart';
import 'data/datasources/bible_remote_datasource.dart';
import 'data/repositories/bible_api_repository.dart';
import 'presentation/pages/bible_page.dart';

class BibleScreenModule {
  BibleScreenModule._({required this.getPassageUseCase});

  factory BibleScreenModule.create() {
    final repository = BibleApiRepository(
      BibleRemoteDataSource(DioClient(baseUrl: BibleApiEndpoints.baseUrl)),
    );

    return BibleScreenModule._(
      getPassageUseCase: GetPassageUseCase(repository),
    );
  }

  final GetPassageUseCase getPassageUseCase;

  BiblePage buildBiblePage({required Widget bottomNavigationBar}) {
    return BiblePage(
      getPassageUseCase: getPassageUseCase,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
