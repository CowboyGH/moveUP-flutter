import 'package:json_annotation/json_annotation.dart';

part 'resend_verification_code_request_dto.g.dart';

/// DTO for resend verification code request.
@JsonSerializable(createFactory: false)
class ResendVerificationCodeRequestDto {
  /// User email.
  final String email;

  /// Creates an instance of [ResendVerificationCodeRequestDto].
  ResendVerificationCodeRequestDto({required this.email});

  /// Converts [ResendVerificationCodeRequestDto] to JSON.
  Map<String, dynamic> toJson() => _$ResendVerificationCodeRequestDtoToJson(this);
}
