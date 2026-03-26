part of 'workout_details_cubit.dart';

/// States for [WorkoutDetailsCubit].
@freezed
class WorkoutDetailsState with _$WorkoutDetailsState {
  /// Initial idle state before workout details loading.
  const factory WorkoutDetailsState.initial() = _Initial;

  /// State emitted while workout details request is in progress.
  const factory WorkoutDetailsState.inProgress() = _InProgress;

  /// State emitted when workout details load successfully.
  const factory WorkoutDetailsState.loaded(List<WorkoutDetailsItem> items) = _Loaded;

  /// State emitted when workout details loading fails.
  const factory WorkoutDetailsState.failed(WorkoutsFailure failure) = _Failed;
}
