import 'package:json_annotation/json_annotation.dart';

part 'login_session_dto.g.dart';

/// DTO for session timing metadata returned on login.
@JsonSerializable(createToJson: false)
class LoginSessionDto {
  /// Absolute session lifetime in days.
  @JsonKey(name: 'lifetime_days')
  final int lifetimeDays;

  /// Maximum inactivity period in days.
  @JsonKey(name: 'inactivity_limit_days')
  final int inactivityLimitDays;

  /// Access token lifetime in minutes.
  @JsonKey(name: 'access_token_expires_in_minutes')
  final int accessTokenExpiresInMinutes;

  /// Creates an instance of [LoginSessionDto].
  LoginSessionDto({
    required this.lifetimeDays,
    required this.inactivityLimitDays,
    required this.accessTokenExpiresInMinutes,
  });

  /// Creates a [LoginSessionDto] from JSON.
  factory LoginSessionDto.fromJson(Map<String, dynamic> json) => _$LoginSessionDtoFromJson(json);
}
