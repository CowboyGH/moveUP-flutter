import 'package:json_annotation/json_annotation.dart';

import 'test_attempt_testing_dto.dart';
import 'testing_exercise_dto.dart';

part 'start_test_data_dto.g.dart';

/// DTO payload returned when an authenticated test attempt is started.
@JsonSerializable(createToJson: false)
class StartTestDataDto {
  /// Authenticated attempt identifier.
  @JsonKey(name: 'attempt_id')
  final int attemptId;

  /// Testing summary.
  final TestAttemptTestingDto testing;

  /// Current exercise returned by the backend.
  @JsonKey(name: 'current_exercise')
  final TestingExerciseDto currentExercise;

  /// Creates an instance of [StartTestDataDto].
  StartTestDataDto({
    required this.attemptId,
    required this.testing,
    required this.currentExercise,
  });

  /// Creates a [StartTestDataDto] from JSON.
  factory StartTestDataDto.fromJson(Map<String, dynamic> json) => _$StartTestDataDtoFromJson(json);
}
