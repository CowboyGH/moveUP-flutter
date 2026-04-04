import '../../../../core/failures/feature/cards/cards_failure.dart';
import '../../../../core/failures/helpers/validation_message_builder.dart';
import '../../../../core/failures/network/network_failure.dart';

/// Extension to map [NetworkFailure] into [CardsFailure].
extension CardsFailureMapper on NetworkFailure {
  /// Maps a [NetworkFailure] into a cards-specific failure.
  CardsFailure toCardsFailure() {
    if (this case ValidationFailure(:final errors)) {
      final validationMessage = buildValidationMessage(
        errors,
        fallbackMessage: const CardsValidationFailure().message,
      );
      return CardsValidationFailure(
        message: validationMessage,
        parentException: parentException,
        stackTrace: stackTrace,
      );
    }
    return switch (this) {
      ValidationFailure() => CardsValidationFailure(
        parentException: parentException,
        stackTrace: stackTrace,
      ),
      const NoNetworkFailure() ||
      const ConnectionTimeoutFailure() ||
      const BadRequestFailure() ||
      const UnauthorizedFailure() ||
      const ForbiddenFailure() ||
      const NotFoundFailure() ||
      const ConflictFailure() ||
      const RateLimitedFailure() ||
      const ServerErrorFailure() ||
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
