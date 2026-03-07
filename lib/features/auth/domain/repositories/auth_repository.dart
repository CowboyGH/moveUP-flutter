import '../../../../core/failures/feature/auth/auth_failure.dart';
import '../../../../core/result/result.dart';
import '../entities/user.dart';

/// Repository interface for authentication operations.
abstract interface class AuthRepository {
  /// Signs in a user with email and password.
  Future<Result<User, AuthFailure>> signIn(String email, String password);

  /// Signs up a user with name, email and password.
  Future<Result<User, AuthFailure>> signUp(String name, String email, String password);

  /// Requests password reset OTP for the given email.
  Future<Result<void, AuthFailure>> forgotPassword(String email);

  /// Verifies user email by OTP code.
  Future<Result<User, AuthFailure>> verifyEmail(String email, String code);

  /// Resends OTP code for auth verification flow.
  Future<Result<void, AuthFailure>> resendOtpCode(String email);

  /// Returns current authorized user.
  Future<Result<User, AuthFailure>> getCurrentUser();
}
