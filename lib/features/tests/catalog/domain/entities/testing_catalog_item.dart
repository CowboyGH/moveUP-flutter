import 'package:equatable/equatable.dart';

import 'testing_category.dart';

/// Catalog item returned by the testings endpoint.
final class TestingCatalogItem extends Equatable {
  /// Testing identifier.
  final int id;

  /// Testing title.
  final String title;

  /// Short testing description.
  final String description;

  /// Approximate duration in minutes.
  final int durationMinutes;

  /// Normalized testing image URL.
  final String imageUrl;

  /// Related testing categories.
  final List<TestingCategory> categories;

  /// Amount of exercises included in the testing.
  final int exercisesCount;

  /// Creates an instance of [TestingCatalogItem].
  const TestingCatalogItem({
    required this.id,
    required this.title,
    required this.description,
    required this.durationMinutes,
    required this.imageUrl,
    required this.categories,
    required this.exercisesCount,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    durationMinutes,
    imageUrl,
    categories,
    exercisesCount,
  ];
}
