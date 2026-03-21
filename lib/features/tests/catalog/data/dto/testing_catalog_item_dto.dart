import 'package:json_annotation/json_annotation.dart';

import 'testing_category_dto.dart';

part 'testing_catalog_item_dto.g.dart';

/// DTO for a testing catalog item.
@JsonSerializable(createToJson: false)
class TestingCatalogItemDto {
  /// Testing identifier.
  final int id;

  /// Testing title.
  final String title;

  /// Short testing description.
  final String description;

  /// Approximate duration in minutes provided by the backend.
  @JsonKey(name: 'duration_minutes')
  final String durationMinutes;

  /// Testing image path or URL.
  final String image;

  /// Related categories.
  final List<TestingCategoryDto> categories;

  /// Exercises count inside the testing.
  @JsonKey(name: 'exercises_count')
  final int exercisesCount;

  /// Creates an instance of [TestingCatalogItemDto].
  TestingCatalogItemDto({
    required this.id,
    required this.title,
    required this.description,
    required this.durationMinutes,
    required this.image,
    required this.categories,
    required this.exercisesCount,
  });

  /// Creates a [TestingCatalogItemDto] from JSON.
  factory TestingCatalogItemDto.fromJson(Map<String, dynamic> json) =>
      _$TestingCatalogItemDtoFromJson(json);
}
