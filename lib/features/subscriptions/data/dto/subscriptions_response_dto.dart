import 'package:json_annotation/json_annotation.dart';

import 'subscription_catalog_item_dto.dart';

part 'subscriptions_response_dto.g.dart';

/// DTO for subscriptions response envelope.
@JsonSerializable(createToJson: false)
class SubscriptionsResponseDto {
  /// Subscriptions payload.
  final List<SubscriptionCatalogItemDto> data;

  /// Creates an instance of [SubscriptionsResponseDto].
  SubscriptionsResponseDto({required this.data});

  /// Creates a [SubscriptionsResponseDto] from JSON.
  factory SubscriptionsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionsResponseDtoFromJson(json);
}
