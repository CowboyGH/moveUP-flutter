import 'package:json_annotation/json_annotation.dart';

part 'error_response_dto.g.dart';

/// DTO for the error response.
@JsonSerializable()
class ErrorResponseDto {
  /// Error code.
  final String code;

  /// Error message.
  final String message;

  /// Creates an instance of [ErrorResponseDto].
  ErrorResponseDto({required this.code, required this.message});

  /// Creates a [ErrorResponseDto] instance from a JSON map.
  factory ErrorResponseDto.fromJson(Map<String, dynamic> json) => _$ErrorResponseDtoFromJson(json);

  /// Converts the [ErrorResponseDto] instance to a JSON map.
  Map<String, dynamic> toJson() => _$ErrorResponseDtoToJson(this);
}
