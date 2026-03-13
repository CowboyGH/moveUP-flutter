import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api_paths.dart';
import '../dto/forgot_password_request_dto.dart';
import '../dto/login_request_dto.dart';
import '../dto/login_response_dto.dart';
import '../dto/me_response_dto.dart';
import '../dto/register_request_dto.dart';
import '../dto/register_response_dto.dart';
import '../dto/reset_password_request_dto.dart';
import '../dto/resend_verification_code_request_dto.dart';
import '../dto/verify_email_request_dto.dart';
import '../dto/verify_email_response_dto.dart';
import '../dto/verify_reset_code_request_dto.dart';

part 'auth_api_client.g.dart';

/// Retrofit API client for making authentication requests.
@RestApi()
abstract class AuthApiClient {
  /// Creates an instance of [AuthApiClient].
  factory AuthApiClient(Dio dio, {String? baseUrl}) = _AuthApiClient;

  /// Sends login request and returns auth data.
  @POST(ApiPaths.login)
  Future<LoginResponseDto> login(@Body() LoginRequestDto request);

  /// Sends register request and returns registered user payload.
  @POST(ApiPaths.register)
  Future<RegisterResponseDto> register(@Body() RegisterRequestDto request);

  /// Sends logout request.
  @POST(ApiPaths.logout)
  Future<void> logout();

  /// Sends forgot password request.
  @POST(ApiPaths.forgotPassword)
  Future<void> forgotPassword(@Body() ForgotPasswordRequestDto request);

  /// Sends verify email request and returns auth data.
  @POST(ApiPaths.verifyEmail)
  Future<VerifyEmailResponseDto> verifyEmail(@Body() VerifyEmailRequestDto request);

  /// Sends resend verification code request.
  @POST(ApiPaths.resendVerificationCode)
  Future<void> resendVerificationCode(@Body() ResendVerificationCodeRequestDto request);

  /// Sends resend reset code request.
  @POST(ApiPaths.resendResetCode)
  Future<void> resendResetCode(@Body() ResendVerificationCodeRequestDto request);

  /// Sends verify reset code request.
  @POST(ApiPaths.verifyResetCode)
  Future<void> verifyResetCode(@Body() VerifyResetCodeRequestDto request);

  /// Sends reset password request.
  @POST(ApiPaths.resetPassword)
  Future<void> resetPassword(@Body() ResetPasswordRequestDto request);

  /// Returns current authorized user profile.
  @GET(ApiPaths.me)
  Future<MeResponseDto> me();
}
