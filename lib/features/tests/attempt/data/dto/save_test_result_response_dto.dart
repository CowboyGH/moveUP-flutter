import 'package:json_annotation/json_annotation.dart';

import 'save_test_result_data_dto.dart';

part 'save_test_result_response_dto.g.dart';

/// DTO envelope for saving test exercise result.
@JsonSerializable(createToJson: false)
class SaveTestResultResponseDto {
  /// Saved test result payload.
  final SaveTestResultDataDto data;

  /// Creates an instance of [SaveTestResultResponseDto].
  SaveTestResultResponseDto({required this.data});

  /// Creates a [SaveTestResultResponseDto] from JSON.
  factory SaveTestResultResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SaveTestResultResponseDtoFromJson(json);
}
