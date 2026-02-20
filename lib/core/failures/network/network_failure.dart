import '../app_failure.dart';

/// Network application error.
sealed class NetworkFailure extends AppFailure {
  /// Stable error code for business logic mapping.
  abstract final String code;

  /// HTTP status code when available.
  final int? statusCode;

  /// Creates an instance of [NetworkFailure].
  const NetworkFailure(
    super.message, {
    this.statusCode,
    super.parentException,
    super.stackTrace,
  });
}

/// No internet connection error.
final class NoNetworkFailure extends NetworkFailure {
  @override
  final String code = 'no_network';

  /// Creates an instance of [NoNetworkFailure].
  const NoNetworkFailure({
    super.parentException,
    super.stackTrace,
  }) : super('Отсутствует интернет-соединение');
}

/// Request connection timeout error.
final class ConnectionTimeoutFailure extends NetworkFailure {
  @override
  final String code = 'connection_timeout';

  /// Creates an instance of [ConnectionTimeoutFailure].
  const ConnectionTimeoutFailure({
    super.parentException,
    super.stackTrace,
  }) : super('Превышено время ожидания подключения');
}

/// Request send timeout error.
final class SendTimeoutFailure extends NetworkFailure {
  @override
  final String code = 'send_timeout';

  /// Creates an instance of [SendTimeoutFailure].
  const SendTimeoutFailure({
    super.parentException,
    super.stackTrace,
  }) : super('Превышено время отправки запроса');
}

/// Request receive timeout error.
final class ReceiveTimeoutFailure extends NetworkFailure {
  @override
  final String code = 'receive_timeout';

  /// Creates an instance of [ReceiveTimeoutFailure].
  const ReceiveTimeoutFailure({
    super.parentException,
    super.stackTrace,
  }) : super('Превышено время ожидания ответа');
}

/// Request cancelled error.
final class RequestCancelledFailure extends NetworkFailure {
  @override
  final String code = 'request_cancelled';

  /// Creates an instance of [RequestCancelledFailure].
  const RequestCancelledFailure({
    super.parentException,
    super.stackTrace,
  }) : super('Запрос был отменен');
}

/// HTTP 400 error.
final class BadRequestFailure extends NetworkFailure {
  @override
  final String code;

  /// Creates an instance of [BadRequestFailure].
  const BadRequestFailure({
    this.code = 'bad_request',
    String message = 'Некорректный запрос',
    super.parentException,
    super.stackTrace,
  }) : super(message, statusCode: 400);
}

/// HTTP 401 error.
final class UnauthorizedFailure extends NetworkFailure {
  @override
  final String code;

  /// Creates an instance of [UnauthorizedFailure].
  const UnauthorizedFailure({
    this.code = 'unauthorized',
    String message = 'Не авторизован',
    super.parentException,
    super.stackTrace,
  }) : super(message, statusCode: 401);
}

/// HTTP 403 error.
final class ForbiddenFailure extends NetworkFailure {
  @override
  final String code;

  /// Creates an instance of [ForbiddenFailure].
  const ForbiddenFailure({
    this.code = 'forbidden',
    String message = 'Доступ запрещен',
    super.parentException,
    super.stackTrace,
  }) : super(message, statusCode: 403);
}

/// HTTP 404 error.
final class NotFoundFailure extends NetworkFailure {
  @override
  final String code;

  /// Creates an instance of [NotFoundFailure].
  const NotFoundFailure({
    this.code = 'not_found',
    String message = 'Ресурс не найден',
    super.parentException,
    super.stackTrace,
  }) : super(message, statusCode: 404);
}

/// HTTP 409 error.
final class ConflictFailure extends NetworkFailure {
  @override
  final String code;

  /// Creates an instance of [ConflictFailure].
  const ConflictFailure({
    this.code = 'conflict',
    String message = 'Конфликт данных',
    super.parentException,
    super.stackTrace,
  }) : super(message, statusCode: 409);
}

/// HTTP 422 error.
final class ValidationFailure extends NetworkFailure {
  @override
  final String code;

  /// Detailed validation errors by field.
  final Map<String, List<String>>? errors;

  /// Creates an instance of [ValidationFailure].
  const ValidationFailure({
    this.code = 'validation_failed',
    String message = 'Ошибка валидации',
    this.errors,
    super.parentException,
    super.stackTrace,
  }) : super(message, statusCode: 422);
}

/// HTTP 429 error.
final class RateLimitedFailure extends NetworkFailure {
  @override
  final String code;

  /// Creates an instance of [RateLimitedFailure].
  const RateLimitedFailure({
    this.code = 'rate_limited',
    String message = 'Слишком много запросов',
    super.parentException,
    super.stackTrace,
  }) : super(message, statusCode: 429);
}

/// HTTP 500 error.
final class ServerErrorFailure extends NetworkFailure {
  @override
  final String code;

  /// Creates an instance of [ServerErrorFailure].
  const ServerErrorFailure({
    this.code = 'server_error',
    String message = 'Внутренняя ошибка сервера',
    super.parentException,
    super.stackTrace,
  }) : super(message, statusCode: 500);
}

/// HTTP 503 error.
final class ServiceUnavailableFailure extends NetworkFailure {
  @override
  final String code;

  /// Creates an instance of [ServiceUnavailableFailure].
  const ServiceUnavailableFailure({
    this.code = 'service_unavailable',
    String message = 'Сервис временно недоступен',
    super.parentException,
    super.stackTrace,
  }) : super(message, statusCode: 503);
}

/// HTTP 504 error.
final class GatewayTimeoutFailure extends NetworkFailure {
  @override
  final String code;

  /// Creates an instance of [GatewayTimeoutFailure].
  const GatewayTimeoutFailure({
    this.code = 'gateway_timeout',
    String message = 'Сервер не ответил вовремя',
    super.parentException,
    super.stackTrace,
  }) : super(message, statusCode: 504);
}

/// Unexpected HTTP status code.
final class UnexpectedStatusCodeFailure extends NetworkFailure {
  @override
  final String code;

  /// Creates an instance of [UnexpectedStatusCodeFailure].
  const UnexpectedStatusCodeFailure({
    required int statusCode,
    this.code = 'unexpected_status_code',
    String? message,
    super.parentException,
    super.stackTrace,
  }) : super(
         message ?? 'Неожиданный код ответа: $statusCode',
         statusCode: statusCode,
       );
}

/// Unknown network error.
final class UnknownNetworkFailure extends NetworkFailure {
  @override
  final String code = 'unknown_network';

  /// Original error message.
  final String? originalMessage;

  /// Creates an instance of [UnknownNetworkFailure].
  const UnknownNetworkFailure({
    this.originalMessage,
    super.parentException,
    super.stackTrace,
  }) : super(originalMessage ?? 'Неизвестная ошибка сети');
}
