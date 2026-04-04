import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api_paths.dart';
import '../dto/params/profile_current_parameters_response_dto.dart';
import '../dto/params/profile_parameters_references_response_dto.dart';
import '../dto/params/profile_parameters_request_dto.dart';

part 'profile_parameters_api_client.g.dart';

/// Retrofit API client for authenticated profile parameters requests.
@RestApi()
abstract class ProfileParametersApiClient {
  /// Creates an instance of [ProfileParametersApiClient].
  factory ProfileParametersApiClient(
    Dio dio, {
    String? baseUrl,
  }) = _ProfileParametersApiClient;

  /// Returns the canonical authenticated user parameters.
  @GET(ApiPaths.userParameterMe)
  Future<ProfileCurrentParametersResponseDto> getCurrentParameters();

  /// Returns references required by the profile parameters form.
  @GET(ApiPaths.userParameterReferences)
  Future<ProfileParametersReferencesResponseDto> getReferences();

  /// Saves the selected training goal.
  @POST(ApiPaths.userParameterGoal)
  Future<void> saveGoal(@Body() SaveProfileGoalRequestDto request);

  /// Saves anthropometry values.
  @POST(ApiPaths.userParameterAnthropometry)
  Future<void> saveAnthropometry(@Body() SaveProfileAnthropometryRequestDto request);

  /// Saves the selected preparation level.
  @POST(ApiPaths.userParameterLevel)
  Future<void> saveLevel(@Body() SaveProfileLevelRequestDto request);

  /// Saves the recommended weekly training goal.
  @POST(ApiPaths.userWeeklyGoal)
  Future<void> updateWeeklyGoal(@Body() UpdateProfileWeeklyGoalRequestDto request);
}
