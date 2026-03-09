import 'package:dio/dio.dart';
import 'package:moveup_flutter/features/auth/data/dto/user_dto.dart';

const testUserDtoId = 1;
const testUserDtoName = 'test_name';
const testUserDtoEmail = 'test_email';
const testUserDtoAvatar = 'avatar';
const testUserDtoRoleId = 1;
const testUserDtoEmailVerifiedAt = 'emailVerifiedAt';
const testUserDtoUpdatedAt = 'updatedAt';
const testUserDtoCreatedAt = 'createdAt';

/// Test fixture for user DTO.
UserDto createUserDto({
  String? avatar = testUserDtoAvatar,
}) => UserDto(
  id: testUserDtoId,
  name: testUserDtoName,
  email: testUserDtoEmail,
  avatar: avatar,
  roleId: testUserDtoRoleId,
  emailVerifiedAt: testUserDtoEmailVerifiedAt,
  updatedAt: testUserDtoUpdatedAt,
  createdAt: testUserDtoCreatedAt,
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
