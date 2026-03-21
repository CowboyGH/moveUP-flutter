import 'package:json_annotation/json_annotation.dart';

part 'testing_category_dto.g.dart';

/// DTO for a testing category.
@JsonSerializable(createToJson: false)
class TestingCategoryDto {
  /// Category identifier.
  final int id;

  /// Category display name.
  final String name;

  /// Creates an instance of [TestingCategoryDto].
  TestingCategoryDto({
    required this.id,
    required this.name,
  });

  /// Creates a [TestingCategoryDto] from JSON.
  factory TestingCategoryDto.fromJson(Map<String, dynamic> json) =>
      _$TestingCategoryDtoFromJson(json);
}
