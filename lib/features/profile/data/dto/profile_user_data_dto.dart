import 'package:json_annotation/json_annotation.dart';

import 'active_profile_subscription_dto.dart';
import 'profile_user_dto.dart';
import 'profile_workout_history_item_dto.dart';
import 'profile_test_history_item_dto.dart';

part 'profile_user_data_dto.g.dart';

/// DTO for the profile `data` payload.
@JsonSerializable(createToJson: false)
class ProfileUserDataDto {
  /// Current authenticated user.
  final ProfileUserDto user;

  /// Active subscription snapshot for profile statistics history.
  final ProfileSubscriptionsDto? subscriptions;

  /// Workout history snapshot for profile statistics history.
  final ProfileWorkoutsDto? workouts;

  /// Test history snapshot for profile statistics history.
  final ProfileTestsDto? tests;

  /// Phase snapshot for the current phase section.
  final ProfilePhaseDto? phase;

  /// Creates an instance of [ProfileUserDataDto].
  ProfileUserDataDto({
    required this.user,
    this.subscriptions,
    this.workouts,
    this.tests,
    this.phase,
  });

  /// Creates a [ProfileUserDataDto] from JSON.
  factory ProfileUserDataDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileUserDataDtoFromJson(json);
}

/// DTO with focused phase payload from `/profile`.
@JsonSerializable(createToJson: false)
class ProfilePhaseDto {
  /// Whether the authenticated user has active phase progress.
  @JsonKey(name: 'has_progress')
  final bool hasProgress;

  /// Current phase snapshot.
  @JsonKey(name: 'current_phase')
  final ProfileCurrentPhaseDto? currentPhase;

  /// Creates an instance of [ProfilePhaseDto].
  ProfilePhaseDto({
    required this.hasProgress,
    required this.currentPhase,
  });

  /// Creates a [ProfilePhaseDto] from JSON.
  factory ProfilePhaseDto.fromJson(Map<String, dynamic> json) => _$ProfilePhaseDtoFromJson(json);
}

/// DTO with current phase name returned by `/profile`.
@JsonSerializable(createToJson: false)
class ProfileCurrentPhaseDto {
  /// Current phase identifier.
  final int id;

  /// Current phase title.
  final String name;

  /// Creates an instance of [ProfileCurrentPhaseDto].
  ProfileCurrentPhaseDto({
    required this.id,
    required this.name,
  });

  /// Creates a [ProfileCurrentPhaseDto] from JSON.
  factory ProfileCurrentPhaseDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileCurrentPhaseDtoFromJson(json);
}
