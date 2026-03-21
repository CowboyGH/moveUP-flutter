import 'package:json_annotation/json_annotation.dart';

part 'complete_guest_test_data_dto.g.dart';

/// DTO payload returned after completing a guest test attempt.
@JsonSerializable(createToJson: false)
class CompleteGuestTestDataDto {
  /// Guest attempt identifier.
  @JsonKey(name: 'attempt_id')
  final String attemptId;

  /// Completion timestamp string returned by the backend.
  @JsonKey(name: 'completed_at')
  final String completedAt;

  /// Saved pulse value.
  final int pulse;

  /// Creates an instance of [CompleteGuestTestDataDto].
  CompleteGuestTestDataDto({
    required this.attemptId,
    required this.completedAt,
    required this.pulse,
  });

  /// Creates a [CompleteGuestTestDataDto] from JSON.
  factory CompleteGuestTestDataDto.fromJson(Map<String, dynamic> json) =>
      _$CompleteGuestTestDataDtoFromJson(json);
}
