import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../dto/login_request_dto.dart';
import '../dto/login_response_dto.dart';

part 'auth_api_client.g.dart';

/// Retrofit API client for making authentication requests.
@RestApi()
abstract class AuthApiClient {
  /// Creates an instance of [AuthApiClient].
  factory AuthApiClient(Dio dio, {String? baseUrl}) = _AuthApiClient;

  /// Sends login request and returns auth data.
  @POST('/login')
  Future<LoginResponseDto> login(@Body() LoginRequestDto request);
}
