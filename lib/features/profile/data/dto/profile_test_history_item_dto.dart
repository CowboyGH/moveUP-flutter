import 'package:json_annotation/json_annotation.dart';

part 'profile_test_history_item_dto.g.dart';

/// DTO with focused tests payload from `/profile`.
@JsonSerializable(createToJson: false)
class ProfileTestsDto {
  /// Test history items.
  @JsonKey(defaultValue: <ProfileTestHistoryItemDto>[])
  final List<ProfileTestHistoryItemDto> history;

  /// Creates an instance of [ProfileTestsDto].
  ProfileTestsDto({required this.history});

  /// Creates a [ProfileTestsDto] from JSON.
  factory ProfileTestsDto.fromJson(Map<String, dynamic> json) => _$ProfileTestsDtoFromJson(json);
}

/// DTO for the latest test history snapshot returned by `/profile`.
@JsonSerializable(createToJson: false)
class ProfileTestHistoryItemDto {
  /// Attempt identifier.
  @JsonKey(name: 'attempt_id')
  final int attemptId;

  /// Nested testing reference.
  final ProfileTestHistoryTestingDto testing;

  /// Raw completion timestamp.
  @JsonKey(name: 'completed_at')
  final String completedAt;

  /// Completed pulse value.
  final int? pulse;

  /// Number of exercises in the testing.
  @JsonKey(name: 'exercises_count')
  final int? exercisesCount;

  /// Creates an instance of [ProfileTestHistoryItemDto].
  ProfileTestHistoryItemDto({
    required this.attemptId,
    required this.testing,
    required this.completedAt,
    required this.pulse,
    required this.exercisesCount,
  });

  /// Creates a [ProfileTestHistoryItemDto] from JSON.
  factory ProfileTestHistoryItemDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileTestHistoryItemDtoFromJson(json);
}

/// DTO with testing title info inside profile history.
@JsonSerializable(createToJson: false)
class ProfileTestHistoryTestingDto {
  /// Testing identifier.
  final int id;

  /// Testing title.
  final String title;

  /// Creates an instance of [ProfileTestHistoryTestingDto].
  ProfileTestHistoryTestingDto({
    required this.id,
    required this.title,
  });

  /// Creates a [ProfileTestHistoryTestingDto] from JSON.
  factory ProfileTestHistoryTestingDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileTestHistoryTestingDtoFromJson(json);
}
