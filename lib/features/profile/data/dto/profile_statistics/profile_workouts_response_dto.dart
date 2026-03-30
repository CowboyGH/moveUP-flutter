import 'package:json_annotation/json_annotation.dart';

part 'profile_workouts_response_dto.g.dart';

/// DTO response with available profile statistics workouts.
@JsonSerializable(createToJson: false)
class ProfileWorkoutsResponseDto {
  /// Workouts selector payload.
  final List<ProfileWorkoutItemDto> data;

  /// Creates an instance of [ProfileWorkoutsResponseDto].
  ProfileWorkoutsResponseDto({
    required this.data,
  });

  /// Creates a [ProfileWorkoutsResponseDto] from JSON.
  factory ProfileWorkoutsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileWorkoutsResponseDtoFromJson(json);
}

/// DTO item for the profile workouts selector.
@JsonSerializable(createToJson: false)
class ProfileWorkoutItemDto {
  /// Profile workout item identifier.
  final int id;

  /// Workout catalog identifier.
  @JsonKey(name: 'workout_id')
  final int workoutId;

  /// Workout title.
  final String title;

  /// Raw completed date.
  @JsonKey(name: 'completed_at')
  final String? completedAt;

  /// Formatted completed date.
  @JsonKey(name: 'completed_at_formatted')
  final String? completedAtFormatted;

  /// Workout duration in minutes.
  @JsonKey(name: 'duration_minutes')
  final int? durationMinutes;

  /// Creates an instance of [ProfileWorkoutItemDto].
  ProfileWorkoutItemDto({
    required this.id,
    required this.workoutId,
    required this.title,
    required this.completedAt,
    required this.completedAtFormatted,
    required this.durationMinutes,
  });

  /// Creates a [ProfileWorkoutItemDto] from JSON.
  factory ProfileWorkoutItemDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileWorkoutItemDtoFromJson(json);
}
