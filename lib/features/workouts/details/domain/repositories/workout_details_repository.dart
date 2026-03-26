import '../../../../../core/failures/feature/workouts/workouts_failure.dart';
import '../../../../../core/result/result.dart';
import '../entities/workout_details_item.dart';

/// Contract for the workout details flow.
abstract interface class WorkoutDetailsRepository {
  /// Loads workout details cards by [userWorkoutId].
  Future<Result<List<WorkoutDetailsItem>, WorkoutsFailure>> getWorkoutDetails(
    int userWorkoutId,
  );
}
