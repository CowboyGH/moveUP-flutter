import 'package:json_annotation/json_annotation.dart';

part 'testing_exercise_dto.g.dart';

/// DTO for a testing exercise inside guest attempt responses.
@JsonSerializable(createToJson: false)
class TestingExerciseDto {
  /// Exercise identifier.
  final int id;

  /// Exercise description.
  final String description;

  /// Exercise image path or URL.
  final String image;

  /// Exercise order inside the testing.
  @JsonKey(name: 'order_number')
  final int orderNumber;

  /// Creates an instance of [TestingExerciseDto].
  TestingExerciseDto({
    required this.id,
    required this.description,
    required this.image,
    required this.orderNumber,
  });

  /// Creates a [TestingExerciseDto] from JSON.
  factory TestingExerciseDto.fromJson(Map<String, dynamic> json) =>
      _$TestingExerciseDtoFromJson(json);
}
