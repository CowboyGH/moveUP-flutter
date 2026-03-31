import 'package:json_annotation/json_annotation.dart';

part 'active_profile_subscription_dto.g.dart';

/// DTO with focused subscriptions payload from `/profile`.
@JsonSerializable(createToJson: false)
class ProfileSubscriptionsDto {
  /// Currently active subscription, if any.
  final ActiveProfileSubscriptionDto? active;

  /// Creates an instance of [ProfileSubscriptionsDto].
  ProfileSubscriptionsDto({required this.active});

  /// Creates a [ProfileSubscriptionsDto] from JSON.
  factory ProfileSubscriptionsDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileSubscriptionsDtoFromJson(json);
}

/// DTO for the active subscription snapshot returned by `/profile`.
@JsonSerializable(createToJson: false)
class ActiveProfileSubscriptionDto {
  /// Subscription identifier.
  final int id;

  /// Subscription display name.
  final String name;

  /// Subscription monthly or period price.
  final String price;

  /// Subscription start date.
  @JsonKey(name: 'start_date')
  final String startDate;

  /// Subscription end date.
  @JsonKey(name: 'end_date')
  final String endDate;

  /// Remaining days count.
  @JsonKey(name: 'days_left')
  final double? daysLeft;

  /// Creates an instance of [ActiveProfileSubscriptionDto].
  ActiveProfileSubscriptionDto({
    required this.id,
    required this.name,
    required this.price,
    required this.startDate,
    required this.endDate,
    required this.daysLeft,
  });

  /// Creates a [ActiveProfileSubscriptionDto] from JSON.
  factory ActiveProfileSubscriptionDto.fromJson(Map<String, dynamic> json) =>
      _$ActiveProfileSubscriptionDtoFromJson(json);
}
