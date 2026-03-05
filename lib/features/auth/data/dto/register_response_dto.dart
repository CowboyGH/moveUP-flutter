import 'package:json_annotation/json_annotation.dart';

import 'user_dto.dart';

part 'register_response_dto.g.dart';

/// DTO for the register response.
@JsonSerializable(createToJson: false)
class RegisterResponseDto {
  /// Indicates whether the register request succeeded.
  final bool success;

  /// Backend message about registration result.
  final String message;

  /// Registered user.
  final UserDto user;

  /// Creates an instance of [RegisterResponseDto].
  RegisterResponseDto({
    required this.success,
    required this.message,
    required this.user,
  });

  /// Creates a [RegisterResponseDto] from JSON.
  factory RegisterResponseDto.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseDtoFromJson(json);
}
