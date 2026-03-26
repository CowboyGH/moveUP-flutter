import 'package:json_annotation/json_annotation.dart';

part 'fitness_start_option_dto.g.dart';

/// DTO for a single Fitness Start reference option.
@JsonSerializable(createToJson: false)
class FitnessStartOptionDto {
  /// Unique option identifier.
  final int id;

  /// Option display name.
  final String name;

  /// Creates an instance of [FitnessStartOptionDto].
  FitnessStartOptionDto({
    required this.id,
    required this.name,
  });

  /// Creates a [FitnessStartOptionDto] from JSON.
  factory FitnessStartOptionDto.fromJson(Map<String, dynamic> json) =>
      _$FitnessStartOptionDtoFromJson(json);
}
