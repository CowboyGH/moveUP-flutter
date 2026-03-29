import 'package:dio/dio.dart';
import 'package:moveup_flutter/features/auth/domain/entities/user.dart';
import 'package:moveup_flutter/features/profile/data/dto/profile_user_data_dto.dart';
import 'package:moveup_flutter/features/profile/data/dto/profile_user_dto.dart';
import 'package:moveup_flutter/features/profile/data/dto/profile_user_response_dto.dart';

const testProfileUserId = 1;
const testProfileUserName = 'name';
const testProfileUserEmail = 'tests@mail.com';
const testProfileUserAvatar = 'avatar.jpg';
const testProfileUserCreatedAt = '2026-01-01T10:00:00.000000Z';
const testProfileUserEmailVerified = true;

/// Test fixture for a shared authenticated [User].
User createProfileUser({
  int id = testProfileUserId,
  String name = testProfileUserName,
  String email = testProfileUserEmail,
  String? avatar = testProfileUserAvatar,
}) => User(
  id: id,
  name: name,
  email: email,
  avatar: avatar,
);

/// Test fixture for [ProfileUserDto].
ProfileUserDto createProfileUserDto({
  int id = testProfileUserId,
  String name = testProfileUserName,
  String email = testProfileUserEmail,
  String? avatarUrl = testProfileUserAvatar,
  String createdAt = testProfileUserCreatedAt,
  bool emailVerified = testProfileUserEmailVerified,
}) => ProfileUserDto(
  id: id,
  name: name,
  email: email,
  avatarUrl: avatarUrl,
  createdAt: createdAt,
  emailVerified: emailVerified,
);

/// Test fixture for [ProfileUserResponseDto].
ProfileUserResponseDto createProfileUserResponseDto({
  ProfileUserDto? user,
}) => ProfileUserResponseDto(
  data: ProfileUserDataDto(
    user: user ?? createProfileUserDto(),
  ),
);

/// Test fixture for Dio bad response exception.
DioException createProfileDioBadResponseException({
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
