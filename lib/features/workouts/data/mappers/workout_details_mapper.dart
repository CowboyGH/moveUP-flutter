import '../../details/domain/entities/workout_details_item.dart';
import '../dto/workout_details_data_dto.dart';
import 'workout_image_url_mapper.dart';

/// Extension that maps workout details DTO payload to domain entities.
extension WorkoutDetailsMapper on WorkoutDetailsDataDto {
  /// Converts workout details payload to screen items.
  List<WorkoutDetailsItem> toEntities() => [
    ...warmups.map(
      (item) => WorkoutDetailsItem(
        type: WorkoutDetailsItemType.warmup,
        title: item.name,
        description: item.description,
        durationMinutes: _durationSecondsToMinutes(item.durationSeconds),
        imageUrl: normalizeWorkoutImageUrl(item.image ?? ''),
      ),
    ),
    WorkoutDetailsItem(
      type: WorkoutDetailsItemType.workout,
      title: workout.title,
      description: workout.description,
      durationMinutes: _parseDurationMinutes(workout.durationMinutes),
      imageUrl: normalizeWorkoutImageUrl(workout.image ?? ''),
    ),
  ];
}

int _durationSecondsToMinutes(int seconds) {
  if (seconds <= 0) return 0;
  return (seconds / 60).ceil();
}

int _parseDurationMinutes(String rawValue) => int.tryParse(rawValue.trim()) ?? 0;
