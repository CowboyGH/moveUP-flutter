import 'package:json_annotation/json_annotation.dart';

part 'warmup_item_dto.g.dart';

/// DTO for a warmup item inside workout details response.
@JsonSerializable(createToJson: false)
class WarmupItemDto {
  /// Warmup title.
  final String name;

  /// Warmup description.
  final String description;

  /// Warmup image path or URL.
  final String? image;

  /// Warmup duration in seconds.
  @JsonKey(name: 'duration_seconds')
  final int durationSeconds;

  /// Creates an instance of [WarmupItemDto].
  WarmupItemDto({
    required this.name,
    required this.description,
    required this.image,
    required this.durationSeconds,
  });

  /// Creates a [WarmupItemDto] from JSON.
  factory WarmupItemDto.fromJson(Map<String, dynamic> json) => _$WarmupItemDtoFromJson(json);
}
