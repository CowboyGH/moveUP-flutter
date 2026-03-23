part of 'weekly_goal_cubit.dart';

/// States for [WeeklyGoalCubit].
@freezed
class WeeklyGoalState with _$WeeklyGoalState {
  /// Initial idle state before weekly-goal submit.
  const factory WeeklyGoalState.initial() = _Initial;

  /// State emitted while weekly-goal submit is in progress.
  const factory WeeklyGoalState.inProgress() = _InProgress;

  /// State emitted when weekly-goal submit succeeds.
  const factory WeeklyGoalState.succeed() = _Succeed;

  /// State emitted when weekly-goal submit fails.
  const factory WeeklyGoalState.failed(PhasesFailure failure) = _Failed;
}
