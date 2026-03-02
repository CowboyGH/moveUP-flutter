import 'package:json_annotation/json_annotation.dart';

part 'user_dto.g.dart';

/// DTO for user information.
@JsonSerializable(createToJson: false)
class UserDto {
  /// Unique identifier for the user.
  final int id;

  /// Name of the user.
  final String name;

  /// Email address of the user.
  final String email;

  /// Avatar of the user.
  final String? avatar;

  /// Role identifier for the user.
  @JsonKey(name: 'role_id')
  final int roleId;

  /// Timestamp of the user email verification.
  @JsonKey(name: 'email_verified_at')
  final String emailVerifiedAt;

  /// Timestamp of the last update to the user information.
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  /// Timestamp of when the user was created.
  @JsonKey(name: 'created_at')
  final String createdAt;

  /// Creates an instance of [UserDto].
  UserDto({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.roleId,
    required this.emailVerifiedAt,
    required this.updatedAt,
    required this.createdAt,
  });

  /// Creates a [UserDto] instance from a JSON map.
  factory UserDto.fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);
}
