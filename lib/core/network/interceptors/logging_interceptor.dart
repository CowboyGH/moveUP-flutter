import 'package:dio/dio.dart';

import '../../utils/logger/app_logger.dart';

/// A simple logging interceptor for Dio.
final class LoggingInterceptor extends InterceptorsWrapper {
  /// The logger instance used for logging requests and responses.
  final AppLogger logger;

  /// Creates an instance of [LoggingInterceptor].
  LoggingInterceptor(this.logger);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logger.d('-> ${options.method} ${options.uri}');
    return handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    logger.d(
      '<- ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.uri}',
    );
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final request = err.requestOptions;
    logger.w(
      'x ${err.response?.statusCode ?? '-'} ${err.type} ${request.method} ${request.uri} ${err.message ?? ''}',
    );
    return handler.next(err);
  }
}
