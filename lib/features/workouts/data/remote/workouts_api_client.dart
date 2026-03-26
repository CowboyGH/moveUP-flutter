import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api_paths.dart';
import '../dto/workout_details_response_dto.dart';
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
}
