import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moveup_flutter/core/failures/network/network_failure.dart';
import 'package:moveup_flutter/core/network/mappers/dio_exception_mapper.dart';

void main() {
  final requestOptions = RequestOptions(path: '/test');

  group('DioExceptionMapper.toNetworkFailure', () {
    test('toNetworkFailure returns ConnectionTimeoutFailure for connectionTimeout', () {
      // Arrange
      final exception = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.connectionTimeout,
      );

      // Act
      final failure = exception.toNetworkFailure();

      // Assert
      expect(failure, isA<ConnectionTimeoutFailure>());

      expect(failure.parentException, exception);
      expect(failure.code, 'connection_timeout');
      expect(failure.message, isNotEmpty);
    });

    test('toNetworkFailure returns NoNetworkFailure for connectionError', () {
      // Arrange
      final exception = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.connectionError,
      );

      // Act
      final failure = exception.toNetworkFailure();

      // Assert
      expect(failure, isA<NoNetworkFailure>());

      expect(failure.parentException, exception);
      expect(failure.code, 'no_network');
      expect(failure.message, isNotEmpty);
    });

    test('toNetworkFailure returns UnknownNetworkFailure for badResponse with null statusCode', () {
      // Arrange

      final response = Response(
        requestOptions: requestOptions,
        // ignore: avoid_redundant_argument_values
        statusCode: null,
      );

      final exception = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.badResponse,
        response: response,
      );

      // Act
      final failure = exception.toNetworkFailure();

      // Assert
      expect(failure, isA<UnknownNetworkFailure>());

      expect(failure.parentException, exception);
      expect(failure.code, 'unknown_network');
      expect(failure.message, isNotEmpty);
    });

    test('toNetworkFailure maps badResponse status codes to expected failures', () {
      const statusCases = [
        (
          statusCode: 400,
          expectedType: BadRequestFailure,
          expectedCode: 'bad_request',
        ),
        (
          statusCode: 401,
          expectedType: UnauthorizedFailure,
          expectedCode: 'unauthorized',
        ),
        (
          statusCode: 403,
          expectedType: ForbiddenFailure,
          expectedCode: 'forbidden',
        ),
        (
          statusCode: 404,
          expectedType: NotFoundFailure,
          expectedCode: 'not_found',
        ),
        (
          statusCode: 409,
          expectedType: ConflictFailure,
          expectedCode: 'conflict',
        ),
        (
          statusCode: 429,
          expectedType: RateLimitedFailure,
          expectedCode: 'rate_limited',
        ),
        (
          statusCode: 500,
          expectedType: ServerErrorFailure,
          expectedCode: 'server_error',
        ),
      ];

      for (final statusCase in statusCases) {
        // Arrange
        final response = Response(
          requestOptions: requestOptions,
          statusCode: statusCase.statusCode,
        );

        final exception = DioException(
          requestOptions: requestOptions,
          type: DioExceptionType.badResponse,
          response: response,
        );

        // Act
        final failure = exception.toNetworkFailure();

        // Assert
        expect(failure.runtimeType, statusCase.expectedType);
        expect(failure.code, statusCase.expectedCode);
        expect(failure.parentException, exception);
        expect(failure.message, isNotEmpty);
      }
    });

    test('toNetworkFailure returns ValidationFailure with field errors for status 422', () {
      // Arrange
      final response = Response<Map<String, dynamic>>(
        requestOptions: requestOptions,
        statusCode: 422,
        data: {
          'code': 'validation_failed',
          'message': 'Validation error',
          'errors': {
            'email': ['invalid email'],
          },
        },
      );

      final exception = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.badResponse,
        response: response,
      );

      // Act
      final failure = exception.toNetworkFailure();

      // Assert
      expect(failure, isA<ValidationFailure>());
      expect((failure as ValidationFailure).errors['email'], ['invalid email']);

      expect(failure.parentException, exception);
      expect(failure.code, 'validation_failed');
      expect(failure.message, isNotEmpty);
    });

    test('toNetworkFailure returns UnknownNetworkFailure for unsupported badResponse status', () {
      // Arrange
      final response = Response<Map<String, dynamic>>(
        requestOptions: requestOptions,
        statusCode: 428,
      );

      final exception = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.badResponse,
        response: response,
      );

      // Act
      final failure = exception.toNetworkFailure();

      // Assert
      expect(failure, isA<UnknownNetworkFailure>());
      expect(failure.parentException, exception);
      expect(failure.code, 'unknown_network');
      expect(failure.message, isNotEmpty);
    });

    test('toNetworkFailure returns UnknownNetworkFailure for unknown DioException type', () {
      // Arrange
      final exception = DioException(
        requestOptions: requestOptions,
        // ignore: avoid_redundant_argument_values
        type: DioExceptionType.unknown,
      );

      // Act
      final failure = exception.toNetworkFailure();

      // Assert
      expect(failure, isA<UnknownNetworkFailure>());

      expect(failure.parentException, exception);
      expect(failure.code, 'unknown_network');
      expect(failure.message, isNotEmpty);
    });
  });
}
