import '../../../../core/failures/feature/auth/auth_failure.dart';
import '../../../../core/result/result.dart';
import '../entities/user.dart';

/// Repository interface for authentication operations.
abstract interface class AuthRepository {
  /// Signs in a user with email and password.
  Future<Result<User, AuthFailure>> signIn(String email, String password);

  /// Signs up a user with name, email and password.
  Future<Result<User, AuthFailure>> signUp(String name, String email, String password);

  /// Verifies user email by OTP code.
  Future<Result<User, AuthFailure>> verifyEmail(String email, String code);

  /// Returns current authorized user.
  Future<Result<User, AuthFailure>> getCurrentUser();
}
