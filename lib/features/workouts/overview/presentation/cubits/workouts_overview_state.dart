part of 'workouts_overview_cubit.dart';

/// States for [WorkoutsOverviewCubit].
@freezed
class WorkoutsOverviewState with _$WorkoutsOverviewState {
  /// Initial idle state before workouts loading.
  const factory WorkoutsOverviewState.initial() = _Initial;

  /// State emitted while workouts overview request is in progress.
  const factory WorkoutsOverviewState.inProgress() = _InProgress;

  /// State emitted when workouts overview loads successfully.
  const factory WorkoutsOverviewState.loaded(List<WorkoutOverviewItem> items) = _Loaded;

  /// State emitted when workouts overview loading fails.
  const factory WorkoutsOverviewState.failed(WorkoutsFailure failure) = _Failed;
}
