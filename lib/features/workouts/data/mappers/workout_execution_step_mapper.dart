import '../../execution/domain/entities/workout_execution_step.dart';
import '../dto/workout_execution_step_data_dto.dart';
import 'workout_image_url_mapper.dart';

/// Extension that maps workout execution step DTOs into domain entities.
extension WorkoutExecutionStepMapper on WorkoutExecutionStepDataDto {
  /// Converts execution payload into a domain step entity.
  WorkoutExecutionStep toExecutionStep() => type == 'warmup'
      ? WorkoutWarmupStep(
          id: warmup!.id,
          name: warmup!.name,
          description: warmup!.description,
          imageUrl: normalizeWorkoutImageUrl(warmup!.image ?? ''),
          durationSeconds: warmup!.durationSeconds,
          isLast: warmup!.isLast,
        )
      : WorkoutExerciseStep(
          id: exercise!.id,
          title: exercise!.title,
          description: exercise!.description,
          imageUrl: normalizeWorkoutImageUrl(exercise!.image ?? ''),
          sets: exercise!.sets,
          reps: exercise!.reps,
          currentWeight: exercise!.currentWeight,
          needsWeightInput: needsWeightInput,
        );
}
