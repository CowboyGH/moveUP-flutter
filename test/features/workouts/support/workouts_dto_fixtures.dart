import 'package:dio/dio.dart';
import 'package:moveup_flutter/features/workouts/data/dto/save_exercise_result_data_dto.dart';
import 'package:moveup_flutter/features/workouts/data/dto/save_exercise_result_response_dto.dart';
import 'package:moveup_flutter/features/workouts/data/dto/user_workout_overview_item_dto.dart';
import 'package:moveup_flutter/features/workouts/data/dto/warmup_item_dto.dart';
import 'package:moveup_flutter/features/workouts/data/dto/workout_details_data_dto.dart';
import 'package:moveup_flutter/features/workouts/data/dto/workout_details_response_dto.dart';
import 'package:moveup_flutter/features/workouts/data/dto/workout_execution_exercise_item_dto.dart';
import 'package:moveup_flutter/features/workouts/data/dto/workout_execution_step_data_dto.dart';
import 'package:moveup_flutter/features/workouts/data/dto/workout_execution_step_response_dto.dart';
import 'package:moveup_flutter/features/workouts/data/dto/workout_summary_dto.dart';
import 'package:moveup_flutter/features/workouts/data/dto/workouts_list_data_dto.dart';
import 'package:moveup_flutter/features/workouts/data/dto/workouts_response_dto.dart';
import 'package:moveup_flutter/features/workouts/data/mappers/workout_details_mapper.dart';
import 'package:moveup_flutter/features/workouts/data/mappers/workout_overview_mapper.dart';
import 'package:moveup_flutter/features/workouts/details/domain/entities/workout_details_item.dart';
import 'package:moveup_flutter/features/workouts/execution/domain/entities/workout_execution_result.dart';
import 'package:moveup_flutter/features/workouts/execution/domain/entities/workout_execution_start.dart';
import 'package:moveup_flutter/features/workouts/execution/domain/entities/workout_execution_step.dart';
import 'package:moveup_flutter/features/workouts/overview/domain/entities/workout_overview_item.dart';

/// Test fixture for workouts response DTO.
WorkoutsResponseDto createWorkoutsResponseDto() => WorkoutsResponseDto(
  data: WorkoutsListDataDto(
    started: [
      UserWorkoutOverviewItemDto(
        userWorkoutId: 1,
        workout: WorkoutSummaryDto(
          id: 1,
          title: 'title',
          description: 'description',
          durationMinutes: '1',
          image: 'image.png',
        ),
        status: 'started',
      ),
    ],
    assigned: [
      UserWorkoutOverviewItemDto(
        userWorkoutId: 202,
        workout: WorkoutSummaryDto(
          id: 2,
          title: 'title',
          description: 'description',
          durationMinutes: '2',
          image: 'image_2.png',
        ),
        status: 'assigned',
      ),
    ],
    hasActive: true,
  ),
);

/// Test fixture for workouts overview domain entities.
List<WorkoutOverviewItem> createWorkoutOverviewItems() => [
  ...createWorkoutsResponseDto().data.started,
  ...createWorkoutsResponseDto().data.assigned,
].map((item) => item.toEntity(hasActive: true)).toList(growable: false);

/// Test fixture for workout details response DTO.
WorkoutDetailsResponseDto createWorkoutDetailsResponseDto({
  String status = 'started',
}) => WorkoutDetailsResponseDto(
  data: WorkoutDetailsDataDto(
    status: status,
    warmups: [
      WarmupItemDto(
        id: 1,
        name: 'name',
        description: 'description',
        image: 'test.png',
        durationSeconds: 270,
        isLast: true,
      ),
    ],
    workout: WorkoutSummaryDto(
      id: 1,
      title: 'title',
      description: 'description',
      durationMinutes: '1',
      image: 'test.png',
    ),
  ),
);

/// Test fixture for workout details domain entities.
List<WorkoutDetailsItem> createWorkoutDetailsItems() =>
    createWorkoutDetailsResponseDto().data.toEntities();

