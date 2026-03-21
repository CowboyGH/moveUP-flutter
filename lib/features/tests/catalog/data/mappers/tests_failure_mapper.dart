import '../../../../../core/failures/feature/tests/tests_failure.dart';
import '../../../../../core/failures/network/network_failure.dart';

/// Extension to map [NetworkFailure] into [TestsFailure].
extension TestsFailureMapper on NetworkFailure {
  /// Maps a [NetworkFailure] into a tests-specific failure.
  TestsFailure toTestsFailure() {
    if (code == 'validation_failed') {
      return TestsValidationFailure(
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
      UnknownNetworkFailure() => TestsRequestFailure(
        message,
        parentException: parentException,
        stackTrace: stackTrace,
      ),
      _ => UnknownTestsFailure(
        parentException: parentException,
        stackTrace: stackTrace,
      ),
    };
  }
}
