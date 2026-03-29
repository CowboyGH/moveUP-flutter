import 'package:json_annotation/json_annotation.dart';

part 'complete_test_request_dto.g.dart';

/// DTO request for completing a test attempt.
@JsonSerializable()
class CompleteTestRequestDto {
  /// Pulse after finishing the testing.
  final int pulse;

  /// Creates an instance of [CompleteTestRequestDto].
  CompleteTestRequestDto({required this.pulse});

  /// Converts this request to JSON.
  Map<String, dynamic> toJson() => _$CompleteTestRequestDtoToJson(this);
}
