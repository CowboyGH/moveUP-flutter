import 'package:json_annotation/json_annotation.dart';

part 'verify_email_request_dto.g.dart';

/// DTO for verify email request.
@JsonSerializable(createFactory: false)
class VerifyEmailRequestDto {
  /// User email.
  final String email;

  /// OTP verification code.
  final String code;

  /// Creates an instance of [VerifyEmailRequestDto].
  VerifyEmailRequestDto({
    required this.email,
    required this.code,
  });

  /// Converts [VerifyEmailRequestDto] to JSON.
  Map<String, dynamic> toJson() => _$VerifyEmailRequestDtoToJson(this);
}
