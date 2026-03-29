import '../../../auth/domain/entities/user.dart';
import '../dto/profile_user_dto.dart';

/// Extension to map [ProfileUserDto] into the shared auth [User] entity.
extension ProfileUserEntityMapper on ProfileUserDto {
  /// Maps [ProfileUserDto] to [User].
  User toEntity() => User(
    id: id,
    name: name,
    email: email,
    avatar: avatarUrl,
  );
}
