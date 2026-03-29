import '../../../../core/failures/feature/profile/profile_failure.dart';
import '../../../../core/failures/helpers/validation_message_builder.dart';
import '../../../../core/failures/network/network_failure.dart';

/// Extension to map [NetworkFailure] into [ProfileFailure].
extension ProfileFailureMapper on NetworkFailure {
  /// Maps a [NetworkFailure] into a profile-specific failure.
  ProfileFailure toProfileFailure() {
    final fieldErrors = switch (this) {
      ValidationFailure(:final errors) => errors,
      _ => const <String, List<String>>{},
    };
    final validationMessage = buildValidationMessage(
      fieldErrors,
      fallbackMessage: const ProfileValidationFailure().message,
    );

    switch (code) {
      case 'validation_failed':
        return ProfileValidationFailure(
          message: validationMessage,
          parentException: parentException,
          stackTrace: stackTrace,
        );
      case 'token_expired':
      case 'session_expired_inactivity':
      case 'session_expired_absolute':
      case 'unauthorized':
      default:
        return switch (this) {
          NoNetworkFailure() ||
          ConnectionTimeoutFailure() ||
          BadRequestFailure() ||
          NotFoundFailure() ||
          ConflictFailure() ||
          RateLimitedFailure() ||
          ServerErrorFailure() ||
          UnknownNetworkFailure() => ProfileRequestFailure(
            message,
            parentException: parentException,
            stackTrace: stackTrace,
          ),
          _ => UnknownProfileFailure(
            parentException: parentException,
            stackTrace: stackTrace,
          ),
        };
    }
  }
}
