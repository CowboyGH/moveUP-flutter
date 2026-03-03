import '../../../../core/failures/feature/auth/auth_failure.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

/// Implementation of [AuthRepository].
final class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<Result<User, AuthFailure>> signIn(String email, String password) {
    // TODO: implement signIn
    throw UnimplementedError();
  }
}
