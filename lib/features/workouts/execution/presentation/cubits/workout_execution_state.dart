part of 'workout_execution_cubit.dart';

/// State for [WorkoutExecutionCubit].
@freezed
abstract class WorkoutExecutionState with _$WorkoutExecutionState {
  /// Creates an instance of [WorkoutExecutionState].
  const factory WorkoutExecutionState({
    @Default(false) bool isStarting,
    @Default(false) bool isAdvancingWarmup,
    @Default(false) bool isSubmittingResult,
    @Default(false) bool isCompleting,
    @Default(false) bool isAbandoning,
    int? userWorkoutId,
    WorkoutExecutionStep? currentStep,
    WorkoutsFailure? failure,
    @Default(false) bool isCompleted,
    @Default(false) bool shouldPopToDetails,
  }) = _WorkoutExecutionState;
}
