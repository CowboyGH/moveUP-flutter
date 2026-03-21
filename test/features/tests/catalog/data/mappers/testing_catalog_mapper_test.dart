import 'package:flutter_test/flutter_test.dart';
import 'package:moveup_flutter/core/network/api_paths.dart';
import 'package:moveup_flutter/features/tests/catalog/data/mappers/testing_catalog_mapper.dart';

import '../../support/testings_dto_fixtures.dart';

void main() {
  group('TestingCatalogItemMapper.toEntity', () {
    test('maps dto to entity with normalized relative image url', () {
      final dto = createTestingCatalogItemDto(
        durationMinutes: '15',
        image: 'tests/balance.jpg',
      );

      final entity = dto.toEntity();

      expect(entity.id, dto.id);
      expect(entity.title, dto.title);
      expect(entity.description, dto.description);
      expect(entity.durationMinutes, 15);
      expect(
        entity.imageUrl,
        Uri.parse(ApiPaths.baseUrl).resolve('storage/tests/balance.jpg').toString(),
      );
      expect(entity.categories.length, dto.categories.length);
      expect(entity.categories.first.id, dto.categories.first.id);
      expect(entity.categories.first.name, dto.categories.first.name);
      expect(entity.exercisesCount, dto.exercisesCount);
    });

    test('keeps absolute image url unchanged', () {
      const absoluteImageUrl = 'https://cdn.example.com/tests/balance.jpg';
      final dto = createTestingCatalogItemDto(image: absoluteImageUrl);

      final entity = dto.toEntity();

      expect(entity.imageUrl, absoluteImageUrl);
    });

    test('trims surrounding whitespace from image url before normalization', () {
      final dto = createTestingCatalogItemDto(image: '  tests/balance.jpg  ');

      final entity = dto.toEntity();

      expect(
        entity.imageUrl,
        Uri.parse(ApiPaths.baseUrl).resolve('storage/tests/balance.jpg').toString(),
      );
    });

    test('maps whitespace-only image url to empty string', () {
      final dto = createTestingCatalogItemDto(image: '   ');

      final entity = dto.toEntity();

      expect(entity.imageUrl, isEmpty);
    });

    test('maps invalid duration to 0', () {
      final dto = createTestingCatalogItemDto(durationMinutes: 'not_a_number');

      final entity = dto.toEntity();

      expect(entity.durationMinutes, 0);
    });
  });
}
