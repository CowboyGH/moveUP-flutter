import 'package:json_annotation/json_annotation.dart';

part 'update_profile_request_dto.g.dart';

/// DTO for updating the authenticated profile.
@JsonSerializable(createFactory: false)
class UpdateProfileRequestDto {
  /// New profile name.
  final String name;

  /// New profile email.
  final String email;

  /// Creates an instance of [UpdateProfileRequestDto].
  UpdateProfileRequestDto({
    required this.name,
    required this.email,
  });

  /// Converts [UpdateProfileRequestDto] to JSON.
  Map<String, dynamic> toJson() => _$UpdateProfileRequestDtoToJson(this);
}
