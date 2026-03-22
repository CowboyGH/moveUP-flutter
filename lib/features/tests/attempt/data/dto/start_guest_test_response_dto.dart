import 'package:json_annotation/json_annotation.dart';

import 'start_guest_test_data_dto.dart';

part 'start_guest_test_response_dto.g.dart';

/// DTO envelope for guest test start response.
@JsonSerializable(createToJson: false)
class StartGuestTestResponseDto {
  /// Guest test attempt payload.
  final StartGuestTestDataDto data;

  /// Creates an instance of [StartGuestTestResponseDto].
  StartGuestTestResponseDto({required this.data});

  /// Creates a [StartGuestTestResponseDto] from JSON.
  factory StartGuestTestResponseDto.fromJson(Map<String, dynamic> json) =>
      _$StartGuestTestResponseDtoFromJson(json);
}
