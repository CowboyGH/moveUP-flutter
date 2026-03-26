import 'package:json_annotation/json_annotation.dart';

part 'save_user_parameter_step_response_dto.g.dart';

/// DTO for save-step response envelope.
@JsonSerializable(createToJson: false)
class SaveUserParameterStepResponseDto {
  /// Optional nested payload.
  final Map<String, dynamic>? data;

  /// Creates an instance of [SaveUserParameterStepResponseDto].
  SaveUserParameterStepResponseDto({this.data});

  /// Creates a [SaveUserParameterStepResponseDto] from JSON.
  factory SaveUserParameterStepResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SaveUserParameterStepResponseDtoFromJson(json);
}
