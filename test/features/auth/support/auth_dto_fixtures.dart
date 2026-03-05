import 'package:moveup_flutter/features/auth/data/dto/login_response_dto.dart';
import 'package:moveup_flutter/features/auth/data/dto/login_session_dto.dart';
import 'package:moveup_flutter/features/auth/data/dto/user_dto.dart';

/// Test fixture for login session DTO.
LoginSessionDto createLoginSessionDto({
  int lifetimeDays = 1,
  int inactivityLimitDays = 1,
  int accessTokenExpiresInMinutes = 1,
}) => LoginSessionDto(
  lifetimeDays: lifetimeDays,
  inactivityLimitDays: inactivityLimitDays,
  accessTokenExpiresInMinutes: accessTokenExpiresInMinutes,
);

/// Test fixture for user DTO.
UserDto createUserDto({
  int id = 1,
  String name = 'name',
  required String email,
  String? avatar = 'avatar',
  int roleId = 1,
  String emailVerifiedAt = 'emailVerifiedAt',
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

/// Test fixture for login response DTO.
LoginResponseDto createLoginResponseDto({
  bool success = true,
  required String accessToken,
  String tokenType = 'bearer',
  int expiresIn = 1,
  int refreshExpiresIn = 1,
  required LoginSessionDto session,
  required UserDto user,
}) => LoginResponseDto(
  success: success,
  accessToken: accessToken,
  tokenType: tokenType,
  expiresIn: expiresIn,
  refreshExpiresIn: refreshExpiresIn,
  session: session,
  user: user,
);
