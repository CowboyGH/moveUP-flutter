part of 'profile_subscription_cubit.dart';

/// State for [ProfileSubscriptionCubit].
@freezed
abstract class ProfileSubscriptionState with _$ProfileSubscriptionState {
  /// Creates an instance of [ProfileSubscriptionState].
  const factory ProfileSubscriptionState({
    @Default(false) bool isLoading,
    ProfileActiveSubscriptionSnapshot? activeSubscription,
    SubscriptionCatalogItem? item,
    SubscriptionsFailure? failure,
  }) = _ProfileSubscriptionState;
}
