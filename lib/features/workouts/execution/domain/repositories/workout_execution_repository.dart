import '../../../../../core/failures/feature/workouts/workouts_failure.dart';
import '../../../../../core/result/result.dart';
import '../entities/workout_execution_entry_mode.dart';
import '../entities/workout_execution_result.dart';
import '../entities/workout_execution_start.dart';
import '../entities/workout_execution_step.dart';
import '../entities/workout_exercise_reaction.dart';

/// Repository contract for authenticated workout execution flow.
abstract interface class WorkoutExecutionRepository {
  /// Starts workout execution from the provided [entryMode].
  Future<Result<WorkoutExecutionStart, WorkoutsFailure>> startExecution({
    required int userWorkoutId,
    required WorkoutExecutionEntryMode entryMode,
  });

  /// Returns the next warmup step or the first workout exercise.
  Future<Result<WorkoutExecutionStep, WorkoutsFailure>> nextWarmup({
    required int userWorkoutId,
    required int currentWarmupId,
  });

  /// Completes warmup flow early and returns the first workout exercise.
  Future<Result<WorkoutExerciseStep, WorkoutsFailure>> skipWarmup(int userWorkoutId);

  /// Saves the current exercise reaction and returns workout continuation data.
  Future<Result<WorkoutExecutionResult, WorkoutsFailure>> saveExerciseResult({
    required int userWorkoutId,
    required int exerciseId,
    required WorkoutExerciseReaction reaction,
    double? weightUsed,
  });

  /// Completes the current workout.
  Future<Result<void, WorkoutsFailure>> completeWorkout(int userWorkoutId);
}
