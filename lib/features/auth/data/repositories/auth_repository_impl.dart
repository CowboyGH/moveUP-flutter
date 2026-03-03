import '../../../../core/failures/feature/auth/auth_failure.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

/// Implementation of [AuthRepository].
final class AuthRepositoryImpl implements AuthRepository {
  /// Logger for tracking authentication operations and errors.
  final AppLogger _logger;

  /// API client for making authentication requests to the backend.
  final AuthApiClient _apiClient;

  /// Secure storage for persisting auth access tokens.
  final TokenStorage _tokenStorage;

  /// Creates an instance of [AuthRepositoryImpl].
  AuthRepositoryImpl(this._logger, this._apiClient, this._tokenStorage);

  @override
  Future<Result<User, AuthFailure>> signIn(String email, String password) {
    // TODO: implement signIn
    throw UnimplementedError();
  }
}
