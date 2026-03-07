import 'package:json_annotation/json_annotation.dart';

part 'verify_reset_code_response_dto.g.dart';

/// DTO for verify reset code response.
@JsonSerializable(createToJson: false)
class VerifyResetCodeResponseDto {
  /// Indicates whether verify reset code request succeeded.
  final bool success;

  /// Backend message about reset code verification result.
  final String message;

  /// Creates an instance of [VerifyResetCodeResponseDto].
  VerifyResetCodeResponseDto({
    required this.success,
    required this.message,
  });

  /// Creates a [VerifyResetCodeResponseDto] from JSON.
  factory VerifyResetCodeResponseDto.fromJson(Map<String, dynamic> json) =>
      _$VerifyResetCodeResponseDtoFromJson(json);
}
