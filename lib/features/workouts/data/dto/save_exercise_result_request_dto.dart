import 'package:json_annotation/json_annotation.dart';

part 'save_exercise_result_request_dto.g.dart';

/// Request DTO for saving a workout exercise result.
@JsonSerializable()
class SaveExerciseResultRequestDto {
  /// Exercise identifier.
  @JsonKey(name: 'exercise_id')
  final int exerciseId;

  /// User reaction for the exercise.
  final String reaction;

  /// Weight used during the exercise, if any.
  @JsonKey(name: 'weight_used', includeIfNull: false)
  final double? weightUsed;

  /// Creates an instance of [SaveExerciseResultRequestDto].
  SaveExerciseResultRequestDto({
    required this.exerciseId,
    required this.reaction,
    this.weightUsed,
  });

  /// Serializes this request into JSON.
  Map<String, dynamic> toJson() => _$SaveExerciseResultRequestDtoToJson(this);
}
