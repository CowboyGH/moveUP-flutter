import '../../../../core/failures/feature/subscriptions/subscriptions_failure.dart';
import '../../../../core/result/result.dart';
import '../entities/subscription_catalog_item.dart';

/// Repository interface for subscriptions catalog operations.
abstract interface class SubscriptionsRepository {
  /// Returns all subscriptions available for the catalog screen.
  Future<Result<List<SubscriptionCatalogItem>, SubscriptionsFailure>> getSubscriptions();
}
