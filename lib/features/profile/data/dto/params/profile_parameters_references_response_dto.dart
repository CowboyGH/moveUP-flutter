import 'package:json_annotation/json_annotation.dart';

part 'profile_parameters_references_response_dto.g.dart';

/// DTO for profile parameters references response.
@JsonSerializable(createToJson: false)
class ProfileParametersReferencesResponseDto {
  /// Nested references payload.
  final ProfileParametersReferencesDto data;

  /// Creates an instance of [ProfileParametersReferencesResponseDto].
  ProfileParametersReferencesResponseDto({required this.data});

  /// Creates a [ProfileParametersReferencesResponseDto] from JSON.
  factory ProfileParametersReferencesResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileParametersReferencesResponseDtoFromJson(json);
}

/// References payload required by the profile parameters section.
@JsonSerializable(createToJson: false)
class ProfileParametersReferencesDto {
  /// Available goal options.
  final List<ProfileParametersReferenceOptionDto> goals;

  /// Available preparation level options.
  final List<ProfileParametersReferenceOptionDto> levels;

  /// Available equipment options.
  final List<ProfileParametersReferenceOptionDto> equipment;

  /// Creates an instance of [ProfileParametersReferencesDto].
  ProfileParametersReferencesDto({
    required this.goals,
    required this.levels,
    required this.equipment,
  });

  /// Creates a [ProfileParametersReferencesDto] from JSON.
  factory ProfileParametersReferencesDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileParametersReferencesDtoFromJson(json);
}

/// Shared reference option item.
@JsonSerializable(createToJson: false)
class ProfileParametersReferenceOptionDto {
  /// Option identifier.
  final int id;

  /// Display name.
  final String name;

  /// Creates an instance of [ProfileParametersReferenceOptionDto].
  ProfileParametersReferenceOptionDto({
    required this.id,
    required this.name,
  });

  /// Creates a [ProfileParametersReferenceOptionDto] from JSON.
  factory ProfileParametersReferenceOptionDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileParametersReferenceOptionDtoFromJson(json);
}
