import 'package:json_annotation/json_annotation.dart';

import 'workout_summary_dto.dart';

part 'user_workout_overview_item_dto.g.dart';

/// DTO for a user workout item in the workouts overview response.
@JsonSerializable(createToJson: false)
class UserWorkoutOverviewItemDto {
  /// User workout identifier.
  @JsonKey(name: 'user_workout_id')
  final int userWorkoutId;

  /// Workout summary payload.
  final WorkoutSummaryDto workout;

  /// Current workout status.
  final String status;

  /// Creates an instance of [UserWorkoutOverviewItemDto].
  UserWorkoutOverviewItemDto({
    required this.userWorkoutId,
    required this.workout,
    required this.status,
  });

  /// Creates a [UserWorkoutOverviewItemDto] from JSON.
  factory UserWorkoutOverviewItemDto.fromJson(Map<String, dynamic> json) =>
      _$UserWorkoutOverviewItemDtoFromJson(json);
}
