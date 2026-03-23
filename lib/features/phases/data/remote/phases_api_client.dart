import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api_paths.dart';

part 'phases_api_client.g.dart';

/// Retrofit API client for phases requests.
@RestApi()
abstract class PhasesApiClient {
  /// Creates an instance of [PhasesApiClient].
  factory PhasesApiClient(Dio dio, {String? baseUrl}) = _PhasesApiClient;

  /// Updates weekly training goal for the current onboarding flow.
  @POST(ApiPaths.userWeeklyGoal)
  Future<void> updateWeeklyGoal(@Body() Map<String, int> body);
}
