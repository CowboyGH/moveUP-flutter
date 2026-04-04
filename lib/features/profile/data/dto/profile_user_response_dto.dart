import 'package:json_annotation/json_annotation.dart';

import 'profile_user_data_dto.dart';

part 'profile_user_response_dto.g.dart';

/// DTO for the authenticated profile response.
@JsonSerializable(createToJson: false)
class ProfileUserResponseDto {
  /// Nested data payload.
  final ProfileUserDataDto data;

  /// Creates an instance of [ProfileUserResponseDto].
  ProfileUserResponseDto({required this.data});

  /// Creates a [ProfileUserResponseDto] from JSON.
  factory ProfileUserResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileUserResponseDtoFromJson(json);
}
