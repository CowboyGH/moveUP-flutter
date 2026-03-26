import 'package:json_annotation/json_annotation.dart';

import 'user_workout_overview_item_dto.dart';

part 'workouts_list_data_dto.g.dart';

/// DTO payload returned by `GET /api/workouts`.
@JsonSerializable(createToJson: false)
class WorkoutsListDataDto {
  /// Workouts that are already started.
  @JsonKey(defaultValue: <UserWorkoutOverviewItemDto>[])
  final List<UserWorkoutOverviewItemDto> started;

  /// Workouts that are assigned and available to start.
  @JsonKey(defaultValue: <UserWorkoutOverviewItemDto>[])
  final List<UserWorkoutOverviewItemDto> assigned;

  /// Whether the user has an active started workout.
  @JsonKey(name: 'has_active', defaultValue: false)
  final bool hasActive;

  /// Creates an instance of [WorkoutsListDataDto].
  WorkoutsListDataDto({
    required this.started,
    required this.assigned,
    required this.hasActive,
  });

  /// Creates a [WorkoutsListDataDto] from JSON.
  factory WorkoutsListDataDto.fromJson(Map<String, dynamic> json) =>
      _$WorkoutsListDataDtoFromJson(json);
}
