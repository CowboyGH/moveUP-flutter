import 'package:dio/dio.dart';

import '../../services/token_storage/token_storage.dart';
import '../api_paths.dart';

/// typedef for the refresh token call.
typedef RefreshCall = Future<Response<dynamic>> Function(String accessToken);

/// Interceptor for handling authentication and token refresh.
final class AuthInterceptor extends QueuedInterceptor {
  final TokenStorage _tokenStorage;
  final Dio _dio;
  final RefreshCall _refreshCall;

  /// Creates an instance of [AuthInterceptor].
  AuthInterceptor(
    this._tokenStorage,
    this._dio, {
    required RefreshCall refreshCall,
  }) : _refreshCall = refreshCall;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final response = err.response;
    final responseDataCode = _extractCode(response?.data);
    final requestOptions = err.requestOptions;
    if (response != null &&
        response.statusCode == 401 &&
        (responseDataCode == 'session_expired_inactivity' ||
            responseDataCode == 'token_expired' ||
            responseDataCode == 'unauthorized') &&
        requestOptions.path != ApiPaths.refresh &&
        requestOptions.extra['retried'] != true) {
      try {
        final currentAccessToken = await _tokenStorage.getAccessToken();
        if (currentAccessToken == null || currentAccessToken.isEmpty) {
          return handler.next(err);
        }
        final refreshResponse = await _refreshCall(currentAccessToken);
        if (refreshResponse.statusCode == 200) {
          final newAccessToken = switch (refreshResponse.data) {
            {'access_token': final String token} => token,
            _ => null,
          };
          if (newAccessToken == null || newAccessToken.isEmpty) {
            return handler.next(err);
          }
          await _tokenStorage.saveAccessToken(newAccessToken);

          requestOptions.extra['retried'] = true;
          requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

          final retryResponse = await _dio.fetch(requestOptions);
          return handler.resolve(retryResponse);
        }
        return handler.next(err);
      } on DioException catch (e) {
        final refreshCode = _extractCode(e.response?.data);
        if (e.response?.statusCode == 401 && refreshCode == 'session_expired_absolute') {
          await _tokenStorage.deleteAccessToken();
        }
        return handler.next(e);
      } catch (e) {
        return handler.next(err);
      }
    } else {
      if (response != null &&
          response.statusCode == 401 &&
          responseDataCode == 'session_expired_absolute') {
        await _tokenStorage.deleteAccessToken();
      }
      return handler.next(err);
    }
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.headers.containsKey('Authorization')) {
      return handler.next(options);
    }

    final accessToken = await _tokenStorage.getAccessToken();
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    return handler.next(options);
  }

  String? _extractCode(Object? data) {
    return switch (data) {
      {'code': final String code} => code,
      _ => null,
    };
  }
}
