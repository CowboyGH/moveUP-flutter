import '../../../constants/app_strings.dart';
import '../../app_failure.dart';

/// Subscriptions application error.
sealed class SubscriptionsFailure extends AppFailure {
  /// Creates an instance of [SubscriptionsFailure].
  const SubscriptionsFailure(
    super.message, {
    super.parentException,
    super.stackTrace,
  });
}

/// Subscriptions validation failed because the provided input is invalid.
final class SubscriptionsValidationFailure extends SubscriptionsFailure {
  /// Creates an instance of [SubscriptionsValidationFailure].
  const SubscriptionsValidationFailure({
    String message = AppStrings.subscriptionsValidationFailed,
    super.parentException,
    super.stackTrace,
  }) : super(message);
}

/// Subscriptions request failed because of infrastructure or network conditions.
final class SubscriptionsRequestFailure extends SubscriptionsFailure {
  /// Creates an instance of [SubscriptionsRequestFailure].
  const SubscriptionsRequestFailure(
    super.message, {
    super.parentException,
    super.stackTrace,
  });
}

/// Subscription could not be found in the active catalog payload.
final class SubscriptionsNotFoundFailure extends SubscriptionsFailure {
  /// Creates an instance of [SubscriptionsNotFoundFailure].
  const SubscriptionsNotFoundFailure() : super(AppStrings.subscriptionsNotFound);
}

/// Unknown subscriptions failure.
final class UnknownSubscriptionsFailure extends SubscriptionsFailure {
  /// Creates an instance of [UnknownSubscriptionsFailure].
  const UnknownSubscriptionsFailure({
    super.parentException,
    super.stackTrace,
  }) : super(AppStrings.subscriptionsUnknown);
}
