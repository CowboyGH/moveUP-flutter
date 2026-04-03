part of 'cancel_subscription_cubit.dart';

/// State for [CancelSubscriptionCubit].
@freezed
sealed class CancelSubscriptionState with _$CancelSubscriptionState {
  /// Initial idle state.
  const factory CancelSubscriptionState.initial() = _Initial;

  /// Cancel request is in progress.
  const factory CancelSubscriptionState.inProgress() = _InProgress;

  /// Cancel request completed successfully.
  const factory CancelSubscriptionState.succeed() = _Succeed;

  /// Cancel request failed.
  const factory CancelSubscriptionState.failed(SubscriptionsFailure failure) = _Failed;
}
