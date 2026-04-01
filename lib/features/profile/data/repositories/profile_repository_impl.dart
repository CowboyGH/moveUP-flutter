import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../core/failures/feature/profile/profile_failure.dart';
import '../../../../core/network/mappers/dio_exception_mapper.dart';
import '../../../../core/result/result.dart';
import '../../../../core/utils/logger/app_logger.dart';
import '../../../auth/domain/entities/user.dart';
import '../../domain/entities/profile_phase_snapshot.dart';
import '../../domain/entities/profile_parameters/profile_parameters_snapshot.dart';
import '../../domain/entities/profile_stats_history_snapshot.dart';
import '../../domain/repositories/profile_repository.dart';
import '../dto/change_password_request_dto.dart';
import '../dto/update_profile_request_dto.dart';
import '../mappers/profile_failure_mapper.dart';
import '../mappers/profile_phase_snapshot_mapper.dart';
import '../mappers/profile_parameters_mapper.dart';
import '../mappers/profile_history_snapshot_mapper.dart';
import '../mappers/profile_user_entity_mapper.dart';
import '../remote/profile_api_client.dart';

/// Implementation of [ProfileRepository].
final class ProfileRepositoryImpl implements ProfileRepository {
  final AppLogger _logger;
  final ProfileApiClient _apiClient;
  ProfileStatsHistorySnapshot? _cachedStatsHistorySnapshot;
  ProfilePhaseSnapshot? _cachedPhaseSnapshot;
  ProfileParametersSnapshot? _cachedParametersSnapshot;
  bool _hasCachedParametersSnapshot = false;

  /// Creates an instance of [ProfileRepositoryImpl].
  ProfileRepositoryImpl(this._logger, this._apiClient);

  @override
  Future<Result<User, ProfileFailure>> getUser() async {
    try {
      final response = await _apiClient.getProfile();
      _cachedStatsHistorySnapshot = response.data.toStatsHistorySnapshot();
      _cachedPhaseSnapshot = response.data.toPhaseSnapshot();
      _cachedParametersSnapshot = response.data.toParametersSnapshot();
      _hasCachedParametersSnapshot = true;
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
      _cachedPhaseSnapshot = response.data.toPhaseSnapshot();
      _cachedParametersSnapshot = response.data.toParametersSnapshot();
      _hasCachedParametersSnapshot = true;
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
  Future<Result<ProfilePhaseSnapshot, ProfileFailure>> getPhaseSnapshot() async {
    final cachedPhaseSnapshot = _cachedPhaseSnapshot;
    if (cachedPhaseSnapshot != null) {
      return Result.success(cachedPhaseSnapshot);
    }

    try {
      final response = await _apiClient.getProfile();
      final snapshot = response.data.toPhaseSnapshot();
      _cachedStatsHistorySnapshot = response.data.toStatsHistorySnapshot();
      _cachedPhaseSnapshot = snapshot;
      _cachedParametersSnapshot = response.data.toParametersSnapshot();
      _hasCachedParametersSnapshot = true;
      return Result.success(snapshot);
    } on DioException catch (e) {
      final networkFailure = e.toNetworkFailure();
      return Result.failure(networkFailure.toProfileFailure());
    } catch (e, s) {
      _logger.e('GetPhaseSnapshot failed with unexpected error', e, s);
      return Result.failure(
        UnknownProfileFailure(parentException: e, stackTrace: s),
      );
    }
  }

  @override
  Future<Result<ProfileParametersSnapshot?, ProfileFailure>> getParametersSnapshot() async {
    if (_hasCachedParametersSnapshot) {
      return Result.success(_cachedParametersSnapshot);
    }

    try {
      final response = await _apiClient.getProfile();
      final snapshot = response.data.toParametersSnapshot();
      _cachedStatsHistorySnapshot = response.data.toStatsHistorySnapshot();
      _cachedPhaseSnapshot = response.data.toPhaseSnapshot();
      _cachedParametersSnapshot = snapshot;
      _hasCachedParametersSnapshot = true;
      return Result.success(snapshot);
    } on DioException catch (e) {
      final networkFailure = e.toNetworkFailure();
      return Result.failure(networkFailure.toProfileFailure());
    } catch (e, s) {
      _logger.e('GetParametersSnapshot failed with unexpected error', e, s);
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
      _cachedPhaseSnapshot = refreshedResponse.data.toPhaseSnapshot();
      _cachedParametersSnapshot = refreshedResponse.data.toParametersSnapshot();
      _hasCachedParametersSnapshot = true;
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

  @override
  Future<Result<void, ProfileFailure>> deleteProfile() async {
    try {
      await _apiClient.deleteProfile();
      return const Result.success(null);
    } on DioException catch (e) {
      final networkFailure = e.toNetworkFailure();
      return Result.failure(networkFailure.toProfileFailure());
    } catch (e, s) {
      _logger.e('DeleteProfile failed with unexpected error', e, s);
      return Result.failure(
        UnknownProfileFailure(parentException: e, stackTrace: s),
      );
    }
  }
}
