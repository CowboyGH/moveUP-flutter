import '../../domain/entities/user.dart';
import '../dto/user_dto.dart';

/// Extension to map [UserDto] into [User].
extension UserEntityMapper on UserDto {
  /// Maps [UserDto] to the domain [User] entity.
  User toEntity() => User(
    id: id,
    name: name,
    email: email,
    avatar: avatar,
  );
}
