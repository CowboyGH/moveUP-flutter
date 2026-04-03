import 'package:json_annotation/json_annotation.dart';

import 'subscription_catalog_item_dto.dart';

part 'subscription_response_dto.g.dart';

/// DTO for a single subscription response envelope.
@JsonSerializable(createToJson: false)
class SubscriptionResponseDto {
  /// Subscription payload.
  final SubscriptionCatalogItemDto data;

  /// Creates an instance of [SubscriptionResponseDto].
  SubscriptionResponseDto({required this.data});

  /// Creates a [SubscriptionResponseDto] from JSON.
  factory SubscriptionResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionResponseDtoFromJson(json);
}
