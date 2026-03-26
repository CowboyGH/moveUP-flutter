import 'package:json_annotation/json_annotation.dart';

import 'save_guest_test_result_data_dto.dart';

part 'save_guest_test_result_response_dto.g.dart';

/// DTO envelope for saving guest test exercise result.
@JsonSerializable(createToJson: false)
class SaveGuestTestResultResponseDto {
  /// Guest result payload.
  final SaveGuestTestResultDataDto data;

  /// Creates an instance of [SaveGuestTestResultResponseDto].
  SaveGuestTestResultResponseDto({required this.data});

  /// Creates a [SaveGuestTestResultResponseDto] from JSON.
  factory SaveGuestTestResultResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SaveGuestTestResultResponseDtoFromJson(json);
}
