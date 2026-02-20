// API Client
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../di/di.dart';
import '../utils/logger/app_logger.dart';
import 'api_paths.dart';

/// Creates and configures a Dio HTTP client.
Dio createDioClient() {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiPaths.baseUrl,
      headers: const <String, dynamic>{
        Headers.acceptHeader: Headers.jsonContentType,
        Headers.contentTypeHeader: Headers.jsonContentType,
      },
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 10),
    ),
  );

  if (kDebugMode) {
    final logger = di<AppLogger>();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          logger.d('-> ${options.method} ${options.uri}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          logger.d(
            '<- ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.uri}',
          );
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          final request = error.requestOptions;
          logger.w(
            'x ${error.response?.statusCode ?? '-'} ${error.type} ${request.method} ${request.uri} ${error.message ?? ''}',
          );
          return handler.next(error);
        },
      ),
    );
  }

  return dio;
}
