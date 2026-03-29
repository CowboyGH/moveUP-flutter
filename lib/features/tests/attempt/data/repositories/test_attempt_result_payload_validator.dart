import '../dto/save_test_result_data_dto.dart';

/// Validates that a test-result payload has either a next exercise or a completion flag.
bool isValidTestAttemptResultPayload(SaveTestResultDataDto payload) {
  if (!payload.saved) return false;

  final hasNextExercise = payload.nextExercise != null;
  final isCompleted = payload.allExercisesCompleted == true;

  if (hasNextExercise) {
    return !isCompleted;
  }

  return isCompleted;
}
