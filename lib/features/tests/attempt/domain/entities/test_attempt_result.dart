import 'package:equatable/equatable.dart';

import 'testing_exercise.dart';

/// Payload returned after saving a single exercise result.
final class TestAttemptResult extends Equatable {
  /// Whether the backend stored the result.
  final bool saved;

  /// Exercise identifier for the saved result.
  final int testingExerciseId;

  /// Stored result value.
  final int resultValue;

  /// Next exercise, if the testing should continue.
  final TestingExercise? nextExercise;

  /// Whether all exercises are completed and pulse input is required.
  final bool isAwaitingPulse;

  /// Creates an instance of [TestAttemptResult].
  const TestAttemptResult({
    required this.saved,
    required this.testingExerciseId,
    required this.resultValue,
    required this.nextExercise,
    required this.isAwaitingPulse,
  });

  @override
  List<Object?> get props => [saved, testingExerciseId, resultValue, nextExercise, isAwaitingPulse];
}
