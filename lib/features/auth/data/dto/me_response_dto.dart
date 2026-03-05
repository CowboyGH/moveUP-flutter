import 'package:json_annotation/json_annotation.dart';

import 'user_dto.dart';

part 'me_response_dto.g.dart';

/// DTO for the current user response.
@JsonSerializable(createToJson: false)
class MeResponseDto {
  /// Indicates whether request succeeded.
  final bool success;

  /// Current authorized user.
  final UserDto user;

  /// Creates an instance of [MeResponseDto].
  MeResponseDto({
    required this.success,
    required this.user,
  });

  /// Creates a [MeResponseDto] from JSON.
  factory MeResponseDto.fromJson(Map<String, dynamic> json) => _$MeResponseDtoFromJson(json);
}
