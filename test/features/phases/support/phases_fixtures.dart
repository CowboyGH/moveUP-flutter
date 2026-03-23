import 'package:dio/dio.dart';

/// Test fixture for Dio bad response exception.
DioException createPhasesDioBadResponseException({
  required String path,
  required int statusCode,
  required String code,
  String message = 'error_message',
  Map<String, List<String>>? errors,
}) {
  final requestOptions = RequestOptions(path: path);
  final data = <String, dynamic>{
    'code': code,
    'message': message,
  };
  if (errors != null) {
    data['errors'] = errors;
  }

  return DioException(
    requestOptions: requestOptions,
    type: DioExceptionType.badResponse,
    response: Response<Map<String, dynamic>>(
      requestOptions: requestOptions,
      statusCode: statusCode,
      data: data,
    ),
  );
}
