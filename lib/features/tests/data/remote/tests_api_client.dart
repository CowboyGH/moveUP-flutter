import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api_paths.dart';
import '../../attempt/data/dto/complete_test_request_dto.dart';
import '../../attempt/data/dto/save_test_result_request_dto.dart';
import '../../attempt/data/dto/save_test_result_response_dto.dart';
import '../../attempt/data/dto/start_guest_test_response_dto.dart';
import '../../attempt/data/dto/start_test_response_dto.dart';
import '../../catalog/data/dto/testings_response_dto.dart';

part 'tests_api_client.g.dart';

/// Retrofit API client for tests catalog and test attempt requests.
@RestApi()
abstract class TestsApiClient {
  /// Creates an instance of [TestsApiClient].
  factory TestsApiClient(Dio dio, {String? baseUrl}) = _TestsApiClient;

  /// Returns all active testings available in the catalog.
  @GET(ApiPaths.testings)
  Future<TestingsResponseDto> getTestings();

  /// Starts a guest test attempt and returns the first exercise.
  @POST('${ApiPaths.guestTests}/{testing}/start')
  Future<StartGuestTestResponseDto> startGuestTest(@Path('testing') int testingId);

  /// Starts an authenticated test attempt and returns the first exercise.
  @POST('${ApiPaths.tests}/{testing}/start')
  Future<StartTestResponseDto> startTest(@Path('testing') int testingId);

  /// Stores the result for the current guest test exercise.
  @POST('${ApiPaths.guestTestAttempts}/{attempt}/result')
  Future<SaveTestResultResponseDto> saveGuestTestResult(
    @Path('attempt') String attemptId,
    @Body() SaveTestResultRequestDto request,
  );

  /// Stores the result for the current authenticated test exercise.
  @POST('${ApiPaths.testAttempts}/{attempt}/result')
  Future<SaveTestResultResponseDto> saveTestResult(
    @Path('attempt') String attemptId,
    @Body() SaveTestResultRequestDto request,
  );

  /// Completes a guest test attempt with pulse value.
  @POST('${ApiPaths.guestTestAttempts}/{attempt}/complete')
  Future<void> completeGuestTest(
    @Path('attempt') String attemptId,
    @Body() CompleteTestRequestDto request,
  );

  /// Completes an authenticated test attempt with pulse value.
  @POST('${ApiPaths.testAttempts}/{attempt}/complete')
  Future<void> completeTest(
    @Path('attempt') String attemptId,
    @Body() CompleteTestRequestDto request,
  );
}
