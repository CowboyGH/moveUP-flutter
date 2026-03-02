import 'package:json_annotation/json_annotation.dart';

part 'user_dto.g.dart';

/// DTO for User information.
@JsonSerializable()
class UserDto {
  /// Unique identifier for the user.
  final int id;

  /// Name of the user.
  final String name;

  /// Email address of the user.
  final String email;

  /// Role identifier for the user.
  @JsonKey(name: 'role_id')
  final int roleId;

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
    required this.roleId,
    required this.updatedAt,
    required this.createdAt,
  });

  /// Creates a [UserDto] instance from a JSON map.
  factory UserDto.fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);

  /// Converts the [UserDto] instance to a JSON map.
  Map<String, dynamic> toJson() => _$UserDtoToJson(this);
}
