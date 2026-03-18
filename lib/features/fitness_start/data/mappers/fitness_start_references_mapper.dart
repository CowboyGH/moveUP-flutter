import '../../domain/entities/fitness_start_option.dart';
import '../../domain/entities/fitness_start_references.dart';
import '../dto/fitness_start_option_dto.dart';
import '../dto/fitness_start_references_data_dto.dart';

/// Maps [FitnessStartOptionDto] to domain entity.
extension FitnessStartOptionMapper on FitnessStartOptionDto {
  /// Converts DTO into [FitnessStartOption].
  FitnessStartOption toEntity() => FitnessStartOption(id: id, name: name);
}

/// Maps [FitnessStartReferencesDataDto] to domain entity.
extension FitnessStartReferencesMapper on FitnessStartReferencesDataDto {
  /// Converts DTO into [FitnessStartReferences].
  FitnessStartReferences toEntity() => FitnessStartReferences(
    goals: goals.map((option) => option.toEntity()).toList(growable: false),
    levels: levels.map((option) => option.toEntity()).toList(growable: false),
    equipment: equipment.map((option) => option.toEntity()).toList(growable: false),
  );
}
