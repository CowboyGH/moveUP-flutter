import '../../../../core/failures/feature/cards/cards_failure.dart';
import '../../../../core/failures/helpers/validation_message_builder.dart';
import '../../../../core/failures/network/network_failure.dart';

/// Extension to map [NetworkFailure] into [CardsFailure].
extension CardsFailureMapper on NetworkFailure {
  /// Maps a [NetworkFailure] into a cards-specific failure.
  CardsFailure toCardsFailure() {
    final fieldErrors = switch (this) {
      ValidationFailure(:final errors) => errors,
      _ => const <String, List<String>>{},
    };
    final validationMessage = buildValidationMessage(
      fieldErrors,
      fallbackMessage: const CardsValidationFailure().message,
    );

    switch (code) {
      case 'validation_failed':
        return CardsValidationFailure(
          message: validationMessage,
          parentException: parentException,
          stackTrace: stackTrace,
        );
      default:
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
          UnknownNetworkFailure() => CardsRequestFailure(
            message,
            parentException: parentException,
            stackTrace: stackTrace,
          ),
          _ => UnknownCardsFailure(
            parentException: parentException,
            stackTrace: stackTrace,
          ),
        };
    }
  }
}
