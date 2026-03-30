import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../core/failures/feature/profile/profile_failure.dart';
import '../../../../core/network/mappers/dio_exception_mapper.dart';
import '../../../../core/result/result.dart';
import '../../../../core/utils/logger/app_logger.dart';
import '../../../auth/domain/entities/user.dart';
import '../../domain/entities/profile_stats_history_snapshot.dart';
import '../../domain/repositories/profile_repository.dart';
import '../dto/change_password_request_dto.dart';
import '../dto/update_profile_request_dto.dart';
import '../mappers/profile_failure_mapper.dart';
import '../mappers/profile_history_snapshot_mapper.dart';
import '../mappers/profile_user_entity_mapper.dart';
import '../remote/profile_api_client.dart';

/// Implementation of [ProfileRepository].
final class ProfileRepositoryImpl implements ProfileRepository {
  final AppLogger _logger;
  final ProfileApiClient _apiClient;
  ProfileStatsHistorySnapshot? _cachedStatsHistorySnapshot;

  /// Creates an instance of [ProfileRepositoryImpl].
  ProfileRepositoryImpl(this._logger, this._apiClient);

  @override
  Future<Result<User, ProfileFailure>> getUser() async {
    try {
      final response = await _apiClient.getProfile();
      _cachedStatsHistorySnapshot = response.data.toStatsHistorySnapshot();
      return Result.success(response.data.user.toEntity());
    } on DioException catch (e) {
      final networkFailure = e.toNetworkFailure();
      return Result.failure(networkFailure.toProfileFailure());
    } catch (e, s) {
      _logger.e('GetUser failed with unexpected error', e, s);
      return Result.failure(
        UnknownProfileFailure(parentException: e, stackTrace: s),
      );
    }
  }

  @override
  Future<Result<ProfileStatsHistorySnapshot, ProfileFailure>> getStatsHistorySnapshot() async {
    final cachedStatsHistorySnapshot = _cachedStatsHistorySnapshot;
    if (cachedStatsHistorySnapshot != null) {
      return Result.success(cachedStatsHistorySnapshot);
    }

    try {
      final response = await _apiClient.getProfile();
      final snapshot = response.data.toStatsHistorySnapshot();
      _cachedStatsHistorySnapshot = snapshot;
      return Result.success(snapshot);
    } on DioException catch (e) {
      final networkFailure = e.toNetworkFailure();
      return Result.failure(networkFailure.toProfileFailure());
    } catch (e, s) {
      _logger.e('GetStatsHistorySnapshot failed with unexpected error', e, s);
      return Result.failure(
        UnknownProfileFailure(parentException: e, stackTrace: s),
      );
    }
  }

  @override
  Future<Result<User, ProfileFailure>> updateUser({
    required User currentUser,
    required String name,
    required String email,
    String? avatarPath,
  }) async {
    final normalizedName = name.trim();
    final normalizedEmail = email.trim();
    final normalizedAvatarPath = avatarPath?.trim();
    final hasProfileChanges =
        normalizedName != currentUser.name || normalizedEmail != currentUser.email;
    final hasAvatarChange = normalizedAvatarPath != null && normalizedAvatarPath.isNotEmpty;

    if (!hasProfileChanges && !hasAvatarChange) {
      return Result.success(currentUser);
    }

    try {
      if (hasAvatarChange) {
        final multipartFile = await MultipartFile.fromFile(
          normalizedAvatarPath,
          filename: normalizedAvatarPath.split(Platform.pathSeparator).last,
        );
        await _apiClient.uploadAvatar(multipartFile);
      }

      if (hasProfileChanges) {
        final request = UpdateProfileRequestDto(
          name: normalizedName,
          email: normalizedEmail,
        );
        await _apiClient.updateProfile(request);
      }

      final refreshedResponse = await _apiClient.getProfile();
      _cachedStatsHistorySnapshot = refreshedResponse.data.toStatsHistorySnapshot();
      return Result.success(refreshedResponse.data.user.toEntity());
    } on DioException catch (e) {
      final networkFailure = e.toNetworkFailure();
      return Result.failure(networkFailure.toProfileFailure());
    } catch (e, s) {
      _logger.e('UpdateUser failed with unexpected error', e, s);
      return Result.failure(
        UnknownProfileFailure(parentException: e, stackTrace: s),
      );
    }
  }

  @override
  Future<Result<void, ProfileFailure>> changePassword({
    required String oldPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    try {
      final request = ChangePasswordRequestDto(
        oldPassword: oldPassword,
        newPassword: newPassword,
        newPasswordConfirmation: newPasswordConfirmation,
      );
      await _apiClient.changePassword(request);
      return const Result.success(null);
    } on DioException catch (e) {
      final networkFailure = e.toNetworkFailure();
      return Result.failure(networkFailure.toProfileFailure());
    } catch (e, s) {
      _logger.e('ChangePassword failed with unexpected error', e, s);
      return Result.failure(
        UnknownProfileFailure(parentException: e, stackTrace: s),
      );
    }
  }
}
