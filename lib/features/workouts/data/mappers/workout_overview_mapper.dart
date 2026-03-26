import '../../overview/domain/entities/workout_overview_item.dart';
import '../dto/user_workout_overview_item_dto.dart';
import 'workout_image_url_mapper.dart';

/// Extension that maps [UserWorkoutOverviewItemDto] to [WorkoutOverviewItem].
extension WorkoutOverviewMapper on UserWorkoutOverviewItemDto {
  /// Converts DTO to a domain entity.
  WorkoutOverviewItem toEntity() => WorkoutOverviewItem(
    userWorkoutId: userWorkoutId,
    workoutId: workout.id,
    title: workout.title,
    description: workout.description,
    durationMinutes: _parseDurationMinutes(workout.durationMinutes),
    imageUrl: normalizeWorkoutImageUrl(workout.image ?? ''),
    status: status,
  );
}

int _parseDurationMinutes(String rawValue) => int.tryParse(rawValue.trim()) ?? 0;
