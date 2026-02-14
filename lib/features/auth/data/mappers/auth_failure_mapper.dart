import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/failures/feature/auth/auth_failure.dart';

/// Extension for converting [FirebaseAuthException] to domain [AuthFailure].
extension AuthFailureMapper on FirebaseAuthException {
  /// Converts [FirebaseAuthException] to domain [AuthFailure].
  ///
  /// Returns a specific [AuthFailure] subclass based on the Firebase error code,
  /// or [UnknownAuthFailure] for unmapped error codes.
  AuthFailure toAuthFailure([StackTrace? stackTrace]) {
    return switch (code) {
      'invalid-credential' => InvalidCredentialFailure(
        parentException: this,
        stackTrace: stackTrace,
      ),
      'weak-password' => WeakPasswordFailure(
        parentException: this,
        stackTrace: stackTrace,
      ),
      'wrong-password' => WrongPasswordFailure(
        parentException: this,
        stackTrace: stackTrace,
      ),
      'invalid-email' => InvalidEmailFailure(
        parentException: this,
        stackTrace: stackTrace,
      ),
      'email-already-in-use' => EmailAlreadyInUseFailure(
        parentException: this,
        stackTrace: stackTrace,
      ),
      'user-disabled' => UserDisabledFailure(
        parentException: this,
        stackTrace: stackTrace,
      ),
      'user-token-expired' => UserTokenExpiredFailure(
        parentException: this,
        stackTrace: stackTrace,
      ),
      'user-not-found' => UserNotFoundFailure(
        parentException: this,
        stackTrace: stackTrace,
      ),
      'operation-not-allowed' => OperationNotAllowed(
        parentException: this,
        stackTrace: stackTrace,
      ),
      'too-many-requests' => TooManyRequestsFailure(
        parentException: this,
        stackTrace: stackTrace,
      ),
      'network-request-failed' => NetworkRequestFailedFailure(
        parentException: this,
        stackTrace: stackTrace,
      ),
      _ => UnknownAuthFailure(
        code,
        originalMessage: message,
        parentException: this,
        stackTrace: stackTrace,
      ),
    };
  }
}
