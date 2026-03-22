import 'package:equatable/equatable.dart';

import 'testing_exercise.dart';

/// Payload returned after saving a single exercise result.
final class TestAttemptResult extends Equatable {
  /// Next exercise, if the testing should continue.
  final TestingExercise? nextExercise;

  /// Whether all exercises are completed and pulse input is required.
  final bool isAwaitingPulse;

  /// Creates an instance of [TestAttemptResult].
  const TestAttemptResult({
    required this.nextExercise,
    required this.isAwaitingPulse,
  });

  @override
  List<Object?> get props => [nextExercise, isAwaitingPulse];
}
