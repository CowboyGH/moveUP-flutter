import 'package:equatable/equatable.dart';

import 'workout_execution_step.dart';

/// Payload returned after entering workout execution.
final class WorkoutExecutionStart extends Equatable {
  /// User workout identifier used by follow-up execution requests.
  final int userWorkoutId;

  /// First current step for the execution screen.
  final WorkoutExecutionStep currentStep;

  /// Creates an instance of [WorkoutExecutionStart].
  const WorkoutExecutionStart({
    required this.userWorkoutId,
    required this.currentStep,
  });

  @override
  List<Object?> get props => [userWorkoutId, currentStep];
}
