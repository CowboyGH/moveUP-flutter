import '../../../../core/failures/feature/subscriptions/subscriptions_failure.dart';
import '../../../../core/failures/helpers/validation_message_builder.dart';
import '../../../../core/failures/network/network_failure.dart';

/// Extension to map [NetworkFailure] into [SubscriptionsFailure].
extension SubscriptionsFailureMapper on NetworkFailure {
  /// Maps a [NetworkFailure] into a subscriptions-specific failure.
  SubscriptionsFailure toSubscriptionsFailure() {
    if (this case ValidationFailure(:final errors)) {
      final validationMessage = buildValidationMessage(
        errors,
        fallbackMessage: const SubscriptionsValidationFailure().message,
      );
      return SubscriptionsValidationFailure(
        message: validationMessage,
        parentException: parentException,
        stackTrace: stackTrace,
      );
    }

    return switch (this) {
      ValidationFailure() => SubscriptionsValidationFailure(
        parentException: parentException,
        stackTrace: stackTrace,
      ),
      NotFoundFailure() ||
      NoNetworkFailure() ||
      ConnectionTimeoutFailure() ||
      BadRequestFailure() ||
      UnauthorizedFailure() ||
      ForbiddenFailure() ||
      ConflictFailure() ||
      RateLimitedFailure() ||
      ServerErrorFailure() ||
      UnknownNetworkFailure() => SubscriptionsRequestFailure(
        message,
        parentException: parentException,
        stackTrace: stackTrace,
      ),
    };
  }

  /// Maps a payment [NetworkFailure] into a subscriptions-specific failure without
  /// preserving the original transport exception.
  SubscriptionsFailure toSanitizedPaymentFailure() {
    if (this case ValidationFailure(:final errors, :final stackTrace)) {
      final validationMessage = buildValidationMessage(
        errors,
        fallbackMessage: const SubscriptionsValidationFailure().message,
      );
      return SubscriptionsValidationFailure(
        message: validationMessage,
        stackTrace: stackTrace,
      );
    }

    return SubscriptionsRequestFailure(
      message,
      stackTrace: stackTrace,
    );
  }
}
