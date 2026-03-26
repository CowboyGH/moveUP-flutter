import '../../../../core/failures/feature/fitness_start/fitness_start_failure.dart';
import '../../../../core/result/result.dart';
import '../entities/fitness_start_gender.dart';
import '../entities/fitness_start_references.dart';

/// Repository interface for the Fitness Start quiz flow.
abstract interface class FitnessStartRepository {
  /// Loads all reference data required by the quiz.
  Future<Result<FitnessStartReferences, FitnessStartFailure>> getReferences();

  /// Persists the selected training goal.
  Future<Result<void, FitnessStartFailure>> saveGoal(int goalId);

  /// Persists the anthropometry step data.
  Future<Result<void, FitnessStartFailure>> saveAnthropometry({
    required FitnessStartGender gender,
    required int age,
    required double weight,
    required int height,
    required int equipmentId,
  });

  /// Persists the selected preparation level.
  Future<Result<void, FitnessStartFailure>> saveLevel(int levelId);
}
