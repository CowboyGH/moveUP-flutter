import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api_paths.dart';
import '../dto/change_password_request_dto.dart';
import '../dto/focused/profile_active_subscription_response_dto.dart';
import '../dto/focused/profile_history_response_dto.dart';
import '../dto/focused/profile_phase_response_dto.dart';
import '../dto/focused/profile_user_only_response_dto.dart';
import '../dto/focused/profile_user_parameters_response_dto.dart';
import '../dto/profile_user_response_dto.dart';
import '../dto/update_profile_request_dto.dart';

part 'profile_api_client.g.dart';

/// Retrofit API client for authenticated profile operations.
@RestApi()
abstract class ProfileApiClient {
  /// Creates an instance of [ProfileApiClient].
  factory ProfileApiClient(Dio dio, {String? baseUrl}) = _ProfileApiClient;

  /// Returns the aggregate authenticated profile payload (legacy monolithic endpoint).
  @GET(ApiPaths.profile)
  Future<ProfileUserResponseDto> getProfile();

  /// Returns the focused authenticated user payload (id, name, email, avatar).
  @GET(ApiPaths.profileUser)
  Future<ProfileUserOnlyResponseDto> getUser();

  /// Returns the focused active subscription snapshot.
  @GET(ApiPaths.profileActiveSubscription)
  Future<ProfileActiveSubscriptionResponseDto> getActiveSubscription();

  /// Returns the focused current phase snapshot.
  @GET(ApiPaths.profilePhase)
  Future<ProfilePhaseResponseDto> getPhase();

  /// Returns the focused user parameters display snapshot.
  @GET(ApiPaths.profileUserParameters)
  Future<ProfileUserParametersResponseDto> getProfileUserParameters();

  /// Returns the focused profile history payload (workouts + tests arrays).
  @GET(ApiPaths.profileHistory)
  Future<ProfileHistoryResponseDto> getHistory();

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
