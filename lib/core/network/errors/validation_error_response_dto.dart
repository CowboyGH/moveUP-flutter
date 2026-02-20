import 'package:json_annotation/json_annotation.dart';

import 'error_response_dto.dart';

part 'validation_error_response_dto.g.dart';

/// DTO for the validation error response.
@JsonSerializable(createToJson: false)
class ValidationErrorResponseDto extends ErrorResponseDto {
  /// List of validation errors.
  final Map<String, List<String>> errors;

  /// Creates an instance of [ValidationErrorResponseDto].
  ValidationErrorResponseDto({
    required super.code,
    required super.message,
    required this.errors,
  });

  /// Creates a [ValidationErrorResponseDto] instance from a JSON map.
  factory ValidationErrorResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ValidationErrorResponseDtoFromJson(json);
}
