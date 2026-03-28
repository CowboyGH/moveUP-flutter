import 'package:json_annotation/json_annotation.dart';

import 'workout_execution_step_data_dto.dart';

part 'workout_execution_step_response_dto.g.dart';

/// DTO response envelope for workout execution step endpoints.
@JsonSerializable(createToJson: false)
class WorkoutExecutionStepResponseDto {
  /// Execution step payload.
  final WorkoutExecutionStepDataDto data;

  /// Creates an instance of [WorkoutExecutionStepResponseDto].
  WorkoutExecutionStepResponseDto({required this.data});

  /// Creates a [WorkoutExecutionStepResponseDto] from JSON.
  factory WorkoutExecutionStepResponseDto.fromJson(Map<String, dynamic> json) =>
      _$WorkoutExecutionStepResponseDtoFromJson(json);
}
