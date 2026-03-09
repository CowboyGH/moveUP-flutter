import 'package:dio/dio.dart';
import 'package:moveup_flutter/features/auth/data/dto/user_dto.dart';

// TODO: refactor parameters
/// Test fixture for user DTO.
UserDto createUserDto({
  int id = 1,
  String name = 'name',
  required String email,
  String? avatar = 'avatar',
  int roleId = 1,
  String? emailVerifiedAt = 'emailVerifiedAt',
  String updatedAt = 'updatedAt',
  String createdAt = 'createdAt',
}) => UserDto(
  id: id,
  name: name,
  email: email,
  avatar: avatar,
  roleId: roleId,
  emailVerifiedAt: emailVerifiedAt,
  updatedAt: updatedAt,
  createdAt: createdAt,
);

/// Test fixture for Dio bad response exception.
DioException createDioBadResponseException({
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
