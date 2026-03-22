import 'package:dio/dio.dart';

import '../../../../../core/failures/feature/tests/tests_failure.dart';
import '../../../../../core/network/mappers/dio_exception_mapper.dart';
import '../../../../../core/result/result.dart';
import '../../../../../core/utils/logger/app_logger.dart';
import '../../domain/entities/testing_catalog_item.dart';
import '../../domain/repositories/tests_catalog_repository.dart';
import '../mappers/testing_catalog_mapper.dart';
import '../mappers/tests_failure_mapper.dart';
import '../../../data/remote/tests_api_client.dart';

/// Implementation of [TestsCatalogRepository].
final class TestsCatalogRepositoryImpl implements TestsCatalogRepository {
  /// Logger for tracking tests catalog operations and errors.
  final AppLogger _logger;

  /// API client for tests catalog requests.
  final TestsApiClient _apiClient;

  /// Creates an instance of [TestsCatalogRepositoryImpl].
  TestsCatalogRepositoryImpl(this._logger, this._apiClient);

  @override
  Future<Result<List<TestingCatalogItem>, TestsFailure>> getTestings() async {
    try {
      final response = await _apiClient.getTestings();
      final items = response.data.map((item) => item.toEntity()).toList(growable: false);
      return Result.success(items);
    } on DioException catch (e) {
      final networkFailure = e.toNetworkFailure();
      return Result.failure(networkFailure.toTestsFailure());
    } catch (e, s) {
      _logger.e('GetTestings failed with unexpected error', e, s);
      return Result.failure(UnknownTestsFailure(parentException: e, stackTrace: s));
    }
  }
}
