import 'package:json_annotation/json_annotation.dart';

part 'profile_exercises_response_dto.g.dart';

/// DTO response with available profile statistics exercises.
@JsonSerializable(createToJson: false)
class ProfileExercisesResponseDto {
  /// Exercises selector payload.
  final List<ProfileExerciseItemDto> data;

  /// Creates an instance of [ProfileExercisesResponseDto].
  ProfileExercisesResponseDto({
    required this.data,
  });

  /// Creates a [ProfileExercisesResponseDto] from JSON.
  factory ProfileExercisesResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileExercisesResponseDtoFromJson(json);
}

/// DTO item for the profile exercises selector.
@JsonSerializable(createToJson: false)
class ProfileExerciseItemDto {
  /// Exercise identifier.
  final int id;

  /// Exercise title.
  final String name;

  /// Last raw usage date.
  @JsonKey(name: 'last_used')
  final String? lastUsed;

  /// Last formatted usage date.
  @JsonKey(name: 'last_used_formatted')
  final String? lastUsedFormatted;

  /// Creates an instance of [ProfileExerciseItemDto].
  ProfileExerciseItemDto({
    required this.id,
    required this.name,
    required this.lastUsed,
    required this.lastUsedFormatted,
  });

  /// Creates a [ProfileExerciseItemDto] from JSON.
  factory ProfileExerciseItemDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileExerciseItemDtoFromJson(json);
}
