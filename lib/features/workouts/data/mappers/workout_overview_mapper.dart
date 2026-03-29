import '../../overview/domain/entities/workout_overview_item.dart';
import '../dto/user_workout_overview_item_dto.dart';
import 'workout_image_url_mapper.dart';

/// Extension that maps [UserWorkoutOverviewItemDto] to [WorkoutOverviewItem].
extension WorkoutOverviewMapper on UserWorkoutOverviewItemDto {
  /// Converts DTO to a domain entity.
  WorkoutOverviewItem toEntity({required bool hasActive}) => WorkoutOverviewItem(
    userWorkoutId: userWorkoutId,
    isStarted: status == 'started',
    isBlockedByActiveWorkout: hasActive && status != 'started',
    title: workout.title,
    description: workout.description,
    durationMinutes: _parseDurationMinutes(workout.durationMinutes),
    imageUrl: normalizeWorkoutImageUrl(workout.image ?? ''),
  );
}

int _parseDurationMinutes(String rawValue) => int.tryParse(rawValue.trim()) ?? 0;
