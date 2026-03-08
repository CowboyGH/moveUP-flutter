import 'package:json_annotation/json_annotation.dart';

part 'reset_password_request_dto.g.dart';

/// DTO for the reset password request.
@JsonSerializable(createFactory: false)
class ResetPasswordRequestDto {
  /// User email.
  final String email;

  /// Verified OTP reset code.
  final String code;

  /// New password.
  final String password;

  /// Confirmation for the new password.
  @JsonKey(name: 'password_confirmation')
  final String passwordConfirmation;

  /// Creates an instance of [ResetPasswordRequestDto].
  ResetPasswordRequestDto({
    required this.email,
    required this.code,
    required this.password,
    required this.passwordConfirmation,
  });

  /// Converts [ResetPasswordRequestDto] to JSON.
  Map<String, dynamic> toJson() => _$ResetPasswordRequestDtoToJson(this);
}
