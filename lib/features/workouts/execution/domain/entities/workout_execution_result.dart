import 'package:equatable/equatable.dart';

import 'workout_execution_step.dart';

/// Load-adjustment payload for the next set or exercise.
final class WorkoutLoadAdjustment extends Equatable {
  /// Adjustment type, for example `increase` or `decrease`.
  final String type;

  /// Adjustment percent when backend provides it.
  final int? percent;

  /// Previous suggested weight.
  final double? oldWeight;

  /// Next suggested weight.
  final double? newWeight;

  /// Creates an instance of [WorkoutLoadAdjustment].
  const WorkoutLoadAdjustment({
    required this.type,
    required this.percent,
    required this.oldWeight,
    required this.newWeight,
  });

  @override
  List<Object?> get props => [type, percent, oldWeight, newWeight];
}

/// Payload returned after saving a workout exercise result.
final class WorkoutExecutionResult extends Equatable {
  /// Next exercise, if workout execution should continue.
  final WorkoutExerciseStep? nextExercise;

  /// Whether all exercises are completed and the workout should be finalized.
  final bool isAwaitingCompletion;

  /// Optional load-adjustment recommendation for the next set or exercise.
  final WorkoutLoadAdjustment? adjustment;

  /// Creates an instance of [WorkoutExecutionResult].
  const WorkoutExecutionResult({
    required this.nextExercise,
    required this.isAwaitingCompletion,
    required this.adjustment,
  });

  @override
  List<Object?> get props => [nextExercise, isAwaitingCompletion, adjustment];
}
