import 'package:json_annotation/json_annotation.dart';

import 'profile_user_dto.dart';

part 'profile_user_data_dto.g.dart';

/// DTO for the profile `data` payload.
@JsonSerializable(createToJson: false)
class ProfileUserDataDto {
  /// Current authenticated user.
  final ProfileUserDto user;

  /// Creates an instance of [ProfileUserDataDto].
  ProfileUserDataDto({
    required this.user,
  });

  /// Creates a [ProfileUserDataDto] from JSON.
  factory ProfileUserDataDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileUserDataDtoFromJson(json);
}
