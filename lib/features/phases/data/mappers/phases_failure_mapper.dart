import '../../../../core/failures/feature/phases/phases_failure.dart';
import '../../../../core/failures/helpers/validation_message_builder.dart';
import '../../../../core/failures/network/network_failure.dart';

/// Extension to map [NetworkFailure] into [PhasesFailure].
extension PhasesFailureMapper on NetworkFailure {
  /// Maps a [NetworkFailure] into a phases-specific failure.
  PhasesFailure toPhasesFailure() {
    switch (code) {
      case 'validation_failed':
        final fieldErrors = switch (this) {
          ValidationFailure(:final errors) => errors,
          _ => const <String, List<String>>{},
        };
        final validationMessage = buildValidationMessage(
          fieldErrors,
          fallbackMessage: const PhasesValidationFailure().message,
        );
        return PhasesValidationFailure(
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
      UnknownNetworkFailure() => PhasesRequestFailure(
        message,
        parentException: parentException,
        stackTrace: stackTrace,
      ),
      _ => UnknownPhasesFailure(
        parentException: parentException,
        stackTrace: stackTrace,
      ),
    };
  }
}
