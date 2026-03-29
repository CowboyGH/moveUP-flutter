import 'package:json_annotation/json_annotation.dart';

part 'profile_user_dto.g.dart';

/// DTO for the authenticated profile user payload.
@JsonSerializable(createToJson: false)
class ProfileUserDto {
  /// Unique identifier for the user.
  final int id;

  /// Name of the user.
  final String name;

  /// Email address of the user.
  final String email;

  /// Public avatar URL.
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;

  /// Account creation timestamp.
  @JsonKey(name: 'created_at')
  final String createdAt;

  /// Whether the email is verified.
  @JsonKey(name: 'email_verified')
  final bool emailVerified;

  /// Creates an instance of [ProfileUserDto].
  ProfileUserDto({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.createdAt,
    required this.emailVerified,
  });

  /// Creates a [ProfileUserDto] from JSON.
  factory ProfileUserDto.fromJson(Map<String, dynamic> json) => _$ProfileUserDtoFromJson(json);
}