/// Test fixture for workout warmup step DTO data.
WorkoutExecutionStepDataDto createWorkoutExecutionWarmupStepDataDto({
  int? userWorkoutId = 1,
  int warmupId = 1,
  String name = 'Мобилизация бедра',
  String description = 'Выполняйте указанное упражнение',
  String image = 'https://example.com/warmup.png',
  int durationSeconds = 60,
  bool isLast = false,
}) => WorkoutExecutionStepDataDto(
  type: 'warmup',
  userWorkoutId: userWorkoutId,
  needsWeightInput: false,
  warmup: WarmupItemDto(
    id: warmupId,
    name: name,
    description: description,
    image: image,
    durationSeconds: durationSeconds,
    isLast: isLast,
  ),
  exercise: null,
);

/// Test fixture for workout exercise item DTO.
WorkoutExecutionExerciseItemDto createWorkoutExecutionExerciseItemDto({
  int exerciseId = 21,
  String title = 'Жим штанги стоя',
  String description = 'Описание упражнения',
  String image = 'https://example.com/exercise.png',
  int sets = 4,
  int reps = 10,
  double? currentWeight = 50,
}) => WorkoutExecutionExerciseItemDto(
  id: exerciseId,
  title: title,
  description: description,
  image: image,
  sets: sets,
  reps: reps,
  currentWeight: currentWeight,
);

/// Test fixture for workout exercise step DTO data.
WorkoutExecutionStepDataDto createWorkoutExecutionExerciseStepDataDto({
  int? userWorkoutId = 1,
  int exerciseId = 21,
  String title = 'Жим штанги стоя',
  String description = 'Описание упражнения',
  String image = 'https://example.com/exercise.png',
  int sets = 4,
  int reps = 10,
  double? currentWeight = 50,
  bool needsWeightInput = true,
}) => WorkoutExecutionStepDataDto(
  type: 'exercise',
  userWorkoutId: userWorkoutId,
  needsWeightInput: needsWeightInput,
  warmup: null,
  exercise: createWorkoutExecutionExerciseItemDto(
    exerciseId: exerciseId,
    title: title,
    description: description,
    image: image,
    sets: sets,
    reps: reps,
    currentWeight: currentWeight,
  ),
);

/// Test fixture for warmup execution response DTO.
WorkoutExecutionStepResponseDto createWorkoutExecutionWarmupResponseDto({
  int? userWorkoutId = 1,
  int warmupId = 1,
  bool isLast = false,
}) => WorkoutExecutionStepResponseDto(
  data: createWorkoutExecutionWarmupStepDataDto(
    userWorkoutId: userWorkoutId,
    warmupId: warmupId,
    isLast: isLast,
  ),
);

/// Test fixture for exercise execution response DTO.
WorkoutExecutionStepResponseDto createWorkoutExecutionExerciseResponseDto({
  int? userWorkoutId = 1,
  int exerciseId = 21,
  double? currentWeight = 50,
  bool needsWeightInput = true,
}) => WorkoutExecutionStepResponseDto(
  data: createWorkoutExecutionExerciseStepDataDto(
    userWorkoutId: userWorkoutId,
    exerciseId: exerciseId,
    currentWeight: currentWeight,
    needsWeightInput: needsWeightInput,
  ),
);

/// Test fixture for warmup execution domain step.
WorkoutWarmupStep createWorkoutWarmupStep({
  int id = 1,
  String name = 'Мобилизация бедра',
  String description = 'Выполняйте указанное упражнение',
  String imageUrl = 'https://example.com/warmup.png',
  int durationSeconds = 60,
  bool isLast = false,
}) => WorkoutWarmupStep(
  id: id,
  name: name,
  description: description,
  imageUrl: imageUrl,
  durationSeconds: durationSeconds,
  isLast: isLast,
);

/// Test fixture for exercise execution domain step.
WorkoutExerciseStep createWorkoutExerciseStep({
  int id = 21,
  String title = 'Жим штанги стоя',
  String description = 'Описание упражнения',
  String imageUrl = 'https://example.com/exercise.png',
  int sets = 4,
  int reps = 10,
  double? currentWeight = 50,
  bool needsWeightInput = true,
}) => WorkoutExerciseStep(
  id: id,
  title: title,
  description: description,
  imageUrl: imageUrl,
  sets: sets,
  reps: reps,
  currentWeight: currentWeight,
  needsWeightInput: needsWeightInput,
);

