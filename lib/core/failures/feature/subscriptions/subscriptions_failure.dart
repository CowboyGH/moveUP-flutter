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

/// Subscriptions request failed because of infrastructure or network conditions.
final class SubscriptionsRequestFailure extends SubscriptionsFailure {
  /// Creates an instance of [SubscriptionsRequestFailure].
  const SubscriptionsRequestFailure(
    super.message, {
    super.parentException,
    super.stackTrace,
  });
}

/// Unknown subscriptions failure.
final class UnknownSubscriptionsFailure extends SubscriptionsFailure {
  /// Creates an instance of [UnknownSubscriptionsFailure].
  const UnknownSubscriptionsFailure({
    super.parentException,
    super.stackTrace,
  }) : super(AppStrings.subscriptionsUnknown);
}
