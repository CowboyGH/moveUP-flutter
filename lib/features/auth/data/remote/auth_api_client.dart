import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../dto/login_request_dto.dart';
import '../dto/login_response_dto.dart';
import '../dto/me_response_dto.dart';
import '../dto/register_request_dto.dart';
import '../dto/register_response_dto.dart';
import '../dto/verify_email_request_dto.dart';
import '../dto/verify_email_response_dto.dart';

part 'auth_api_client.g.dart';

/// Retrofit API client for making authentication requests.
@RestApi()
abstract class AuthApiClient {
  /// Creates an instance of [AuthApiClient].
  factory AuthApiClient(Dio dio, {String? baseUrl}) = _AuthApiClient;

  /// Sends login request and returns auth data.
  @POST('/login')
  Future<LoginResponseDto> login(@Body() LoginRequestDto request);

  /// Sends register request and returns registered user payload.
  @POST('/register')
  Future<RegisterResponseDto> register(@Body() RegisterRequestDto request);

  /// Sends verify email request and returns auth data.
  @POST('/verify-email')
  Future<VerifyEmailResponseDto> verifyEmail(@Body() VerifyEmailRequestDto request);

  /// Returns current authorized user profile.
  @GET('/me')
  Future<MeResponseDto> me();
}
