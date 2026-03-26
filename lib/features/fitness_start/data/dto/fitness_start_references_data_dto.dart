import 'package:json_annotation/json_annotation.dart';

import 'fitness_start_option_dto.dart';

part 'fitness_start_references_data_dto.g.dart';

/// DTO for Fitness Start references payload.
@JsonSerializable(createToJson: false)
class FitnessStartReferencesDataDto {
  /// Available training goals.
  final List<FitnessStartOptionDto> goals;

  /// Available preparation levels.
  final List<FitnessStartOptionDto> levels;

  /// Available equipment options.
  final List<FitnessStartOptionDto> equipment;

  /// Creates an instance of [FitnessStartReferencesDataDto].
  FitnessStartReferencesDataDto({
    required this.goals,
    required this.levels,
    required this.equipment,
  });

  /// Creates a [FitnessStartReferencesDataDto] from JSON.
  factory FitnessStartReferencesDataDto.fromJson(Map<String, dynamic> json) =>
      _$FitnessStartReferencesDataDtoFromJson(json);
}
