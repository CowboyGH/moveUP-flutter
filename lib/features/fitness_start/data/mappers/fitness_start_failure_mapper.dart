import '../../../../core/failures/feature/fitness_start/fitness_start_failure.dart';
import '../../../../core/failures/helpers/validation_message_builder.dart';
import '../../../../core/failures/network/network_failure.dart';

/// Extension to map [NetworkFailure] into [FitnessStartFailure].
extension FitnessStartFailureMapper on NetworkFailure {
  /// Maps a [NetworkFailure] into a Fitness Start-specific failure.
  FitnessStartFailure toFitnessStartFailure() {
    final fieldErrors = switch (this) {
      ValidationFailure(:final errors) => errors,
      _ => const <String, List<String>>{},
    };
    final validationMessage = buildValidationMessage(
      fieldErrors,
      fallbackMessage: const FitnessStartValidationFailure().message,
    );

    switch (code) {
      case 'validation_failed':
        return FitnessStartValidationFailure(
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
      UnknownNetworkFailure() => FitnessStartRequestFailure(
        message,
        parentException: parentException,
        stackTrace: stackTrace,
      ),
      _ => UnknownFitnessStartFailure(
        parentException: parentException,
        stackTrace: stackTrace,
      ),
    };
  }
}
