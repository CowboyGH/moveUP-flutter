import '../../../../core/failures/feature/fitness_start/fitness_start_failure.dart';
import '../../../../core/failures/network/network_failure.dart';

/// Extension to map [NetworkFailure] into [FitnessStartFailure].
extension FitnessStartFailureMapper on NetworkFailure {
  /// Maps a [NetworkFailure] into a Fitness Start-specific failure.
  FitnessStartFailure toFitnessStartFailure() {
    final fieldErrors = switch (this) {
      ValidationFailure(:final errors) => errors,
      _ => const <String, List<String>>{},
    };
    final validationMessage = _buildValidationMessage(fieldErrors);

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

// TODO: move to core helpers next time
String _buildValidationMessage(Map<String, List<String>> rawFieldErrors) {
  final messages = rawFieldErrors.values
      .expand((fieldMessages) => fieldMessages)
      .map((message) => message.trim())
      .where((message) => message.isNotEmpty)
      .toList(growable: false);

  if (messages.isEmpty) {
    return const FitnessStartValidationFailure().message;
  }

  return messages.join('\n');
}
