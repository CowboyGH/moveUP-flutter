import '../../../../core/failures/feature/subscriptions/subscriptions_failure.dart';
import '../../../../core/failures/network/network_failure.dart';

/// Extension to map [NetworkFailure] into [SubscriptionsFailure].
extension SubscriptionsFailureMapper on NetworkFailure {
  /// Maps a [NetworkFailure] into a subscriptions-specific failure.
  SubscriptionsFailure toSubscriptionsFailure() {
    return switch (this) {
      NoNetworkFailure() ||
      ConnectionTimeoutFailure() ||
      BadRequestFailure() ||
      UnauthorizedFailure() ||
      ForbiddenFailure() ||
      NotFoundFailure() ||
      ConflictFailure() ||
      ValidationFailure() ||
      RateLimitedFailure() ||
      ServerErrorFailure() ||
      UnknownNetworkFailure() => SubscriptionsRequestFailure(
        message,
        parentException: parentException,
        stackTrace: stackTrace,
      ),
    };
  }
}
