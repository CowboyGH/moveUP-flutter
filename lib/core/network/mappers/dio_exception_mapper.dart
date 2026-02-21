import 'package:dio/dio.dart';

import '../../failures/network/network_failure.dart';
import '../errors/error_response_dto.dart';
import '../errors/validation_error_response_dto.dart';

/// Extension to map [DioException] to domain [NetworkFailure].
extension DioExceptionMapper on DioException {
  /// Maps a [DioException] to a corresponding [NetworkFailure].
  NetworkFailure toNetworkFailure() {
    switch (type) {
      case DioExceptionType.connectionTimeout:
        return ConnectionTimeoutFailure(parentException: this, stackTrace: stackTrace);
      case DioExceptionType.sendTimeout ||
          DioExceptionType.receiveTimeout ||
          DioExceptionType.cancel ||
          DioExceptionType.connectionError:
        return NoNetworkFailure(parentException: this, stackTrace: stackTrace);
      case DioExceptionType.badResponse:
        final int? statusCode = response?.statusCode;
        // early return to avoid unnecessary parsing
        if (statusCode == null) {
          return UnknownNetworkFailure(
            originalMessage: message,
            parentException: this,
            stackTrace: stackTrace,
          );
        }

        ErrorResponseDto? errorResponse;
        ValidationErrorResponseDto? validationErrorResponse;
        if (response?.data case final Map<String, dynamic> data) {
          try {
            if (statusCode == 422) {
              validationErrorResponse = ValidationErrorResponseDto.fromJson(data);
            } else {
              errorResponse = ErrorResponseDto.fromJson(data);
            }
          } on Object {
            // ignore and fallback to default codes.
          }
        }

        final code = validationErrorResponse?.code ?? errorResponse?.code;
        return switch (statusCode) {
          400 => BadRequestFailure(
            code: code ?? 'bad_request',
            parentException: this,
            stackTrace: stackTrace,
          ),
          401 => UnauthorizedFailure(
            code: code ?? 'unauthorized',
            parentException: this,
            stackTrace: stackTrace,
          ),
          403 => ForbiddenFailure(
            code: code ?? 'forbidden',
            parentException: this,
            stackTrace: stackTrace,
          ),
          404 => NotFoundFailure(
            code: code ?? 'not_found',
            parentException: this,
            stackTrace: stackTrace,
          ),
          409 => ConflictFailure(
            code: code ?? 'conflict',
            parentException: this,
            stackTrace: stackTrace,
          ),
          422 => ValidationFailure(
            code: code ?? 'validation_failed',
            errors: validationErrorResponse?.errors ?? const <String, List<String>>{},
            parentException: this,
            stackTrace: stackTrace,
          ),
          429 => RateLimitedFailure(
            code: code ?? 'rate_limited',
            parentException: this,
            stackTrace: stackTrace,
          ),
          >= 500 && < 600 => ServerErrorFailure(
            code: code ?? 'server_error',
            parentException: this,
            stackTrace: stackTrace,
          ),
          _ => UnknownNetworkFailure(
            originalMessage: message,
            parentException: this,
            stackTrace: stackTrace,
          ),
        };
      default:
        return UnknownNetworkFailure(
          originalMessage: message,
          parentException: this,
          stackTrace: stackTrace,
        );
    }
  }
}
