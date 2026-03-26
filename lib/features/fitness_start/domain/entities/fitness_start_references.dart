import 'package:equatable/equatable.dart';

import 'fitness_start_option.dart';

/// Reference data used to build Fitness Start quiz options.
class FitnessStartReferences extends Equatable {
  /// Available training goals.
  final List<FitnessStartOption> goals;

  /// Available preparation levels.
  final List<FitnessStartOption> levels;

  /// Available equipment options.
  final List<FitnessStartOption> equipment;

  /// Creates an instance of [FitnessStartReferences].
  const FitnessStartReferences({
    required this.goals,
    required this.levels,
    required this.equipment,
  });

  @override
  List<Object?> get props => [goals, levels, equipment];
}
