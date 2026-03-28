import 'package:json_annotation/json_annotation.dart';

part 'warmup_item_dto.g.dart';

/// DTO for a warmup item inside workout details response.
@JsonSerializable(createToJson: false)
class WarmupItemDto {
  /// Warmup identifier.
  final int id;

  /// Warmup title.
  final String name;

  /// Warmup description.
  final String description;

  /// Warmup image path or URL.
  final String? image;

  /// Warmup duration in seconds.
  @JsonKey(name: 'duration_seconds')
  final int durationSeconds;

  /// Whether this warmup is the last warmup step.
  @JsonKey(name: 'is_last', defaultValue: false)
  final bool isLast;

  /// Creates an instance of [WarmupItemDto].
  WarmupItemDto({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.durationSeconds,
    required this.isLast,
  });

  /// Creates a [WarmupItemDto] from JSON.
  factory WarmupItemDto.fromJson(Map<String, dynamic> json) => _$WarmupItemDtoFromJson(json);
}
