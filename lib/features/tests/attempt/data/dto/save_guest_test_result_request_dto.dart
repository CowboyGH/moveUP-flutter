import 'package:json_annotation/json_annotation.dart';

part 'save_guest_test_result_request_dto.g.dart';

/// DTO request for saving guest test exercise result.
@JsonSerializable()
class SaveGuestTestResultRequestDto {
  /// Exercise identifier inside the testing.
  @JsonKey(name: 'testing_exercise_id')
  final int testingExerciseId;

  /// Result value from `1` to `4`.
  @JsonKey(name: 'result_value')
  final int resultValue;

  /// Creates an instance of [SaveGuestTestResultRequestDto].
  SaveGuestTestResultRequestDto({
    required this.testingExerciseId,
    required this.resultValue,
  });

  /// Converts this request to JSON.
  Map<String, dynamic> toJson() => _$SaveGuestTestResultRequestDtoToJson(this);
}
