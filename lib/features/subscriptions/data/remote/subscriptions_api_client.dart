import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api_paths.dart';
import '../dto/subscription_response_dto.dart';
import '../dto/subscriptions_response_dto.dart';

part 'subscriptions_api_client.g.dart';

/// Retrofit API client for subscriptions catalog requests.
@RestApi()
abstract class SubscriptionsApiClient {
  /// Creates an instance of [SubscriptionsApiClient].
  factory SubscriptionsApiClient(Dio dio, {String? baseUrl}) = _SubscriptionsApiClient;

  /// Returns all subscriptions available in the catalog.
  @GET(ApiPaths.subscriptions)
  Future<SubscriptionsResponseDto> getSubscriptions();

  /// Returns a single subscription by identifier.
  @GET('${ApiPaths.subscriptions}/{subscription}')
  Future<SubscriptionResponseDto> getSubscriptionById(@Path('subscription') int subscriptionId);
}
