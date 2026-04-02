part of 'subscriptions_cubit.dart';

/// States for [SubscriptionsCubit].
@freezed
class SubscriptionsState with _$SubscriptionsState {
  /// Initial idle state before subscriptions loading.
  const factory SubscriptionsState.initial() = _Initial;

  /// State emitted while subscriptions request is in progress.
  const factory SubscriptionsState.inProgress() = _InProgress;

  /// State emitted when subscriptions load successfully.
  const factory SubscriptionsState.loaded(List<SubscriptionCatalogItem> items) = _Loaded;

  /// State emitted when subscriptions loading fails.
  const factory SubscriptionsState.failed(SubscriptionsFailure failure) = _Failed;
}
