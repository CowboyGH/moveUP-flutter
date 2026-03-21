import 'package:json_annotation/json_annotation.dart';

part 'test_exercise_result_dto.g.dart';

/// DTO that describes stored guest exercise result.
@JsonSerializable(createToJson: false)
class TestExerciseResultDto {
  /// Exercise identifier inside the testing.
  @JsonKey(name: 'testing_exercise_id')
  final int testingExerciseId;

  /// Saved result value.
  @JsonKey(name: 'result_value')
  final int resultValue;

  /// Creates an instance of [TestExerciseResultDto].
  TestExerciseResultDto({
    required this.testingExerciseId,
    required this.resultValue,
  });

  /// Creates a [TestExerciseResultDto] from JSON.
  factory TestExerciseResultDto.fromJson(Map<String, dynamic> json) =>
      _$TestExerciseResultDtoFromJson(json);
}