/// Test fixture for workout execution start payload.
WorkoutExecutionStart createWorkoutExecutionStart({
  int userWorkoutId = 1,
  WorkoutExecutionStep? currentStep,
}) => WorkoutExecutionStart(
  userWorkoutId: userWorkoutId,
  currentStep: currentStep ?? createWorkoutWarmupStep(),
);

/// Test fixture for save-exercise-result adjustment DTO.
SaveExerciseResultAdjustmentDto createSaveExerciseResultAdjustmentDto({
  bool applied = true,
  String? type = 'increase',
  int? percent = 10,
  double? oldWeight = 60.5,
  double? newWeight = 66.5,
}) => SaveExerciseResultAdjustmentDto(
  applied: applied,
  type: type,
  percent: percent,
  oldWeight: oldWeight,
  newWeight: newWeight,
);

/// Test fixture for save-exercise-result response with a next exercise.
SaveExerciseResultResponseDto createSaveExerciseResultNextExerciseResponseDto({
  int userWorkoutId = 1,
  int exerciseId = 22,
  SaveExerciseResultAdjustmentDto? adjustment,
}) => SaveExerciseResultResponseDto(
  data: SaveExerciseResultDataDto(
    exerciseResult: SaveExerciseResultExerciseResultDto(
      adjustments: adjustment,
    ),
    nextExercise: createWorkoutExecutionExerciseStepDataDto(
      userWorkoutId: userWorkoutId,
      exerciseId: exerciseId,
    ),
    allExercisesCompleted: false,
  ),
);

/// Test fixture for save-exercise-result response that completes the workout.
SaveExerciseResultResponseDto createSaveExerciseResultCompletedResponseDto({
  SaveExerciseResultAdjustmentDto? adjustment,
}) => SaveExerciseResultResponseDto(
  data: SaveExerciseResultDataDto(
    exerciseResult: SaveExerciseResultExerciseResultDto(
      adjustments: adjustment,
    ),
    nextExercise: null,
    allExercisesCompleted: true,
  ),
);

/// Test fixture for malformed save-exercise-result response DTO.
SaveExerciseResultResponseDto createSaveExerciseResultMalformedResponseDto() =>
    SaveExerciseResultResponseDto(
      data: SaveExerciseResultDataDto(
        exerciseResult: null,
        nextExercise: null,
        allExercisesCompleted: false,
      ),
    );

/// Test fixture for workout execution next-exercise result.
WorkoutExecutionResult createWorkoutExecutionNextExerciseResult({
  WorkoutExerciseStep? nextExercise,
  WorkoutLoadAdjustment? adjustment,
}) => WorkoutExecutionResult(
  nextExercise: nextExercise ?? createWorkoutExerciseStep(id: 22),
  isAwaitingCompletion: false,
  adjustment: adjustment,
);

/// Test fixture for workout execution completion result.
WorkoutExecutionResult createWorkoutExecutionAwaitingCompletionResult({
  WorkoutLoadAdjustment? adjustment,
}) => WorkoutExecutionResult(
  nextExercise: null,
  isAwaitingCompletion: true,
  adjustment: adjustment,
);

/// Test fixture for workout load adjustment.
WorkoutLoadAdjustment createWorkoutLoadAdjustment({
  String type = 'increase',
  double? newWeight = 66.5,
}) => WorkoutLoadAdjustment(
  type: type,
  newWeight: newWeight,
);

/// Test fixture for Dio bad response exception.
DioException createWorkoutsDioBadResponseException({
  required String path,
  required int statusCode,
  required String code,
  String message = 'error_message',
}) {
  final requestOptions = RequestOptions(path: path);
  return DioException(
    requestOptions: requestOptions,
    type: DioExceptionType.badResponse,
    response: Response<Map<String, dynamic>>(
      requestOptions: requestOptions,
      statusCode: statusCode,
      data: {
        'code': code,
        'message': message,
      },
    ),
  );
}
