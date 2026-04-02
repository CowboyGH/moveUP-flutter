import 'package:dio/dio.dart';

import '../../../../core/failures/feature/subscriptions/subscriptions_failure.dart';
import '../../../../core/network/mappers/dio_exception_mapper.dart';
import '../../../../core/result/result.dart';
import '../../../../core/utils/logger/app_logger.dart';
import '../../domain/entities/subscription_catalog_item.dart';
import '../../domain/repositories/subscriptions_repository.dart';
import '../mappers/subscription_catalog_mapper.dart';
import '../mappers/subscriptions_failure_mapper.dart';
import '../remote/subscriptions_api_client.dart';

/// Implementation of [SubscriptionsRepository].
final class SubscriptionsRepositoryImpl implements SubscriptionsRepository {
  /// Logger for tracking subscriptions catalog operations and errors.
  final AppLogger _logger;

  /// API client for subscriptions catalog requests.
  final SubscriptionsApiClient _apiClient;

  /// Creates an instance of [SubscriptionsRepositoryImpl].
  SubscriptionsRepositoryImpl(this._logger, this._apiClient);

  @override
  Future<Result<List<SubscriptionCatalogItem>, SubscriptionsFailure>> getSubscriptions() async {
    try {
      final response = await _apiClient.getSubscriptions();
      final items = response.data.map((item) => item.toEntity()).toList(growable: false);
      return Result.success(items);
    } on DioException catch (e) {
      final networkFailure = e.toNetworkFailure();
      return Result.failure(networkFailure.toSubscriptionsFailure());
    } catch (e, s) {
      _logger.e('GetSubscriptions failed with unexpected error', e, s);
      return Result.failure(
        UnknownSubscriptionsFailure(parentException: e, stackTrace: s),
      );
    }
  }
}
