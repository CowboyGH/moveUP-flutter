import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api_paths.dart';
import '../dto/fitness_start_references_response_dto.dart';
import '../dto/save_user_parameter_step_response_dto.dart';

part 'fitness_start_api_client.g.dart';

/// Retrofit API client for the Fitness Start quiz flow.
@RestApi()
abstract class FitnessStartApiClient {
  /// Creates an instance of [FitnessStartApiClient].
  factory FitnessStartApiClient(Dio dio, {String? baseUrl}) = _FitnessStartApiClient;

  /// Returns all Fitness Start references required by the quiz.
  @GET(ApiPaths.userParameterReferences)
  Future<FitnessStartReferencesResponseDto> getReferences();

  /// Saves the selected training goal.
  @POST(ApiPaths.userParameterGoal)
  Future<SaveUserParameterStepResponseDto> saveGoal(@Body() Map<String, dynamic> request);

  /// Saves anthropometry data.
  @POST(ApiPaths.userParameterAnthropometry)
  Future<SaveUserParameterStepResponseDto> saveAnthropometry(
    @Body() Map<String, dynamic> request,
  );

  /// Saves the selected preparation level.
  @POST(ApiPaths.userParameterLevel)
  Future<SaveUserParameterStepResponseDto> saveLevel(@Body() Map<String, dynamic> request);
}
