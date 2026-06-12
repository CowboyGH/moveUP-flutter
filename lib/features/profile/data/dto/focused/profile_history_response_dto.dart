import 'package:json_annotation/json_annotation.dart';

import '../profile_test_history_item_dto.dart';
import '../profile_workout_history_item_dto.dart';

part 'profile_history_response_dto.g.dart';

/// DTO for the focused `/profile/history` response.
@JsonSerializable(createToJson: false)
class ProfileHistoryResponseDto {
  /// History payload (always present, may contain empty arrays).
  final ProfileHistoryDataDto data;

  /// Creates an instance of [ProfileHistoryResponseDto].
  ProfileHistoryResponseDto({required this.data});

  /// Creates a [ProfileHistoryResponseDto] from JSON.
  factory ProfileHistoryResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileHistoryResponseDtoFromJson(json);
}

/// Payload of the focused `/profile/history` response.
@JsonSerializable(createToJson: false)
class ProfileHistoryDataDto {
  /// Completed workouts history.
  @JsonKey(defaultValue: <ProfileWorkoutHistoryItemDto>[])
  final List<ProfileWorkoutHistoryItemDto> workouts;

  /// Completed test attempts history.
  @JsonKey(defaultValue: <ProfileTestHistoryItemDto>[])
  final List<ProfileTestHistoryItemDto> tests;

  /// Creates an instance of [ProfileHistoryDataDto].
  ProfileHistoryDataDto({required this.workouts, required this.tests});

  /// Creates a [ProfileHistoryDataDto] from JSON.
  factory ProfileHistoryDataDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileHistoryDataDtoFromJson(json);
}
