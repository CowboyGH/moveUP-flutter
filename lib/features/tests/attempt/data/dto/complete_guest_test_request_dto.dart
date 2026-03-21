import 'package:json_annotation/json_annotation.dart';

part 'complete_guest_test_request_dto.g.dart';

/// DTO request for completing a guest test attempt.
@JsonSerializable()
class CompleteGuestTestRequestDto {
  /// Pulse after finishing the testing.
  final int pulse;

  /// Creates an instance of [CompleteGuestTestRequestDto].
  CompleteGuestTestRequestDto({required this.pulse});

  /// Converts this request to JSON.
  Map<String, dynamic> toJson() => _$CompleteGuestTestRequestDtoToJson(this);
}
