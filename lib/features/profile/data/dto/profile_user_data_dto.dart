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

  /// Creates an instance of [ProfileUserDataDto].
  ProfileUserDataDto({
    required this.user,
    this.subscriptions,
    this.workouts,
    this.tests,
  });

  /// Creates a [ProfileUserDataDto] from JSON.
  factory ProfileUserDataDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileUserDataDtoFromJson(json);
}
