import 'package:json_annotation/json_annotation.dart';

import 'start_test_data_dto.dart';

part 'start_test_response_dto.g.dart';

/// DTO envelope for authenticated test start response.
@JsonSerializable(createToJson: false)
class StartTestResponseDto {
  /// Authenticated test attempt payload.
  final StartTestDataDto data;

  /// Creates an instance of [StartTestResponseDto].
  StartTestResponseDto({required this.data});

  /// Creates a [StartTestResponseDto] from JSON.
  factory StartTestResponseDto.fromJson(Map<String, dynamic> json) =>
      _$StartTestResponseDtoFromJson(json);
}
