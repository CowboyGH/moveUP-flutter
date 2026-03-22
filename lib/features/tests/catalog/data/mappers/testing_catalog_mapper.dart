import '../../../data/mappers/testing_image_url_mapper.dart';
import '../../domain/entities/testing_catalog_item.dart';
import '../../domain/entities/testing_category.dart';
import '../dto/testing_catalog_item_dto.dart';
import '../dto/testing_category_dto.dart';

/// Extension that maps [TestingCatalogItemDto] to [TestingCatalogItem].
extension TestingCatalogItemMapper on TestingCatalogItemDto {
  /// Converts DTO to a domain entity.
  TestingCatalogItem toEntity() => TestingCatalogItem(
    id: id,
    title: title,
    description: description,
    durationMinutes: int.tryParse(durationMinutes.trim()) ?? 0,
    imageUrl: normalizeTestingImageUrl(image),
    categories: categories.map((category) => category.toEntity()).toList(growable: false),
    exercisesCount: exercisesCount,
  );
}

/// Extension that maps [TestingCategoryDto] to [TestingCategory].
extension TestingCategoryMapper on TestingCategoryDto {
  /// Converts DTO to a domain entity.
  TestingCategory toEntity() => TestingCategory(
    id: id,
    name: name,
  );
}
