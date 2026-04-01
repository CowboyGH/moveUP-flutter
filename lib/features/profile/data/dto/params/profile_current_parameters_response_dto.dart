import 'package:json_annotation/json_annotation.dart';

part 'profile_current_parameters_response_dto.g.dart';

/// DTO for the authenticated user-parameters response.
@JsonSerializable(createToJson: false)
class ProfileCurrentParametersResponseDto {
  /// Nested parameters payload.
  final ProfileCurrentParametersDto data;

  /// Creates an instance of [ProfileCurrentParametersResponseDto].
  ProfileCurrentParametersResponseDto({required this.data});

  /// Creates a [ProfileCurrentParametersResponseDto] from JSON.
  factory ProfileCurrentParametersResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileCurrentParametersResponseDtoFromJson(json);
}

/// Canonical authenticated parameters payload.
@JsonSerializable(createToJson: false)
class ProfileCurrentParametersDto {
  /// Persistent parameters identifier.
  final int id;

  /// Authenticated user identifier.
  @JsonKey(name: 'user_id')
  final int userId;

  /// Selected equipment identifier.
  @JsonKey(name: 'equipment_id')
  final int equipmentId;

  /// Selected level identifier.
  @JsonKey(name: 'level_id')
  final int levelId;

  /// Selected goal identifier.
  @JsonKey(name: 'goal_id')
  final int goalId;

  /// User height in centimeters.
  final int height;

  /// User weight in kilograms.
  final double weight;

  /// User age in years.
  final int age;

  /// Selected gender value.
  final String gender;

  /// Selected goal details.
  final ProfileCurrentParameterNamedItemDto goal;

  /// Selected level details.
  final ProfileCurrentParameterNamedItemDto level;

  /// Selected equipment details.
  final ProfileCurrentParameterNamedItemDto equipment;

  /// Creates an instance of [ProfileCurrentParametersDto].
  ProfileCurrentParametersDto({
    required this.id,
    required this.userId,
    required this.equipmentId,
    required this.levelId,
    required this.goalId,
    required this.height,
    required this.weight,
    required this.age,
    required this.gender,
    required this.goal,
    required this.level,
    required this.equipment,
  });

  /// Creates a [ProfileCurrentParametersDto] from JSON.
  factory ProfileCurrentParametersDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileCurrentParametersDtoFromJson(json);
}

/// Shared named nested item from the authenticated parameters payload.
@JsonSerializable(createToJson: false)
class ProfileCurrentParameterNamedItemDto {
  /// Item identifier.
  final int id;

  /// Display name.
  final String name;

  /// Creates an instance of [ProfileCurrentParameterNamedItemDto].
  ProfileCurrentParameterNamedItemDto({
    required this.id,
    required this.name,
  });

  /// Creates a [ProfileCurrentParameterNamedItemDto] from JSON.
  factory ProfileCurrentParameterNamedItemDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileCurrentParameterNamedItemDtoFromJson(json);
}
