import 'package:json_annotation/json_annotation.dart';

part 'resend_verification_code_response_dto.g.dart';

/// DTO for resend verification code response.
@JsonSerializable(createToJson: false)
class ResendVerificationCodeResponseDto {
  /// Indicates whether resend request succeeded.
  final bool success;

  /// Backend message about resend result.
  final String message;

  /// Creates an instance of [ResendVerificationCodeResponseDto].
  ResendVerificationCodeResponseDto({
    required this.success,
    required this.message,
  });

  /// Creates a [ResendVerificationCodeResponseDto] from JSON.
  factory ResendVerificationCodeResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ResendVerificationCodeResponseDtoFromJson(json);
}
