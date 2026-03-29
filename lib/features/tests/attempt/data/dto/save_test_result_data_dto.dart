import 'package:json_annotation/json_annotation.dart';

import 'testing_exercise_dto.dart';

part 'save_test_result_data_dto.g.dart';

/// DTO payload returned after saving exercise result.
@JsonSerializable(createToJson: false)
class SaveTestResultDataDto {
  /// Whether the result was saved successfully.
  final bool saved;

  /// Next exercise returned by the backend, if any.
  @JsonKey(name: 'next_exercise')
  final TestingExerciseDto? nextExercise;

  /// Whether all exercises are completed.
  @JsonKey(name: 'all_exercises_completed')
  final bool? allExercisesCompleted;

  /// Creates an instance of [SaveTestResultDataDto].
  SaveTestResultDataDto({
    required this.saved,
    required this.nextExercise,
    required this.allExercisesCompleted,
  });

  /// Creates a [SaveTestResultDataDto] from JSON.
  factory SaveTestResultDataDto.fromJson(Map<String, dynamic> json) =>
      _$SaveTestResultDataDtoFromJson(json);
}
