import 'package:json_annotation/json_annotation.dart';

import '../profile_user_dto.dart';

part 'profile_user_only_response_dto.g.dart';

/// DTO for the focused `/profile/user` response.
@JsonSerializable(createToJson: false)
class ProfileUserOnlyResponseDto {
  /// Authenticated user payload.
  final ProfileUserDto data;

  /// Creates an instance of [ProfileUserOnlyResponseDto].
  ProfileUserOnlyResponseDto({required this.data});

  /// Creates a [ProfileUserOnlyResponseDto] from JSON.
  factory ProfileUserOnlyResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileUserOnlyResponseDtoFromJson(json);
}
