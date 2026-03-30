import 'package:json_annotation/json_annotation.dart';

part 'profile_workout_history_item_dto.g.dart';

/// DTO with focused workouts payload from `/profile`.
@JsonSerializable(createToJson: false)
class ProfileWorkoutsDto {
  /// Workout history items.
  @JsonKey(defaultValue: <ProfileWorkoutHistoryItemDto>[])
  final List<ProfileWorkoutHistoryItemDto> history;

  /// Creates an instance of [ProfileWorkoutsDto].
  ProfileWorkoutsDto({
    required this.history,
  });

  /// Creates a [ProfileWorkoutsDto] from JSON.
  factory ProfileWorkoutsDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileWorkoutsDtoFromJson(json);
}

/// DTO for the latest workout history snapshot returned by `/profile`.
@JsonSerializable(createToJson: false)
class ProfileWorkoutHistoryItemDto {
  /// History item identifier.
  final int id;

  /// Nested workout reference.
  final ProfileWorkoutHistoryWorkoutDto workout;

  /// Raw completion timestamp.
  @JsonKey(name: 'completed_at')
  final String completedAt;

  /// Optional duration in minutes.
  @JsonKey(name: 'duration_minutes')
  final int? durationMinutes;

  /// Creates an instance of [ProfileWorkoutHistoryItemDto].
  ProfileWorkoutHistoryItemDto({
    required this.id,
    required this.workout,
    required this.completedAt,
    required this.durationMinutes,
  });

  /// Creates a [ProfileWorkoutHistoryItemDto] from JSON.
  factory ProfileWorkoutHistoryItemDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileWorkoutHistoryItemDtoFromJson(json);
}

/// DTO with workout title info inside profile history.
@JsonSerializable(createToJson: false)
class ProfileWorkoutHistoryWorkoutDto {
  /// Workout identifier.
  final int id;

  /// Workout title.
  final String title;

  /// Creates an instance of [ProfileWorkoutHistoryWorkoutDto].
  ProfileWorkoutHistoryWorkoutDto({
    required this.id,
    required this.title,
  });

  /// Creates a [ProfileWorkoutHistoryWorkoutDto] from JSON.
  factory ProfileWorkoutHistoryWorkoutDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileWorkoutHistoryWorkoutDtoFromJson(json);
}
