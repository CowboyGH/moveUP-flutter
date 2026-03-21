import 'package:equatable/equatable.dart';

import 'test_attempt_testing.dart';
import 'testing_exercise.dart';

/// Payload returned after starting a test attempt.
final class TestAttemptStart extends Equatable {
  /// Attempt identifier.
  final String attemptId;

  /// Testing summary.
  final TestAttemptTesting testing;

  /// First current exercise.
  final TestingExercise currentExercise;

  /// Creates an instance of [TestAttemptStart].
  const TestAttemptStart({
    required this.attemptId,
    required this.testing,
    required this.currentExercise,
  });

  @override
  List<Object?> get props => [attemptId, testing, currentExercise];
}
