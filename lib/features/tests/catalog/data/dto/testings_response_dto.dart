import 'package:json_annotation/json_annotation.dart';

import 'testing_catalog_item_dto.dart';

part 'testings_response_dto.g.dart';

/// DTO for testings response envelope.
@JsonSerializable(createToJson: false)
class TestingsResponseDto {
  /// Testings payload.
  final List<TestingCatalogItemDto> data;

  /// Creates an instance of [TestingsResponseDto].
  TestingsResponseDto({required this.data});

  /// Creates a [TestingsResponseDto] from JSON.
  factory TestingsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$TestingsResponseDtoFromJson(json);
}
