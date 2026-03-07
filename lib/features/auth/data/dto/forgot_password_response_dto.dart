import 'package:json_annotation/json_annotation.dart';

part 'forgot_password_response_dto.g.dart';

/// DTO for forgot password response.
@JsonSerializable(createToJson: false)
class ForgotPasswordResponseDto {
  /// Indicates whether forgot password request succeeded.
  final bool success;

  /// Backend message about forgot password result.
  final String message;

  /// Creates an instance of [ForgotPasswordResponseDto].
  ForgotPasswordResponseDto({
    required this.success,
    required this.message,
  });

  /// Creates a [ForgotPasswordResponseDto] from JSON.
  factory ForgotPasswordResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordResponseDtoFromJson(json);
}
