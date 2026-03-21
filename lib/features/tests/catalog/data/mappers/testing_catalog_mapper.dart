import '../../../../../core/network/api_paths.dart';
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
    durationMinutes: int.parse(durationMinutes),
    imageUrl: _normalizeImageUrl(image),
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

String _normalizeImageUrl(String rawImage) {
  if (rawImage.trim().isEmpty) return rawImage;
  if (rawImage.startsWith('http://') || rawImage.startsWith('https://')) {
    return rawImage;
  }
  final normalizedPath = rawImage.replaceFirst(RegExp(r'^/+'), '');
  final storagePath = normalizedPath.startsWith('storage/')
      ? normalizedPath
      : 'storage/$normalizedPath';
  return Uri.parse(ApiPaths.baseUrl).resolve(storagePath).toString();
}
