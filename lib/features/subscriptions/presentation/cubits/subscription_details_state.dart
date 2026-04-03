part of 'subscription_details_cubit.dart';

/// States for [SubscriptionDetailsCubit].
@freezed
class SubscriptionDetailsState with _$SubscriptionDetailsState {
  /// Initial idle state before subscription details loading.
  const factory SubscriptionDetailsState.initial() = _Initial;

  /// State emitted while the details request is in progress.
  const factory SubscriptionDetailsState.inProgress() = _InProgress;

  /// State emitted when details load successfully.
  const factory SubscriptionDetailsState.loaded(SubscriptionCatalogItem item) = _Loaded;

  /// State emitted when details loading fails.
  const factory SubscriptionDetailsState.failed(SubscriptionsFailure failure) = _Failed;
}
