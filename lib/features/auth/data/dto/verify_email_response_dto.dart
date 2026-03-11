import 'package:json_annotation/json_annotation.dart';

import 'verify_email_auth_data_dto.dart';

part 'verify_email_response_dto.g.dart';

/// DTO for verify email response.
@JsonSerializable(createToJson: false)
class VerifyEmailResponseDto {
  /// Nested auth payload.
  final VerifyEmailAuthDataDto data;

  /// Creates an instance of [VerifyEmailResponseDto].
  VerifyEmailResponseDto({
    required this.data,
  });

  /// Creates a [VerifyEmailResponseDto] from JSON.
  factory VerifyEmailResponseDto.fromJson(Map<String, dynamic> json) =>
      _$VerifyEmailResponseDtoFromJson(json);
}
