import 'package:json_annotation/json_annotation.dart';

import 'login_session_dto.dart';
import 'user_dto.dart';

part 'login_response_dto.g.dart';

/// DTO for the login response.
@JsonSerializable(createToJson: false)
class LoginResponseDto {
  /// JWT access token.
  @JsonKey(name: 'access_token')
  final String accessToken;

  /// Type of token, usually `bearer`.
  @JsonKey(name: 'token_type')
  final String tokenType;

  /// Access token lifetime in seconds.
  @JsonKey(name: 'expires_in')
  final int expiresIn;

  /// Refresh window lifetime in seconds.
  @JsonKey(name: 'refresh_expires_in')
  final int refreshExpiresIn;

  /// Session limits for current login.
  final LoginSessionDto session;

  /// Logged-in user.
  final UserDto user;

  /// Creates an instance of [LoginResponseDto].
  LoginResponseDto({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.refreshExpiresIn,
    required this.session,
    required this.user,
  });

  /// Creates a [LoginResponseDto] from JSON.
  factory LoginResponseDto.fromJson(Map<String, dynamic> json) => _$LoginResponseDtoFromJson(json);
}
