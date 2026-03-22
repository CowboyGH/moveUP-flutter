import '../../../../../core/failures/feature/tests/tests_failure.dart';
import '../../../../../core/failures/helpers/validation_message_builder.dart';
import '../../../../../core/failures/network/network_failure.dart';

/// Extension to map [NetworkFailure] into [TestsFailure].
extension TestsFailureMapper on NetworkFailure {
  /// Maps a [NetworkFailure] into a tests-specific failure.
  TestsFailure toTestsFailure() {
    final fieldErrors = switch (this) {
      ValidationFailure(:final errors) => errors,
      _ => const <String, List<String>>{},
    };
    final validationMessage = buildValidationMessage(
      fieldErrors,
      fallbackMessage: const TestsValidationFailure().message,
    );

    switch (code) {
      case 'validation_failed':
        return TestsValidationFailure(
          message: validationMessage,
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
