import '../../../../core/failures/feature/profile/profile_failure.dart';
import '../../../../core/result/result.dart';
import '../../../auth/domain/entities/user.dart';

/// Repository interface for authenticated profile operations.
abstract interface class ProfileRepository {
  /// Returns the current authenticated user from the profile payload.
  Future<Result<User, ProfileFailure>> getUser();

  /// Updates the current user profile and returns the canonical refreshed user payload.
  Future<Result<User, ProfileFailure>> updateUser({
    required User currentUser,
    required String name,
    required String email,
    String? avatarPath,
  });

  /// Changes the current authenticated user password.
  Future<Result<void, ProfileFailure>> changePassword({
    required String oldPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  });
}
