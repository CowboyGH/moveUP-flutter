import '../../../../core/failures/feature/subscriptions/subscriptions_failure.dart';
import '../../../../core/result/result.dart';
import '../entities/subscription_catalog_item.dart';
import '../entities/subscription_payment_payload.dart';

/// Repository interface for subscriptions catalog operations.
abstract interface class SubscriptionsRepository {
  /// Returns all subscriptions available for the catalog screen.
  Future<Result<List<SubscriptionCatalogItem>, SubscriptionsFailure>> getSubscriptions();

  /// Returns a single subscription by [id] using the catalog source of truth.
  Future<Result<SubscriptionCatalogItem, SubscriptionsFailure>> getSubscriptionById(int id);

  /// Pays for a subscription using the provided [payload].
  Future<Result<void, SubscriptionsFailure>> paySubscription({
    required SubscriptionPaymentPayload payload,
  });
}
