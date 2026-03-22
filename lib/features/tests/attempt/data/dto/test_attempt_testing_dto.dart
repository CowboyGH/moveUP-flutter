import 'package:json_annotation/json_annotation.dart';

part 'test_attempt_testing_dto.g.dart';

/// DTO that describes testing summary in guest attempt responses.
@JsonSerializable(createToJson: false)
class TestAttemptTestingDto {
  /// Testing title.
  final String title;

  /// Total amount of exercises inside the testing.
  @JsonKey(name: 'total_exercises')
  final int totalExercises;

  /// Creates an instance of [TestAttemptTestingDto].
  TestAttemptTestingDto({
    required this.title,
    required this.totalExercises,
  });

  /// Creates a [TestAttemptTestingDto] from JSON.
  factory TestAttemptTestingDto.fromJson(Map<String, dynamic> json) =>
      _$TestAttemptTestingDtoFromJson(json);
}
