import '../../../../../core/failures/feature/workouts/workouts_failure.dart';
import '../../../../../core/result/result.dart';
import '../entities/workout_overview_item.dart';

/// Repository interface for workouts overview operations.
abstract interface class WorkoutsOverviewRepository {
  /// Returns user workouts available for the overview screen.
  Future<Result<List<WorkoutOverviewItem>, WorkoutsFailure>> getWorkouts();
}
