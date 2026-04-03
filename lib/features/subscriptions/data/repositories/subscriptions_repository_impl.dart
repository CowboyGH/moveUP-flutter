import 'package:dio/dio.dart';

import '../../../../core/failures/feature/subscriptions/subscriptions_failure.dart';
import '../../../../core/failures/network/network_failure.dart';
import '../../../../core/network/mappers/dio_exception_mapper.dart';
import '../../../../core/result/result.dart';
import '../../../../core/utils/logger/app_logger.dart';
import '../../domain/entities/subscription_catalog_item.dart';
import '../../domain/entities/subscription_payment_payload.dart';
import '../../domain/repositories/subscriptions_repository.dart';
import '../dto/subscription_payment_request_dto.dart';
import '../mappers/subscription_catalog_mapper.dart';
import '../mappers/subscriptions_failure_mapper.dart';
import '../remote/subscription_payment_api_client.dart';
import '../remote/subscriptions_api_client.dart';

/// Implementation of [SubscriptionsRepository].
final class SubscriptionsRepositoryImpl implements SubscriptionsRepository {
  /// Logger for tracking subscriptions catalog operations and errors.
  final AppLogger _logger;

  /// API client for subscriptions catalog requests.
  final SubscriptionsApiClient _apiClient;

  /// API client for subscription payment commands.
  final SubscriptionPaymentApiClient _paymentApiClient;

  /// Creates an instance of [SubscriptionsRepositoryImpl].
  SubscriptionsRepositoryImpl(this._logger, this._apiClient, this._paymentApiClient);

  @override
  Future<Result<List<SubscriptionCatalogItem>, SubscriptionsFailure>> getSubscriptions() async {
    try {
      final items = await _loadActiveSubscriptions();
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

  @override
  Future<Result<SubscriptionCatalogItem, SubscriptionsFailure>> getSubscriptionById(int id) async {
    try {
      final response = await _apiClient.getSubscriptionById(id);
      final itemDto = response.data;
      if (!itemDto.isActive) {
        return const Result.failure(SubscriptionsNotFoundFailure());
      }
      return Result.success(itemDto.toEntity());
    } on DioException catch (e) {
      final networkFailure = e.toNetworkFailure();
      if (networkFailure case NotFoundFailure()) {
        return const Result.failure(SubscriptionsNotFoundFailure());
      }
      return Result.failure(networkFailure.toSubscriptionsFailure());
    } catch (e, s) {
      _logger.e('GetSubscriptionById failed with unexpected error', e, s);
      return Result.failure(
        UnknownSubscriptionsFailure(parentException: e, stackTrace: s),
      );
    }
  }

  @override
  Future<Result<void, SubscriptionsFailure>> paySubscription({
    required SubscriptionPaymentPayload payload,
  }) async {
    try {
      await _paymentApiClient.paySubscription(
        SubscriptionPaymentRequestDto(
          subscriptionId: payload.subscriptionId,
          saveCard: payload.saveCard,
          useSavedCard: false,
          cardNumber: payload.cardNumber,
          cardHolder: payload.cardHolder,
          expiryMonth: payload.expiryMonth,
          expiryYear: payload.expiryYear,
          cvv: payload.cvv,
        ),
      );
      return const Result.success(null);
    } on DioException catch (e) {
      final networkFailure = e.toNetworkFailure();
      return Result.failure(networkFailure.toSanitizedPaymentFailure());
    } catch (e, s) {
      _logger.e('PaySubscription failed with unexpected error', e, s);
      return Result.failure(
        UnknownSubscriptionsFailure(parentException: e, stackTrace: s),
      );
    }
  }

  Future<List<SubscriptionCatalogItem>> _loadActiveSubscriptions() async {
    final response = await _apiClient.getSubscriptions();
    return response.data
        .where((item) => item.isActive)
        .map((item) => item.toEntity())
        .toList(growable: false);
  }
}
