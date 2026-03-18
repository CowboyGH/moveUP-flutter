import 'package:json_annotation/json_annotation.dart';

import 'fitness_start_references_data_dto.dart';

part 'fitness_start_references_response_dto.g.dart';

/// DTO for Fitness Start references response envelope.
@JsonSerializable(createToJson: false)
class FitnessStartReferencesResponseDto {
  /// Nested references payload.
  final FitnessStartReferencesDataDto data;

  /// Creates an instance of [FitnessStartReferencesResponseDto].
  FitnessStartReferencesResponseDto({required this.data});

  /// Creates a [FitnessStartReferencesResponseDto] from JSON.
  factory FitnessStartReferencesResponseDto.fromJson(Map<String, dynamic> json) =>
      _$FitnessStartReferencesResponseDtoFromJson(json);
}
