import 'package:json_annotation/json_annotation.dart';

import 'warmup_item_dto.dart';
import 'workout_execution_exercise_item_dto.dart';

part 'workout_execution_step_data_dto.g.dart';

/// DTO payload returned by workout execution endpoints.
@JsonSerializable(createToJson: false)
class WorkoutExecutionStepDataDto {
  /// Step type, either warmup or exercise.
  final String type;

  /// User workout identifier.
  @JsonKey(name: 'user_workout_id')
  final int? userWorkoutId;

  /// Whether UI should request a new weight value.
  @JsonKey(name: 'needs_weight_input', defaultValue: false)
  final bool needsWeightInput;

  /// Warmup payload when [type] is `warmup`.
  final WarmupItemDto? warmup;

  /// Exercise payload when [type] is `exercise`.
  final WorkoutExecutionExerciseItemDto? exercise;

  /// Creates an instance of [WorkoutExecutionStepDataDto].
  WorkoutExecutionStepDataDto({
    required this.type,
    required this.userWorkoutId,
    required this.needsWeightInput,
    required this.warmup,
    required this.exercise,
  });

  /// Creates a [WorkoutExecutionStepDataDto] from JSON.
  factory WorkoutExecutionStepDataDto.fromJson(Map<String, dynamic> json) =>
      _$WorkoutExecutionStepDataDtoFromJson(json);
}
