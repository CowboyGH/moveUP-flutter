import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api_paths.dart';
import '../dto/save_exercise_result_request_dto.dart';
import '../dto/save_exercise_result_response_dto.dart';
import '../dto/workout_details_response_dto.dart';
import '../dto/workout_execution_step_response_dto.dart';
import '../dto/workouts_response_dto.dart';

part 'workouts_api_client.g.dart';

/// Retrofit API client for authenticated workouts requests.
@RestApi()
abstract class WorkoutsApiClient {
  /// Creates an instance of [WorkoutsApiClient].
  factory WorkoutsApiClient(Dio dio, {String? baseUrl}) = _WorkoutsApiClient;

  /// Returns the current user workouts overview grouped by backend statuses.
  @GET(ApiPaths.workouts)
  Future<WorkoutsResponseDto> getWorkouts();

  /// Returns workout details by [userWorkoutId].
  @GET('${ApiPaths.workoutExecution}/{userWorkout}')
  Future<WorkoutDetailsResponseDto> getWorkoutDetails(
    @Path('userWorkout') int userWorkoutId,
  );

  /// Starts a workout and returns either the first warmup or the first exercise.
  @POST(ApiPaths.workoutsStart)
  Future<WorkoutExecutionStepResponseDto> startWorkout(
    @Body() Map<String, dynamic> request,
  );

  /// Starts warmup flow for an already started workout.
  @POST('${ApiPaths.workoutExecution}/{userWorkout}/start-warmup')
  Future<WorkoutExecutionStepResponseDto> startWarmup(
    @Path('userWorkout') int userWorkoutId,
  );

  /// Returns the next warmup step or the first exercise after warmups are done.
  @POST('${ApiPaths.workoutExecution}/{userWorkout}/next-warmup')
  Future<WorkoutExecutionStepResponseDto> nextWarmup(
    @Path('userWorkout') int userWorkoutId,
    @Body() Map<String, dynamic> request,
  );

  /// Completes warmup early and returns the first workout exercise.
  @POST('${ApiPaths.workoutExecution}/{userWorkout}/complete-warmup')
  Future<WorkoutExecutionStepResponseDto> completeWarmup(
    @Path('userWorkout') int userWorkoutId,
  );

  /// Saves the current exercise result and returns the next execution payload.
  @POST('${ApiPaths.workoutExecution}/{userWorkout}/save-exercise-result')
  Future<SaveExerciseResultResponseDto> saveExerciseResult(
    @Path('userWorkout') int userWorkoutId,
    @Body() SaveExerciseResultRequestDto request,
  );

  /// Completes the current workout.
  @POST('${ApiPaths.workoutExecution}/{userWorkout}/complete')
  Future<void> completeWorkout(
    @Path('userWorkout') int userWorkoutId,
  );
}
