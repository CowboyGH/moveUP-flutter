import 'package:json_annotation/json_annotation.dart';

import 'save_exercise_result_data_dto.dart';

part 'save_exercise_result_response_dto.g.dart';

/// DTO response envelope for saving a workout exercise result.
@JsonSerializable(createToJson: false)
class SaveExerciseResultResponseDto {
  /// Save-result payload.
  final SaveExerciseResultDataDto data;

  /// Creates an instance of [SaveExerciseResultResponseDto].
  SaveExerciseResultResponseDto({required this.data});

  /// Creates a [SaveExerciseResultResponseDto] from JSON.
  factory SaveExerciseResultResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SaveExerciseResultResponseDtoFromJson(json);
}
