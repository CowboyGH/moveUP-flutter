import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../core/network/api_paths.dart';
import '../dto/testings_response_dto.dart';

part 'tests_api_client.g.dart';

/// Retrofit API client for tests catalog requests.
@RestApi()
abstract class TestsApiClient {
  /// Creates an instance of [TestsApiClient].
  factory TestsApiClient(Dio dio, {String? baseUrl}) = _TestsApiClient;

  /// Returns all active testings available in the catalog.
  @GET(ApiPaths.testings)
  Future<TestingsResponseDto> getTestings();
}
