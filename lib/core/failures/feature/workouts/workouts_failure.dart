import '../../../constants/app_strings.dart';
import '../../app_failure.dart';

/// Workouts overview application error.
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

/// Unknown workouts failure.
final class UnknownWorkoutsFailure extends WorkoutsFailure {
  /// Creates an instance of [UnknownWorkoutsFailure].
  const UnknownWorkoutsFailure({
    super.parentException,
    super.stackTrace,
  }) : super(AppStrings.workoutsUnknown);
}
