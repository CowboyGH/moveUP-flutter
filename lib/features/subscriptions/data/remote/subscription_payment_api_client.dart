import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api_paths.dart';
import '../dto/subscription_payment_request_dto.dart';

part 'subscription_payment_api_client.g.dart';

/// Retrofit API client for subscription payment commands.
@RestApi()
abstract class SubscriptionPaymentApiClient {
  /// Creates an instance of [SubscriptionPaymentApiClient].
  factory SubscriptionPaymentApiClient(Dio dio, {String? baseUrl}) = _SubscriptionPaymentApiClient;

  /// Pays for a subscription using manual card details.
  @POST(ApiPaths.paymentSubscription)
  Future<void> paySubscription(@Body() SubscriptionPaymentRequestDto request);
}
