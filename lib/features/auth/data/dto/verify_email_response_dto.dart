import 'package:json_annotation/json_annotation.dart';

import 'user_dto.dart';

part 'verify_email_response_dto.g.dart';

/// DTO for verify email response.
@JsonSerializable(createToJson: false)
class VerifyEmailResponseDto {
  /// Indicates whether verify email request succeeded.
  final bool success;

  /// Backend message about verification result.
  final String message;

  /// JWT access token.
  @JsonKey(name: 'access_token')
  final String accessToken;

  /// Type of token, usually `bearer`.
  @JsonKey(name: 'token_type')
  final String tokenType;

  /// Access token lifetime in seconds.
  @JsonKey(name: 'expires_in')
  final int expiresIn;

  /// Verified user.
  final UserDto user;

  /// Creates an instance of [VerifyEmailResponseDto].
  VerifyEmailResponseDto({
    required this.success,
    required this.message,
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.user,
  });

  /// Creates a [VerifyEmailResponseDto] from JSON.
  factory VerifyEmailResponseDto.fromJson(Map<String, dynamic> json) =>
      _$VerifyEmailResponseDtoFromJson(json);
}
