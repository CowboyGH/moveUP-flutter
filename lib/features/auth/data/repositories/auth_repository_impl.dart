import 'package:dio/dio.dart';

import '../../../../core/failures/feature/auth/auth_failure.dart';
import '../../../../core/network/mappers/dio_exception_mapper.dart';
import '../../../../core/result/result.dart';
import '../../../../core/services/token_storage/token_storage.dart';
import '../../../../core/utils/logger/app_logger.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../dto/forgot_password_request_dto.dart';
import '../dto/login_request_dto.dart';
import '../dto/register_request_dto.dart';
import '../dto/resend_verification_code_request_dto.dart';
import '../dto/verify_email_request_dto.dart';
import '../dto/verify_reset_code_request_dto.dart';
import '../mappers/auth_mapper.dart';
import '../mappers/user_entity_mapper.dart';
import '../remote/auth_api_client.dart';

/// Implementation of [AuthRepository].
final class AuthRepositoryImpl implements AuthRepository {
  /// Logger for tracking authentication operations and errors.
  final AppLogger _logger;

  /// API client for making authentication requests to the backend.
  final AuthApiClient _apiClient;

  /// Secure storage for persisting auth access tokens.
  final TokenStorage _tokenStorage;

  /// Creates an instance of [AuthRepositoryImpl].
  AuthRepositoryImpl(this._logger, this._apiClient, this._tokenStorage);

  @override
  Future<Result<User, AuthFailure>> signIn(String email, String password) async {
    try {
      final request = LoginRequestDto(email: email, password: password);
      final response = await _apiClient.login(request);
      await _tokenStorage.saveAccessToken(response.accessToken);
      return Result.success(response.user.toEntity());
    } on DioException catch (e) {
      final networkFailure = e.toNetworkFailure();
      return Result.failure(networkFailure.toAuthFailure());
    } catch (e, s) {
      _logger.e('SignIn failed with unexpected error', e, s);
      return Result.failure(UnknownAuthFailure(parentException: e, stackTrace: s));
    }
  }

  @override
  Future<Result<User, AuthFailure>> signUp(String name, String email, String password) async {
    try {
      final request = RegisterRequestDto(name: name, email: email, password: password);
      final response = await _apiClient.register(request);
      return Result.success(response.user.toEntity());
    } on DioException catch (e) {
      final networkFailure = e.toNetworkFailure();
      return Result.failure(networkFailure.toAuthFailure());
    } catch (e, s) {
      _logger.e('SignUp failed with unexpected error', e, s);
      return Result.failure(UnknownAuthFailure(parentException: e, stackTrace: s));
    }
  }

  @override
  Future<Result<void, AuthFailure>> forgotPassword(String email) async {
    try {
      final request = ForgotPasswordRequestDto(email: email);
      await _apiClient.forgotPassword(request);
      return const Result.success(null);
    } on DioException catch (e) {
      final networkFailure = e.toNetworkFailure();
      return Result.failure(networkFailure.toAuthFailure());
    } catch (e, s) {
      _logger.e('ForgotPassword failed with unexpected error', e, s);
      return Result.failure(UnknownAuthFailure(parentException: e, stackTrace: s));
    }
  }

  @override
  Future<Result<void, AuthFailure>> verifyResetCode(String email, String code) async {
    try {
      final request = VerifyResetCodeRequestDto(email: email, code: code);
      await _apiClient.verifyResetCode(request);
      return const Result.success(null);
    } on DioException catch (e) {
      final networkFailure = e.toNetworkFailure();
      return Result.failure(networkFailure.toAuthFailure());
    } catch (e, s) {
      _logger.e('VerifyResetCode failed with unexpected error', e, s);
      return Result.failure(UnknownAuthFailure(parentException: e, stackTrace: s));
    }
  }

  @override
  Future<Result<User, AuthFailure>> verifyEmail(String email, String code) async {
    try {
      final request = VerifyEmailRequestDto(email: email, code: code);
      final response = await _apiClient.verifyEmail(request);
      await _tokenStorage.saveAccessToken(response.data.accessToken);
      return Result.success(response.data.user.toEntity());
    } on DioException catch (e) {
      final networkFailure = e.toNetworkFailure();
      return Result.failure(networkFailure.toAuthFailure());
    } catch (e, s) {
      _logger.e('VerifyEmail failed with unexpected error', e, s);
      return Result.failure(UnknownAuthFailure(parentException: e, stackTrace: s));
    }
  }

  @override
  Future<Result<void, AuthFailure>> resendOtpCode(String email) async {
    try {
      final request = ResendVerificationCodeRequestDto(email: email);
      await _apiClient.resendVerificationCode(request);
      return const Result.success(null);
    } on DioException catch (e) {
      final networkFailure = e.toNetworkFailure();
      return Result.failure(networkFailure.toAuthFailure());
    } catch (e, s) {
      _logger.e('ResendOtpCode failed with unexpected error', e, s);
      return Result.failure(UnknownAuthFailure(parentException: e, stackTrace: s));
    }
  }

  @override
  Future<Result<User, AuthFailure>> getCurrentUser() async {
    try {
      final response = await _apiClient.me();
      return Result.success(response.user.toEntity());
    } on DioException catch (e) {
      final networkFailure = e.toNetworkFailure();
      return Result.failure(networkFailure.toAuthFailure());
    } catch (e, s) {
      _logger.e('GetCurrentUser failed with unexpected error', e, s);
      return Result.failure(UnknownAuthFailure(parentException: e, stackTrace: s));
    }
  }
}
