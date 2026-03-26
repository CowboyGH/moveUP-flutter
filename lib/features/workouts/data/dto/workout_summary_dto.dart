import 'package:json_annotation/json_annotation.dart';

part 'workout_summary_dto.g.dart';

/// DTO with workout summary fields used on the overview screen.
@JsonSerializable(createToJson: false)
class WorkoutSummaryDto {
  /// Workout identifier.
  final int id;

  /// Workout title.
  final String title;

  /// Short workout description.
  final String description;

  /// Workout duration in minutes provided by the backend.
  @JsonKey(name: 'duration_minutes')
  final String durationMinutes;

  /// Workout preview image path or URL.
  final String? image;

  /// Creates an instance of [WorkoutSummaryDto].
  WorkoutSummaryDto({
    required this.id,
    required this.title,
    required this.description,
    required this.durationMinutes,
    required this.image,
  });

  /// Creates a [WorkoutSummaryDto] from JSON.
  factory WorkoutSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$WorkoutSummaryDtoFromJson(json);
}
