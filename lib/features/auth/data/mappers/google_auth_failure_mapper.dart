import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/failures/feature/auth/auth_failure.dart';

/// Extension for converting [GoogleSignInException] to domain [AuthFailure].
extension GoogleAuthFailureMapper on GoogleSignInException {
  /// Converts [GoogleSignInException] to domain [AuthFailure].
  ///
  /// Returns a specific [AuthFailure] subclass based on the Google Sign In error code,
  /// or [UnknownAuthFailure] for unmapped error codes.
  AuthFailure toAuthFailure([StackTrace? stackTrace]) {
    return switch (code) {
      GoogleSignInExceptionCode.canceled => OperationCancelledFailure(
        parentException: this,
        stackTrace: stackTrace,
      ),
      GoogleSignInExceptionCode.interrupted => OperationInterruptedFailure(
        parentException: this,
        stackTrace: stackTrace,
      ),
      GoogleSignInExceptionCode.clientConfigurationError => ClientConfigurationFailure(
        parentException: this,
        stackTrace: stackTrace,
      ),
      GoogleSignInExceptionCode.providerConfigurationError => ProviderConfigurationFailure(
        parentException: this,
        stackTrace: stackTrace,
      ),
      GoogleSignInExceptionCode.uiUnavailable => UIUnavailableFailure(
        parentException: this,
        stackTrace: stackTrace,
      ),
      GoogleSignInExceptionCode.userMismatch => UserMismatchFailure(
        parentException: this,
        stackTrace: stackTrace,
      ),
      GoogleSignInExceptionCode.unknownError => UnknownAuthFailure(
        'unknownError',
        originalMessage: description,
        parentException: this,
        stackTrace: stackTrace,
      ),
    };
  }
}
