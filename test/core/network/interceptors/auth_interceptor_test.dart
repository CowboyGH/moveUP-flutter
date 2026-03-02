import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/network/api_paths.dart';
import 'package:moveup_flutter/core/network/interceptors/auth_interceptor.dart';
import 'package:moveup_flutter/core/services/token_storage/token_storage.dart';

import 'auth_interceptor_test.mocks.dart';

@GenerateNiceMocks([MockSpec<TokenStorage>(), MockSpec<Dio>()])
void main() {
  late TokenStorage tokenStorage;
  late Dio dio;

  const testPath = '/test';

  setUp(() {
    tokenStorage = MockTokenStorage();
    dio = MockDio();
  });

  final refreshSuccessResponse = Response<Map<String, dynamic>>(
    requestOptions: RequestOptions(path: ApiPaths.refresh),
    statusCode: 200,
    data: {'access_token': 'new_token'},
  );

  group('AuthInterceptor.onRequest', () {
    late AuthInterceptor interceptor;

    setUp(() {
      interceptor = AuthInterceptor(
        tokenStorage,
        dio,
        refreshCall: (_) async => refreshSuccessResponse,
      );
    });

    test('adds Authorization when token exists', () async {
      // Arrange
      const testToken = 'test_token';
      when(tokenStorage.getAccessToken()).thenAnswer((_) async => testToken);

      final options = RequestOptions(path: testPath);
      final handler = _TestRequestHandler();

      // Act
      interceptor.onRequest(options, handler);
      await Future.delayed(Duration.zero);

      // Assert
      expect(handler.nextCount, 1);
      expect(handler.nextOptions?.headers['Authorization'], 'Bearer $testToken');
      verify(tokenStorage.getAccessToken()).called(1);
      verifyNoMoreInteractions(tokenStorage);
    });

    test('does not overwrite existing Authorization header', () async {
      // Arrange
      const existingToken = 'existing_token';
      final options = RequestOptions(
        path: testPath,
        headers: {'Authorization': 'Bearer $existingToken'},
      );
      final handler = _TestRequestHandler();

      // Act
      interceptor.onRequest(options, handler);
      await Future.delayed(Duration.zero);

      // Assert
      expect(handler.nextCount, 1);
      expect(handler.nextOptions?.headers['Authorization'], 'Bearer $existingToken');
      verifyNever(tokenStorage.getAccessToken());
    });
  });

  group('AuthInterceptor.onError', () {
    test('passes through when refresh response has no access_token', () async {
      // Arrange
      when(tokenStorage.getAccessToken()).thenAnswer((_) async => 'old_token');
      final refreshSuccessResponseWithoutCode = Response<Map<String, dynamic>>(
        requestOptions: RequestOptions(path: ApiPaths.refresh),
        statusCode: 200,
        data: <String, dynamic>{},
      );
      var refreshCallCount = 0;
      final interceptor = AuthInterceptor(
        tokenStorage,
        dio,
        refreshCall: (_) async {
          refreshCallCount++;
          return refreshSuccessResponseWithoutCode;
        },
      );
      final err = _buildDioException(
        statusCode: 401,
        code: 'token_expired',
        path: testPath,
      );
      final handler = _TestErrorHandler();

      // Act
      interceptor.onError(err, handler);
      await Future.delayed(Duration.zero);

      // Assert
      expect(refreshCallCount, 1);
      verify(tokenStorage.getAccessToken()).called(1);
      verifyNever(tokenStorage.saveAccessToken('new_token'));
      verifyNever(dio.fetch(err.requestOptions));
      expect(handler.resolveCount, 0);
      expect(handler.nextCount, 1);
      expect(handler.nextError, err);
    });

    test('skips refresh when getAccessToken returns null', () async {
      // Arrange
      when(tokenStorage.getAccessToken()).thenAnswer((_) async => null);

      var refreshCallCount = 0;
      final interceptor = AuthInterceptor(
        tokenStorage,
        dio,
        refreshCall: (_) async {
          refreshCallCount++;
          return refreshSuccessResponse;
        },
      );
      final err = _buildDioException(
        statusCode: 401,
        code: 'token_expired',
        path: testPath,
      );
      final handler = _TestErrorHandler();

      // Act
      interceptor.onError(err, handler);
      await Future.delayed(Duration.zero);

      // Assert
      expect(refreshCallCount, 0);
      verify(tokenStorage.getAccessToken()).called(1);
      verifyNever(tokenStorage.saveAccessToken('new_token'));
      verifyNever(dio.fetch(err.requestOptions));
      expect(handler.resolveCount, 0);
      expect(handler.nextCount, 1);
      expect(handler.nextError, err);
    });

    test('401 token_expired refreshes token and retries request', () async {
      // Arrange
      when(tokenStorage.getAccessToken()).thenAnswer((_) async => 'old_token');
      when(tokenStorage.saveAccessToken('new_token')).thenAnswer((_) async {});

      final retryResponse = Response<Map<String, dynamic>>(
        requestOptions: RequestOptions(path: testPath),
        statusCode: 200,
        data: {'success': true},
      );
      final err = _buildDioException(
        statusCode: 401,
        code: 'token_expired',
        path: testPath,
      );
      when(dio.fetch(err.requestOptions)).thenAnswer((_) async => retryResponse);

      var refreshCallCount = 0;
      final interceptor = AuthInterceptor(
        tokenStorage,
        dio,
        refreshCall: (_) async {
          refreshCallCount++;
          return refreshSuccessResponse;
        },
      );

      final handler = _TestErrorHandler();

      // Act
      interceptor.onError(err, handler);
      await Future.delayed(Duration.zero);

      // Assert
      expect(refreshCallCount, 1);
      verify(tokenStorage.getAccessToken()).called(1);
      verify(tokenStorage.saveAccessToken('new_token')).called(1);
      verifyNever(tokenStorage.deleteAccessToken());

      verify(dio.fetch(err.requestOptions)).called(1);
      expect(err.requestOptions.extra['retried'], true);
      expect(err.requestOptions.headers['Authorization'], 'Bearer new_token');

      expect(handler.resolveCount, 1);
      expect(handler.nextCount, 0);
      expect(handler.resolvedResponse?.statusCode, 200);
      expect(handler.resolvedResponse?.data, {'success': true});
    });

    test('refresh 401 session_expired_absolute deletes token', () async {
      // Arrange
      when(tokenStorage.getAccessToken()).thenAnswer((_) async => 'old_token');
      when(tokenStorage.deleteAccessToken()).thenAnswer((_) async {});

      final refreshError = _buildDioException(
        statusCode: 401,
        code: 'session_expired_absolute',
        path: ApiPaths.refresh,
      );

      final interceptor = AuthInterceptor(
        tokenStorage,
        dio,
        refreshCall: (_) async => throw refreshError,
      );
      final err = _buildDioException(
        statusCode: 401,
        code: 'token_expired',
        path: testPath,
      );
      final handler = _TestErrorHandler();

      // Act
      interceptor.onError(err, handler);
      await Future.delayed(Duration.zero);

      // Assert
      verify(tokenStorage.getAccessToken()).called(1);
      verify(tokenStorage.deleteAccessToken()).called(1);
      verifyNever(dio.fetch<dynamic>(err.requestOptions));
      expect(handler.resolveCount, 0);
      expect(handler.nextCount, 1);
      expect(handler.nextError, refreshError);
    });

    test('skips refresh when retried is already true', () async {
      // Arrange
      var refreshCallCount = 0;
      final interceptor = AuthInterceptor(
        tokenStorage,
        dio,
        refreshCall: (_) async {
          refreshCallCount++;
          return refreshSuccessResponse;
        },
      );
      final err = _buildDioException(
        statusCode: 401,
        code: 'token_expired',
        path: testPath,
        retried: true,
      );
      final handler = _TestErrorHandler();

      // Act
      interceptor.onError(err, handler);
      await Future.delayed(Duration.zero);

      // Assert
      expect(refreshCallCount, 0);
      verifyNever(tokenStorage.getAccessToken());
      verifyNever(dio.fetch(err.requestOptions));
      expect(handler.resolveCount, 0);
      expect(handler.nextCount, 1);
      expect(handler.nextError, err);
    });

    test('passes through non-401 errors', () async {
      // Arrange
      var refreshCallCount = 0;
      final interceptor = AuthInterceptor(
        tokenStorage,
        dio,
        refreshCall: (_) async {
          refreshCallCount++;
          return refreshSuccessResponse;
        },
      );
      final err = _buildDioException(
        statusCode: 500,
        code: 'server_error',
        path: testPath,
      );
      final handler = _TestErrorHandler();

      // Act
      interceptor.onError(err, handler);
      await Future.delayed(Duration.zero);

      // Assert
      expect(refreshCallCount, 0);
      verifyNever(tokenStorage.getAccessToken());
      expect(handler.resolveCount, 0);
      expect(handler.nextCount, 1);
      expect(handler.nextError, err);
    });

    test('401 session_expired_absolute on original request deletes token', () async {
      // Arrange
      when(tokenStorage.deleteAccessToken()).thenAnswer((_) async {});
      final interceptor = AuthInterceptor(
        tokenStorage,
        dio,
        refreshCall: (_) async => refreshSuccessResponse,
      );
      final err = _buildDioException(
        statusCode: 401,
        code: 'session_expired_absolute',
        path: testPath,
      );
      final handler = _TestErrorHandler();

      // Act
      interceptor.onError(err, handler);
      await Future.delayed(Duration.zero);

      // Assert
      verify(tokenStorage.deleteAccessToken()).called(1);
      verifyNever(tokenStorage.getAccessToken());
      verifyNever(dio.fetch(err.requestOptions));
      expect(handler.resolveCount, 0);
      expect(handler.nextCount, 1);
      expect(handler.nextError, err);
    });

    test('does not refresh /refresh request itself', () async {
      // Arrange
      var refreshCallCount = 0;
      final interceptor = AuthInterceptor(
        tokenStorage,
        dio,
        refreshCall: (_) async {
          refreshCallCount++;
          return refreshSuccessResponse;
        },
      );
      final err = _buildDioException(
        statusCode: 401,
        code: 'token_expired',
        path: ApiPaths.refresh,
      );
      final handler = _TestErrorHandler();

      // Act
      interceptor.onError(err, handler);
      await Future.delayed(Duration.zero);

      // Assert
      expect(refreshCallCount, 0);
      verifyNever(tokenStorage.getAccessToken());
      verifyNever(dio.fetch(err.requestOptions));
      expect(handler.resolveCount, 0);
      expect(handler.nextCount, 1);
      expect(handler.nextError, err);
    });
  });
}

DioException _buildDioException({
  required int statusCode,
  required String code,
  required String path,
  bool retried = false,
}) {
  final requestOptions = RequestOptions(
    path: path,
    extra: retried ? <String, dynamic>{'retried': true} : <String, dynamic>{},
  );
  return DioException(
    requestOptions: requestOptions,
    type: DioExceptionType.badResponse,
    response: Response<Map<String, dynamic>>(
      requestOptions: requestOptions,
      statusCode: statusCode,
      data: <String, dynamic>{'code': code},
    ),
  );
}

final class _TestRequestHandler extends RequestInterceptorHandler {
  RequestOptions? nextOptions;
  int nextCount = 0;

  @override
  void next(RequestOptions requestOptions) {
    nextCount++;
    nextOptions = requestOptions;
  }
}

final class _TestErrorHandler extends ErrorInterceptorHandler {
  DioException? nextError;
  Response<dynamic>? resolvedResponse;
  int nextCount = 0;
  int resolveCount = 0;

  @override
  void next(DioException error) {
    nextCount++;
    nextError = error;
  }

  @override
  void resolve(Response<dynamic> response) {
    resolveCount++;
    resolvedResponse = response;
  }
}
