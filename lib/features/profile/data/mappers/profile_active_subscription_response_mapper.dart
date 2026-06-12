import '../../domain/entities/profile_stats_history_snapshot.dart';
import '../dto/active_profile_subscription_dto.dart';
import '../dto/focused/profile_active_subscription_response_dto.dart';

/// Maps `/profile/active-subscription` DTO to the active subscription snapshot.
extension ProfileActiveSubscriptionResponseMapper on ProfileActiveSubscriptionResponseDto {
  /// Returns a snapshot of the active subscription, or `null` when there is none.
  ProfileActiveSubscriptionSnapshot? toSnapshot() => subscription?.toEntity();
}

extension on ActiveProfileSubscriptionDto {
  ProfileActiveSubscriptionSnapshot toEntity() => ProfileActiveSubscriptionSnapshot(
    id: id,
    name: name,
    price: price,
    startDate: startDate,
    endDate: endDate,
  );
}
