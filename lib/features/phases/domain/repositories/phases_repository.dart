import '../../../../core/failures/feature/phases/phases_failure.dart';
import '../../../../core/result/result.dart';

/// Repository contract for phases-related operations.
abstract interface class PhasesRepository {
  /// Updates weekly training goal to the provided [weeklyGoal].
  Future<Result<void, PhasesFailure>> updateWeeklyGoal(int weeklyGoal);
}
