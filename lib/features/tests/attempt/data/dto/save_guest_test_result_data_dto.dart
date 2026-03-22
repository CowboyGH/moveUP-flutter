import 'package:json_annotation/json_annotation.dart';

import 'testing_exercise_dto.dart';

part 'save_guest_test_result_data_dto.g.dart';

/// DTO payload returned after saving guest exercise result.
@JsonSerializable(createToJson: false)
class SaveGuestTestResultDataDto {
  /// Whether the result was saved successfully.
  final bool saved;

  /// Next exercise returned by the backend, if any.
  @JsonKey(name: 'next_exercise')
  final TestingExerciseDto? nextExercise;

  /// Whether all exercises are completed.
  @JsonKey(name: 'all_exercises_completed')
  final bool? allExercisesCompleted;

  /// Creates an instance of [SaveGuestTestResultDataDto].
  SaveGuestTestResultDataDto({
    required this.saved,
    required this.nextExercise,
    required this.allExercisesCompleted,
  });

  /// Creates a [SaveGuestTestResultDataDto] from JSON.
  factory SaveGuestTestResultDataDto.fromJson(Map<String, dynamic> json) =>
      _$SaveGuestTestResultDataDtoFromJson(json);
}
