import 'package:json_annotation/json_annotation.dart';

import 'warmup_item_dto.dart';
import 'workout_summary_dto.dart';

part 'workout_details_data_dto.g.dart';

/// DTO payload returned by `GET /api/workout-execution/{userWorkout}`.
@JsonSerializable(createToJson: false)
class WorkoutDetailsDataDto {
  /// Current backend workout status.
  final String status;

  /// Main workout payload.
  final WorkoutSummaryDto workout;

  /// Warmups included in the workout details flow.
  @JsonKey(defaultValue: <WarmupItemDto>[])
  final List<WarmupItemDto> warmups;

  /// Creates an instance of [WorkoutDetailsDataDto].
  WorkoutDetailsDataDto({
    required this.status,
    required this.workout,
    required this.warmups,
  });

  /// Creates a [WorkoutDetailsDataDto] from JSON.
  factory WorkoutDetailsDataDto.fromJson(Map<String, dynamic> json) =>
      _$WorkoutDetailsDataDtoFromJson(json);
}
