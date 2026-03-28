import '../../../constants/app_strings.dart';
import '../../app_failure.dart';

/// Workouts application error.
sealed class WorkoutsFailure extends AppFailure {
  /// Creates an instance of [WorkoutsFailure].
  const WorkoutsFailure(
    super.message, {
    super.parentException,
    super.stackTrace,
  });
}

/// Workouts request failed because of infrastructure or network conditions.
final class WorkoutsRequestFailure extends WorkoutsFailure {
  /// Creates an instance of [WorkoutsRequestFailure].
  const WorkoutsRequestFailure(
    super.message, {
    super.parentException,
    super.stackTrace,
  });
}

/// Workouts failure emitted when user tries to start a new workout while another one is active.
final class ActiveWorkoutExistsFailure extends WorkoutsFailure {
  /// Creates an instance of [ActiveWorkoutExistsFailure].
  const ActiveWorkoutExistsFailure({
    super.parentException,
    super.stackTrace,
  }) : super(AppStrings.workoutsActiveWorkoutExists);
}

/// Unknown workouts failure.
final class UnknownWorkoutsFailure extends WorkoutsFailure {
  /// Creates an instance of [UnknownWorkoutsFailure].
  const UnknownWorkoutsFailure({
    super.parentException,
    super.stackTrace,
  }) : super(AppStrings.workoutsUnknown);
}
