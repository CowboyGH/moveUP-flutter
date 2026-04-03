part of 'subscription_payment_cubit.dart';

/// States for [SubscriptionPaymentCubit].
@freezed
class SubscriptionPaymentState with _$SubscriptionPaymentState {
  /// Initial idle state before submit.
  const factory SubscriptionPaymentState.initial() = _Initial;

  /// State emitted while payment submit is in progress.
  const factory SubscriptionPaymentState.inProgress() = _InProgress;

  /// State emitted when payment succeeds.
  const factory SubscriptionPaymentState.succeed() = _Succeed;

  /// State emitted when payment fails.
  const factory SubscriptionPaymentState.failed(SubscriptionsFailure failure) = _Failed;
}
