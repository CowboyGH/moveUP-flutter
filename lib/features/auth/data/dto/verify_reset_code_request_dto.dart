import 'package:json_annotation/json_annotation.dart';

part 'verify_reset_code_request_dto.g.dart';

/// DTO for the verify reset code request.
@JsonSerializable(createFactory: false)
class VerifyResetCodeRequestDto {
  /// User email.
  final String email;

  /// OTP reset code.
  final String code;

  /// Creates an instance of [VerifyResetCodeRequestDto].
  VerifyResetCodeRequestDto({
    required this.email,
    required this.code,
  });

  /// Converts [VerifyResetCodeRequestDto] to JSON.
  Map<String, dynamic> toJson() => _$VerifyResetCodeRequestDtoToJson(this);
}
