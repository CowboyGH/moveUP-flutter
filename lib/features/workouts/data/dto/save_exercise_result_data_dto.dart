import 'package:json_annotation/json_annotation.dart';

import 'workout_execution_step_data_dto.dart';

part 'save_exercise_result_data_dto.g.dart';

/// DTO payload returned after saving a workout exercise result.
@JsonSerializable(createToJson: false)
class SaveExerciseResultDataDto {
  /// Saved exercise result with analysis payload.
  @JsonKey(name: 'exercise_result')
  final SaveExerciseResultExerciseResultDto? exerciseResult;

  /// Next exercise payload, if the workout should continue.
  @JsonKey(name: 'next_exercise')
  final WorkoutExecutionStepDataDto? nextExercise;

  /// Whether all exercises are completed and the workout should be finalized.
  @JsonKey(name: 'all_exercises_completed', defaultValue: false)
  final bool allExercisesCompleted;

  /// Creates an instance of [SaveExerciseResultDataDto].
  SaveExerciseResultDataDto({
    required this.exerciseResult,
    required this.nextExercise,
    required this.allExercisesCompleted,
  });

  /// Creates a [SaveExerciseResultDataDto] from JSON.
  factory SaveExerciseResultDataDto.fromJson(Map<String, dynamic> json) =>
      _$SaveExerciseResultDataDtoFromJson(json);
}

/// DTO for the saved exercise result payload.
@JsonSerializable(createToJson: false)
class SaveExerciseResultExerciseResultDto {
  /// Load adjustment payload returned by backend.
  final SaveExerciseResultAdjustmentDto? adjustments;

  /// Creates an instance of [SaveExerciseResultExerciseResultDto].
  SaveExerciseResultExerciseResultDto({required this.adjustments});

  /// Creates a [SaveExerciseResultExerciseResultDto] from JSON.
  factory SaveExerciseResultExerciseResultDto.fromJson(Map<String, dynamic> json) =>
      _$SaveExerciseResultExerciseResultDtoFromJson(json);
}

/// DTO for workout load adjustments returned after saving an exercise result.
@JsonSerializable(createToJson: false)
class SaveExerciseResultAdjustmentDto {
  /// Whether the backend actually applied a load adjustment.
  @JsonKey(defaultValue: false)
  final bool applied;

  /// Adjustment type, for example `increase` or `decrease`.
  final String? type;

  /// Adjustment percent.
  final int? percent;

  /// Previous suggested weight.
  @JsonKey(name: 'old_weight')
  final double? oldWeight;

  /// Next suggested weight.
  @JsonKey(name: 'new_weight')
  final double? newWeight;

  /// Creates an instance of [SaveExerciseResultAdjustmentDto].
  SaveExerciseResultAdjustmentDto({
    required this.applied,
    required this.type,
    required this.percent,
    required this.oldWeight,
    required this.newWeight,
  });

  /// Creates a [SaveExerciseResultAdjustmentDto] from JSON.
  factory SaveExerciseResultAdjustmentDto.fromJson(Map<String, dynamic> json) =>
      _$SaveExerciseResultAdjustmentDtoFromJson(json);
}
