import 'package:json_annotation/json_annotation.dart';

part 'test_attempt_testing_dto.g.dart';

/// DTO that describes testing summary in guest attempt responses.
@JsonSerializable(createToJson: false)
class TestAttemptTestingDto {
  /// Testing identifier.
  final int id;

  /// Testing title.
  final String title;

  /// Testing description.
  final String description;

  /// Approximate duration in minutes provided by the backend.
  @JsonKey(name: 'duration_minutes')
  final String durationMinutes;

  /// Testing image path or URL.
  final String image;

  /// Total amount of exercises inside the testing.
  @JsonKey(name: 'total_exercises')
  final int totalExercises;

  /// Creates an instance of [TestAttemptTestingDto].
  TestAttemptTestingDto({
    required this.id,
    required this.title,
    required this.description,
    required this.durationMinutes,
    required this.image,
    required this.totalExercises,
  });

  /// Creates a [TestAttemptTestingDto] from JSON.
  factory TestAttemptTestingDto.fromJson(Map<String, dynamic> json) =>
      _$TestAttemptTestingDtoFromJson(json);
}
