import '../../../../../core/failures/feature/tests/tests_failure.dart';
import '../../../../../core/result/result.dart';
import '../entities/test_attempt_result.dart';
import '../entities/test_attempt_start.dart';

/// Repository contract for starting and completing test attempts.
abstract interface class TestAttemptRepository {
  /// Starts a test attempt for the given [testingId].
  Future<Result<TestAttemptStart, TestsFailure>> startTest(int testingId);

  /// Saves a result for the current exercise inside [attemptId].
  Future<Result<TestAttemptResult, TestsFailure>> saveResult({
    required String attemptId,
    required int testingExerciseId,
    required int resultValue,
  });

  /// Completes the current [attemptId] with [pulse] value.
  Future<Result<void, TestsFailure>> completeTest({
    required String attemptId,
    required int pulse,
  });
}

/// Repository contract for guest test attempts.
abstract interface class GuestTestAttemptRepository implements TestAttemptRepository {}

/// Repository contract for authenticated test attempts.
abstract interface class AuthenticatedTestAttemptRepository implements TestAttemptRepository {}
