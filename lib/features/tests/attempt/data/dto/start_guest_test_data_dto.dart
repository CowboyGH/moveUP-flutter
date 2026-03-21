import 'package:json_annotation/json_annotation.dart';

import 'test_attempt_testing_dto.dart';
import 'testing_exercise_dto.dart';

part 'start_guest_test_data_dto.g.dart';

/// DTO payload returned when a guest test attempt is started.
@JsonSerializable(createToJson: false)
class StartGuestTestDataDto {
  /// Guest attempt identifier.
  @JsonKey(name: 'attempt_id')
  final String attemptId;

  /// Testing summary.
  final TestAttemptTestingDto testing;

  /// Current exercise returned by the backend.
  @JsonKey(name: 'current_exercise')
  final TestingExerciseDto currentExercise;

  /// Creates an instance of [StartGuestTestDataDto].
  StartGuestTestDataDto({
    required this.attemptId,
    required this.testing,
    required this.currentExercise,
  });

  /// Creates a [StartGuestTestDataDto] from JSON.
  factory StartGuestTestDataDto.fromJson(Map<String, dynamic> json) =>
      _$StartGuestTestDataDtoFromJson(json);
}
