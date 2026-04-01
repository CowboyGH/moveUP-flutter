import 'package:json_annotation/json_annotation.dart';

part 'profile_parameters_request_dto.g.dart';

/// DTO for saving the selected training goal.
@JsonSerializable(createFactory: false)
class SaveProfileGoalRequestDto {
  /// Selected goal identifier.
  @JsonKey(name: 'goal_id')
  final int goalId;

  /// Creates an instance of [SaveProfileGoalRequestDto].
  SaveProfileGoalRequestDto({
    required this.goalId,
  });

  /// Converts [SaveProfileGoalRequestDto] to JSON.
  Map<String, dynamic> toJson() => _$SaveProfileGoalRequestDtoToJson(this);
}

/// DTO for saving anthropometry values.
@JsonSerializable(createFactory: false)
class SaveProfileAnthropometryRequestDto {
  /// Selected gender raw value.
  final String gender;

  /// User age.
  final int age;

  /// User weight.
  final double weight;

  /// User height.
  final int height;

  /// Selected equipment identifier.
  @JsonKey(name: 'equipment_id')
  final int equipmentId;

  /// Creates an instance of [SaveProfileAnthropometryRequestDto].
  SaveProfileAnthropometryRequestDto({
    required this.gender,
    required this.age,
    required this.weight,
    required this.height,
    required this.equipmentId,
  });

  /// Converts [SaveProfileAnthropometryRequestDto] to JSON.
  Map<String, dynamic> toJson() => _$SaveProfileAnthropometryRequestDtoToJson(this);
}

/// DTO for saving the selected preparation level.
@JsonSerializable(createFactory: false)
class SaveProfileLevelRequestDto {
  /// Selected level identifier.
  @JsonKey(name: 'level_id')
  final int levelId;

  /// Creates an instance of [SaveProfileLevelRequestDto].
  SaveProfileLevelRequestDto({
    required this.levelId,
  });

  /// Converts [SaveProfileLevelRequestDto] to JSON.
  Map<String, dynamic> toJson() => _$SaveProfileLevelRequestDtoToJson(this);
}

/// DTO for updating weekly training goal.
@JsonSerializable(createFactory: false)
class UpdateProfileWeeklyGoalRequestDto {
  /// Selected weekly goal.
  @JsonKey(name: 'weekly_goal')
  final int weeklyGoal;

  /// Creates an instance of [UpdateProfileWeeklyGoalRequestDto].
  UpdateProfileWeeklyGoalRequestDto({
    required this.weeklyGoal,
  });

  /// Converts [UpdateProfileWeeklyGoalRequestDto] to JSON.
  Map<String, dynamic> toJson() => _$UpdateProfileWeeklyGoalRequestDtoToJson(this);
}
