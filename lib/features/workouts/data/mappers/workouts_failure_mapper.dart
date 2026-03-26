import '../../../../core/failures/feature/workouts/workouts_failure.dart';
import '../../../../core/failures/network/network_failure.dart';

/// Extension to map [NetworkFailure] into [WorkoutsFailure].
extension WorkoutsFailureMapper on NetworkFailure {
  /// Maps a [NetworkFailure] into a workouts-specific failure.
  WorkoutsFailure toWorkoutsFailure() {
    switch (code) {
      case 'validation_failed':
        return WorkoutsRequestFailure(
          message,
          parentException: parentException,
          stackTrace: stackTrace,
        );
    }

    return switch (this) {
      NoNetworkFailure() ||
      ConnectionTimeoutFailure() ||
      BadRequestFailure() ||
      UnauthorizedFailure() ||
      ForbiddenFailure() ||
      NotFoundFailure() ||
      ConflictFailure() ||
      RateLimitedFailure() ||
      ServerErrorFailure() ||
      UnknownNetworkFailure() => WorkoutsRequestFailure(
        message,
        parentException: parentException,
        stackTrace: stackTrace,
      ),
      _ => UnknownWorkoutsFailure(
        parentException: parentException,
        stackTrace: stackTrace,
      ),
    };
  }
}
