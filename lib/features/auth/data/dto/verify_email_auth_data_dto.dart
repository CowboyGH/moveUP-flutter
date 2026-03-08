import 'package:json_annotation/json_annotation.dart';

import 'user_dto.dart';

part 'verify_email_auth_data_dto.g.dart';

/// Nested auth payload for verify email response.
@JsonSerializable(createToJson: false)
class VerifyEmailAuthDataDto {
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

  /// Creates an instance of [VerifyEmailAuthDataDto].
  VerifyEmailAuthDataDto({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.user,
  });

  /// Creates a [VerifyEmailAuthDataDto] from JSON.
  factory VerifyEmailAuthDataDto.fromJson(Map<String, dynamic> json) =>
      _$VerifyEmailAuthDataDtoFromJson(json);
}
