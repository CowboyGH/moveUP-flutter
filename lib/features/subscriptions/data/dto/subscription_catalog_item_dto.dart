import 'package:json_annotation/json_annotation.dart';

part 'subscription_catalog_item_dto.g.dart';

/// DTO for a subscriptions catalog item.
@JsonSerializable(createToJson: false)
class SubscriptionCatalogItemDto {
  /// Subscription identifier.
  final int id;

  /// Subscription backend name.
  final String name;

  /// Subscription description.
  final String description;

  /// Subscription image path or URL.
  final String image;

  /// Subscription price.
  final String price;

  /// Subscription duration in days.
  @JsonKey(name: 'duration_days')
  final int durationDays;

  /// Whether the subscription is active in the catalog.
  @JsonKey(name: 'is_active')
  final bool isActive;

  /// Creates an instance of [SubscriptionCatalogItemDto].
  SubscriptionCatalogItemDto({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.durationDays,
    required this.isActive,
  });

  /// Creates a [SubscriptionCatalogItemDto] from JSON.
  factory SubscriptionCatalogItemDto.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionCatalogItemDtoFromJson(json);
}
