import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api_paths.dart';
import '../dto/workouts_response_dto.dart';

part 'workouts_api_client.g.dart';

/// Retrofit API client for authenticated workouts overview requests.
@RestApi()
abstract class WorkoutsApiClient {
  /// Creates an instance of [WorkoutsApiClient].
  factory WorkoutsApiClient(Dio dio, {String? baseUrl}) = _WorkoutsApiClient;

  /// Returns the current user workouts overview grouped by backend statuses.
  @GET(ApiPaths.workouts)
  Future<WorkoutsResponseDto> getWorkouts();
}
