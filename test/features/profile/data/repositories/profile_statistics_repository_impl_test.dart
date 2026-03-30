import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moveup_flutter/core/failures/feature/profile/profile_failure.dart';
import 'package:moveup_flutter/core/utils/logger/app_logger.dart';
import 'package:moveup_flutter/features/profile/data/remote/profile_statistics_api_client.dart';
import 'package:moveup_flutter/features/profile/data/repositories/profile_statistics_repository_impl.dart';
import 'package:moveup_flutter/features/profile/domain/entities/profile_statistics/frequency_period.dart';
import 'package:moveup_flutter/features/profile/domain/repositories/profile_statistics_repository.dart';

import '../../support/profile_statistics_dto_fixtures.dart';
import 'profile_statistics_repository_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AppLogger>(),
  MockSpec<ProfileStatisticsApiClient>(),
])
void main() {
  late MockAppLogger logger;
  late MockProfileStatisticsApiClient apiClient;
  late ProfileStatisticsRepository repository;

  setUp(() {
    logger = MockAppLogger();
    apiClient = MockProfileStatisticsApiClient();
    repository = ProfileStatisticsRepositoryImpl(logger, apiClient);
  });

  group('ProfileStatisticsRepositoryImpl', () {
    test('getVolume returns success(data) when api succeeds', () async {
      // Arrange
      when(apiClient.getVolume()).thenAnswer((_) async => createVolumeResponseDto());

      // Act
      final result = await repository.getVolume();

      // Assert
      expect(result.isSuccess, isTrue);
      expect(result.success!.exerciseId, testVolumeExerciseId);
      expect(result.success!.title, testVolumeExerciseTitle);
      expect(result.success!.averageScorePercent, testVolumeAverageScorePercent);
      verify(apiClient.getVolume()).called(1);
      verifyNoMoreInteractions(apiClient);
    });

    test('getVolume returns ProfileRequestFailure when api fails', () async {
      // Arrange
      final exception = createProfileStatisticsDioBadResponseException(
        path: '/api/profile/statistics/volume',
        statusCode: 500,
        code: 'server_error',
      );
      when(apiClient.getVolume()).thenThrow(exception);

      // Act
      final result = await repository.getVolume();

      // Assert
      expect(result.isFailure, isTrue);
      expect(result.failure, isA<ProfileRequestFailure>());
      verify(apiClient.getVolume()).called(1);
      verifyNoMoreInteractions(apiClient);
    });

    test('getTrend returns success(data) when api succeeds', () async {
      // Arrange
      when(apiClient.getTrend()).thenAnswer((_) async => createTrendResponseDto());

      // Act
      final result = await repository.getTrend();

      // Assert
      expect(result.isSuccess, isTrue);
      expect(result.success!.workoutId, testTrendWorkoutId);
      expect(result.success!.title, testTrendWorkoutTitle);
      expect(result.success!.averageScorePercent, 100);
      verify(apiClient.getTrend()).called(1);
      verifyNoMoreInteractions(apiClient);
    });

    test('getTrend returns ProfileRequestFailure when api fails', () async {
      // Arrange
      final exception = createProfileStatisticsDioBadResponseException(
        path: '/api/profile/statistics/trend',
        statusCode: 500,
        code: 'server_error',
      );
      when(apiClient.getTrend()).thenThrow(exception);

      // Act
      final result = await repository.getTrend();

      // Assert
      expect(result.isFailure, isTrue);
      expect(result.failure, isA<ProfileRequestFailure>());
      verify(apiClient.getTrend()).called(1);
      verifyNoMoreInteractions(apiClient);
    });

    test('getFrequency returns success(data) when api succeeds', () async {
      // Arrange
      when(
        apiClient.getFrequency(period: 'month', offset: 0),
      ).thenAnswer((_) async => createFrequencyResponseDto());

      // Act
      final result = await repository.getFrequency(
        period: FrequencyPeriod.month,
        offset: 0,
      );

      // Assert
      expect(result.isSuccess, isTrue);
      expect(result.success!.period, FrequencyPeriod.month);
      expect(result.success!.label, testFrequencyLabel);
      expect(result.success!.averagePerWeek, 2.3);
      verify(apiClient.getFrequency(period: 'month', offset: 0)).called(1);
      verifyNoMoreInteractions(apiClient);
    });

    test('getFrequency returns ProfileRequestFailure when api fails', () async {
      // Arrange
      final exception = createProfileStatisticsDioBadResponseException(
        path: '/api/profile/statistics/frequency',
        statusCode: 500,
        code: 'server_error',
      );
      when(apiClient.getFrequency(period: 'month', offset: 0)).thenThrow(exception);

      // Act
      final result = await repository.getFrequency(
        period: FrequencyPeriod.month,
        offset: 0,
      );

      // Assert
      expect(result.isFailure, isTrue);
      expect(result.failure, isA<ProfileRequestFailure>());
      verify(apiClient.getFrequency(period: 'month', offset: 0)).called(1);
      verifyNoMoreInteractions(apiClient);
    });

    test('getExercises returns success(items) when api succeeds', () async {
      // Arrange
      when(apiClient.getExercises()).thenAnswer((_) async => createProfileExercisesResponseDto());

      // Act
      final result = await repository.getExercises();

      // Assert
      expect(result.isSuccess, isTrue);
      expect(result.success, hasLength(1));
      expect(result.success!.first.id, testVolumeExerciseId);
      expect(result.success!.first.name, testVolumeExerciseTitle);
      verify(apiClient.getExercises()).called(1);
      verifyNoMoreInteractions(apiClient);
    });

    test('getExercises returns ProfileRequestFailure when api fails', () async {
      // Arrange
      final exception = createProfileStatisticsDioBadResponseException(
        path: '/api/profile/statistics/exercises',
        statusCode: 500,
        code: 'server_error',
      );
      when(apiClient.getExercises()).thenThrow(exception);

      // Act
      final result = await repository.getExercises();

      // Assert
      expect(result.isFailure, isTrue);
      expect(result.failure, isA<ProfileRequestFailure>());
      verify(apiClient.getExercises()).called(1);
      verifyNoMoreInteractions(apiClient);
    });

    test('getWorkouts returns success(items) when api succeeds', () async {
      // Arrange
      when(apiClient.getWorkouts()).thenAnswer((_) async => createProfileWorkoutsResponseDto());

      // Act
      final result = await repository.getWorkouts();

      // Assert
      expect(result.isSuccess, isTrue);
      expect(result.success, hasLength(1));
      expect(result.success!.first.id, testTrendWorkoutId);
      expect(result.success!.first.title, testTrendWorkoutTitle);
      verify(apiClient.getWorkouts()).called(1);
      verifyNoMoreInteractions(apiClient);
    });

    test('getWorkouts returns ProfileRequestFailure when api fails', () async {
      // Arrange
      final exception = createProfileStatisticsDioBadResponseException(
        path: '/api/profile/statistics/workouts',
        statusCode: 500,
        code: 'server_error',
      );
      when(apiClient.getWorkouts()).thenThrow(exception);

      // Act
      final result = await repository.getWorkouts();

      // Assert
      expect(result.isFailure, isTrue);
      expect(result.failure, isA<ProfileRequestFailure>());
      verify(apiClient.getWorkouts()).called(1);
      verifyNoMoreInteractions(apiClient);
    });
  });
}
