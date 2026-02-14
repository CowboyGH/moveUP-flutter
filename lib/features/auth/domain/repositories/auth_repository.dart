import '../../../../core/failures/feature/auth/auth_failure.dart';
import '../../../../core/result/result.dart';
import '../entities/user.dart';

/// Repository interface for authentication operations.
abstract interface class AuthRepository {
  /// Signs in a user with email and password.
  Future<Result<User, AuthFailure>> signInWithEmail(String email, String password);

  /// Creates a new user account with email and password.
  Future<Result<User, AuthFailure>> signUpWithEmail(String email, String password);

  /// Signs out the currently authenticated user.
  Future<Result<void, AuthFailure>> signOut();

  /// Stream of authentication state changes.
  /// Emits [User] when signed in, `null` when signed out.
  Stream<User?> get authStateChanges;
}
