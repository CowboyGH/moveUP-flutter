import 'package:json_annotation/json_annotation.dart';

import 'complete_guest_test_data_dto.dart';

part 'complete_guest_test_response_dto.g.dart';

/// DTO envelope for guest test completion response.
@JsonSerializable(createToJson: false)
class CompleteGuestTestResponseDto {
  /// Guest completion payload.
  final CompleteGuestTestDataDto data;

  /// Creates an instance of [CompleteGuestTestResponseDto].
  CompleteGuestTestResponseDto({required this.data});

  /// Creates a [CompleteGuestTestResponseDto] from JSON.
  factory CompleteGuestTestResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CompleteGuestTestResponseDtoFromJson(json);
}
