import 'package:json_annotation/json_annotation.dart';

part 'reset_password_response_dto.g.dart';

/// DTO for reset password response.
@JsonSerializable(createToJson: false)
class ResetPasswordResponseDto {
  /// Indicates whether reset password request succeeded.
  final bool success;

  /// Backend message about reset password result.
  final String message;

  /// Creates an instance of [ResetPasswordResponseDto].
  ResetPasswordResponseDto({
    required this.success,
    required this.message,
  });

  /// Creates a [ResetPasswordResponseDto] from JSON.
  factory ResetPasswordResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordResponseDtoFromJson(json);
}
