import '../active_profile_subscription_dto.dart';

/// DTO for the focused `/profile/active-subscription` response.
class ProfileActiveSubscriptionResponseDto {
  /// Active subscription payload, or `null` when there is none.
  final ActiveProfileSubscriptionDto? subscription;

  /// Creates an instance of [ProfileActiveSubscriptionResponseDto].
  const ProfileActiveSubscriptionResponseDto({required this.subscription});

  /// Creates a [ProfileActiveSubscriptionResponseDto] from JSON.
  factory ProfileActiveSubscriptionResponseDto.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is! Map<String, dynamic> || !data.containsKey('id')) {
      return const ProfileActiveSubscriptionResponseDto(subscription: null);
    }
    return ProfileActiveSubscriptionResponseDto(
      subscription: ActiveProfileSubscriptionDto.fromJson(data),
    );
  }
}
