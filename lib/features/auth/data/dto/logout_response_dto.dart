import 'package:json_annotation/json_annotation.dart';

part 'logout_response_dto.g.dart';

/// DTO for logout response.
@JsonSerializable(createToJson: false)
class LogoutResponseDto {
  /// Indicates whether logout succeeded.
  final bool success;

  /// Backend message about logout result.
  final String message;

  /// Creates an instance of [LogoutResponseDto].
  LogoutResponseDto({
    required this.success,
    required this.message,
  });

  /// Creates a [LogoutResponseDto] from JSON.
  factory LogoutResponseDto.fromJson(Map<String, dynamic> json) =>
      _$LogoutResponseDtoFromJson(json);
}
