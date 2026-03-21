import 'package:dio/dio.dart';
import 'package:moveup_flutter/features/tests/catalog/data/dto/testing_catalog_item_dto.dart';
import 'package:moveup_flutter/features/tests/catalog/data/dto/testing_category_dto.dart';
import 'package:moveup_flutter/features/tests/catalog/data/dto/testings_response_dto.dart';
import 'package:moveup_flutter/features/tests/catalog/data/mappers/testing_catalog_mapper.dart';
import 'package:moveup_flutter/features/tests/catalog/domain/entities/testing_catalog_item.dart';

/// Test fixture for a testing category DTO.
TestingCategoryDto createTestingCategoryDto({
  int id = 1,
  String name = 'Плечи',
}) => TestingCategoryDto(
  id: id,
  name: name,
);

/// Test fixture for a testing catalog item DTO.
TestingCatalogItemDto createTestingCatalogItemDto({
  int id = 1,
  String title = 'Расширенная диагностика',
  String description = 'Описание теста',
  String durationMinutes = '20',
  String image = 'test.jpg',
  List<TestingCategoryDto>? categories,
  int exercisesCount = 4,
}) => TestingCatalogItemDto(
  id: id,
  title: title,
  description: description,
  durationMinutes: durationMinutes,
  image: image,
  categories:
      categories ??
      [
        createTestingCategoryDto(),
        createTestingCategoryDto(id: 2, name: 'Кардио'),
      ],
  exercisesCount: exercisesCount,
);

/// Test fixture for testings response DTO.
TestingsResponseDto createTestingsResponseDto() => TestingsResponseDto(
  data: [
    createTestingCatalogItemDto(),
    createTestingCatalogItemDto(
      id: 2,
      title: 'Быстрая проверка',
      durationMinutes: '10',
      image: 'https://cdn.example.com/testing-2.jpg',
      categories: [
        createTestingCategoryDto(id: 3, name: 'Гибкость'),
      ],
      exercisesCount: 2,
    ),
  ],
);

/// Test fixture for testing catalog domain entities.
List<TestingCatalogItem> createTestingCatalogItems() =>
    createTestingsResponseDto().data.map((item) => item.toEntity()).toList(growable: false);

/// Test fixture for Dio bad response exception.
DioException createTestsDioBadResponseException({
  required String path,
  required int statusCode,
  required String code,
  String message = 'error_message',
  Map<String, List<String>>? errors,
}) {
  final requestOptions = RequestOptions(path: path);
  final data = <String, dynamic>{
    'code': code,
    'message': message,
  };
  if (errors != null) {
    data['errors'] = errors;
  }

  return DioException(
    requestOptions: requestOptions,
    type: DioExceptionType.badResponse,
    response: Response<Map<String, dynamic>>(
      requestOptions: requestOptions,
      statusCode: statusCode,
      data: data,
    ),
  );
}
