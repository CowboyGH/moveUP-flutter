import 'package:json_annotation/json_annotation.dart';

import 'test_exercise_result_dto.dart';
import 'testing_exercise_dto.dart';

part 'save_guest_test_result_data_dto.g.dart';

/// DTO payload returned after saving guest exercise result.
@JsonSerializable(createToJson: false)
class SaveGuestTestResultDataDto {
  /// Whether the result was saved successfully.
  final bool saved;

  /// Stored result metadata.
  final TestExerciseResultDto result;

  /// Next exercise returned by the backend, if any.
  @JsonKey(name: 'next_exercise')
  final TestingExerciseDto? nextExercise;

  /// Whether all exercises are completed.
  @JsonKey(name: 'all_exercises_completed')
  final bool? allExercisesCompleted;

  /// Optional backend transport message.
  final String? message;

  /// Creates an instance of [SaveGuestTestResultDataDto].
  SaveGuestTestResultDataDto({
    required this.saved,
    required this.result,
    required this.nextExercise,
    required this.allExercisesCompleted,
    required this.message,
  });

  /// Creates a [SaveGuestTestResultDataDto] from JSON.
  factory SaveGuestTestResultDataDto.fromJson(Map<String, dynamic> json) =>
      _$SaveGuestTestResultDataDtoFromJson(json);
}
