import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api_paths.dart';
import '../dto/change_password_request_dto.dart';
import '../dto/profile_user_response_dto.dart';
import '../dto/update_profile_request_dto.dart';

part 'profile_api_client.g.dart';

/// Retrofit API client for authenticated profile operations.
@RestApi()
abstract class ProfileApiClient {
  /// Creates an instance of [ProfileApiClient].
  factory ProfileApiClient(Dio dio, {String? baseUrl}) = _ProfileApiClient;

  /// Returns the authenticated profile payload.
  @GET(ApiPaths.profile)
  Future<ProfileUserResponseDto> getProfile();

  /// Updates the authenticated user profile fields.
  @PUT(ApiPaths.profile)
  Future<void> updateProfile(@Body() UpdateProfileRequestDto request);

  /// Deletes the authenticated user profile.
  @DELETE(ApiPaths.profile)
  Future<void> deleteProfile();

  /// Changes the authenticated user password.
  @POST(ApiPaths.profileChangePassword)
  Future<void> changePassword(@Body() ChangePasswordRequestDto request);

  /// Uploads or replaces the authenticated user avatar.
  @MultiPart()
  @POST(ApiPaths.profileAvatar)
  Future<void> uploadAvatar(@Part(name: 'avatar') MultipartFile avatar);
}
