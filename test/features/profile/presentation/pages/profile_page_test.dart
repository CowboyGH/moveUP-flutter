import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moveup_flutter/core/failures/feature/profile/profile_failure.dart';
import 'package:moveup_flutter/core/result/result.dart';
import 'package:moveup_flutter/features/auth/domain/entities/user.dart';
import 'package:moveup_flutter/features/profile/domain/entities/profile_statistics/frequency_period.dart';
import 'package:moveup_flutter/features/profile/domain/entities/profile_statistics/frequency_statistics_data.dart';
import 'package:moveup_flutter/features/profile/domain/entities/profile_statistics/profile_exercise_option.dart';
import 'package:moveup_flutter/features/profile/domain/entities/profile_statistics/profile_workout_option.dart';
import 'package:moveup_flutter/features/profile/domain/entities/profile_statistics/trend_statistics_data.dart';
import 'package:moveup_flutter/features/profile/domain/entities/profile_statistics/volume_statistics_data.dart';
import 'package:moveup_flutter/features/profile/domain/entities/profile_stats_history_snapshot.dart';
import 'package:moveup_flutter/features/profile/domain/repositories/profile_repository.dart';
import 'package:moveup_flutter/features/profile/domain/repositories/profile_statistics_repository.dart';
import 'package:moveup_flutter/features/profile/presentation/cubits/profile_statistics_cubit.dart';
import 'package:moveup_flutter/features/profile/presentation/cubits/profile_user_cubit.dart';
import 'package:moveup_flutter/features/profile/presentation/pages/profile_page.dart';
import 'package:moveup_flutter/features/profile/presentation/widgets/stats_section_widget.dart';
import 'package:moveup_flutter/features/profile/presentation/widgets/user_section_widget.dart';
import 'package:moveup_flutter/uikit/themes/app_theme_data.dart';

void main() {
  group('ProfilePage', () {
    testWidgets('renders stats section below user section', (tester) async {
      await tester.pumpWidget(_buildTestApp());
      await tester.pumpAndSettle();

      expect(find.byType(UserSectionWidget), findsOneWidget);
      expect(find.byType(StatsSectionWidget), findsOneWidget);
      expect(find.text('Статистика тренировок пользователя'), findsOneWidget);

      final userSectionBottom = tester.getBottomLeft(find.byType(UserSectionWidget)).dy;
      final statsSectionTop = tester.getTopLeft(find.byType(StatsSectionWidget)).dy;
      expect(statsSectionTop, greaterThan(userSectionBottom));
    });

    testWidgets('switches statistics modes and updates category selector', (tester) async {
      await tester.pumpWidget(_buildTestApp());
      await tester.pumpAndSettle();

      expect(find.text('Объём (кг)'), findsOneWidget);

      await tester.ensureVisible(find.text('Частота'));
      await tester.tap(find.text('Частота'));
      await tester.pumpAndSettle();
      expect(find.text('Частота тренировок'), findsOneWidget);

      await tester.ensureVisible(find.text('Объём'));
      await tester.tap(find.text('Объём'));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.widgetWithText(OutlinedButton, 'Скручивания на пресс'));
      await tester.tap(find.widgetWithText(OutlinedButton, 'Скручивания на пресс'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Приседания со штангой').last);
      await tester.pumpAndSettle();

      expect(find.text('Приседания со штангой'), findsWidgets);

      await tester.ensureVisible(find.text('Тренд'));
      await tester.tap(find.text('Тренд'));
      await tester.pumpAndSettle();
      expect(find.text('Тренд по упражнениям'), findsOneWidget);
    });

    testWidgets('opens history dialog and switches local tabs', (tester) async {
      await tester.pumpWidget(_buildTestApp());
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('История'));
      await tester.tap(find.text('История'));
      await tester.pumpAndSettle();

      expect(find.text('История'), findsNWidgets(2));
      expect(find.text('Премиум 3 месяца'), findsOneWidget);

      await tester.tap(find.text('Тренировки'));
      await tester.pumpAndSettle();
      expect(find.text('Утренняя зарядка'), findsOneWidget);

      await tester.tap(find.text('Тесты'));
      await tester.pumpAndSettle();
      expect(find.text('Базовый тест'), findsOneWidget);

      await tester.tap(find.text('Закрыть'));
      await tester.pumpAndSettle();
      expect(find.text('Премиум 3 месяца'), findsNothing);
    });
  });
}

Widget _buildTestApp() {
  final profileRepository = _FakeProfileRepository();
  final statisticsRepository = _FakeProfileStatisticsRepository();

  return MaterialApp(
    theme: AppThemeData.lightTheme,
    home: MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ProfileUserCubit(
            profileRepository,
            seedUser: _testUser,
          )..refresh(),
        ),
        BlocProvider(
          create: (_) => ProfileStatisticsCubit(statisticsRepository)..loadInitial(),
        ),
      ],
      child: const ProfilePage(),
    ),
  );
}

const _testUser = User(
  id: 1,
  name: 'Никита',
  email: 'nikita@mail.com',
);

const _testHistorySnapshot = ProfileStatsHistorySnapshot(
  activeSubscription: ProfileActiveSubscriptionSnapshot(
    id: 41,
    name: 'Премиум 3 месяца',
    price: '1400.00',
    startDate: '2026-03-01',
    endDate: '2026-06-01',
  ),
  latestWorkout: ProfileLatestWorkoutSnapshot(
    id: 88,
    title: 'Утренняя зарядка',
    completedAt: '2026-03-28 10:30:00',
  ),
  latestTest: ProfileLatestTestSnapshot(
    attemptId: 9,
    title: 'Базовый тест',
    completedAt: '2026-03-27 11:00:00',
  ),
);

const _volumeCrunches = VolumeStatisticsData(
  hasData: true,
  exerciseId: 17,
  title: 'Скручивания на пресс',
  averageScorePercent: 79,
  averageScoreLabel: 'Нормально',
  period: VolumePeriodData(
    start: '2026-03-24',
    end: '2026-03-30',
    label: 'Неделя 24.03 - 30.03',
    weekOffset: 0,
    canGoPrevious: true,
    canGoNext: false,
  ),
  chart: [
    VolumeChartBarData(label: 'Пн', value: 3400, date: '2026-03-24'),
    VolumeChartBarData(label: 'Вт', value: 1600, date: '2026-03-25'),
  ],
);

const _volumeSquats = VolumeStatisticsData(
  hasData: true,
  exerciseId: 31,
  title: 'Приседания со штангой',
  averageScorePercent: 84,
  averageScoreLabel: 'Хорошо',
  period: VolumePeriodData(
    start: '2026-03-24',
    end: '2026-03-30',
    label: 'Неделя 24.03 - 30.03',
    weekOffset: 0,
    canGoPrevious: true,
    canGoNext: false,
  ),
  chart: [
    VolumeChartBarData(label: 'Пн', value: 2200, date: '2026-03-24'),
    VolumeChartBarData(label: 'Вт', value: 2800, date: '2026-03-25'),
  ],
);

const _frequencyData = FrequencyStatisticsData(
  hasData: true,
  period: FrequencyPeriod.month,
  offset: 0,
  label: 'Текущий месяц',
  averagePerWeek: 2.5,
  chart: [
    FrequencyChartBarData(
      label: 'Неделя 1',
      shortLabel: '1',
      count: 2,
      goal: 4,
    ),
    FrequencyChartBarData(
      label: 'Неделя 2',
      shortLabel: '2',
      count: 3,
      goal: 4,
    ),
  ],
);

const _trendData = TrendStatisticsData(
  hasData: true,
  workoutId: 231,
  title: 'Силовая тренировка',
  completedAtFormatted: '28.03.2026',
  averageScorePercent: 88,
  averageScoreLabel: 'Хорошо',
  exercises: [
    TrendExerciseData(
      exerciseName: 'Жим лёжа',
      scorePercent: 88,
      scoreLabel: 'Хорошо',
      reaction: 'good',
      weightUsed: '60',
    ),
  ],
);

final class _FakeProfileRepository implements ProfileRepository {
  @override
  Future<Result<void, ProfileFailure>> changePassword({
    required String oldPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async => const Success(null);

  @override
  Future<Result<ProfileStatsHistorySnapshot, ProfileFailure>> getStatsHistorySnapshot() async =>
      const Success(_testHistorySnapshot);

  @override
  Future<Result<User, ProfileFailure>> getUser() async => const Success(_testUser);

  @override
  Future<Result<User, ProfileFailure>> updateUser({
    required User currentUser,
    required String name,
    required String email,
    String? avatarPath,
  }) async => Result.success(
    User(
      id: currentUser.id,
      name: name,
      email: email,
      avatar: currentUser.avatar,
    ),
  );
}

final class _FakeProfileStatisticsRepository implements ProfileStatisticsRepository {
  @override
  Future<Result<List<ProfileExerciseOption>, ProfileFailure>> getExercises() async {
    return const Success([
      ProfileExerciseOption(
        id: 17,
        name: 'Скручивания на пресс',
        lastUsedFormatted: '30.03.2026',
      ),
      ProfileExerciseOption(
        id: 31,
        name: 'Приседания со штангой',
        lastUsedFormatted: '29.03.2026',
      ),
    ]);
  }

  @override
  Future<Result<FrequencyStatisticsData, ProfileFailure>> getFrequency({
    required FrequencyPeriod period,
    required int offset,
  }) async => const Success(_frequencyData);

  @override
  Future<Result<TrendStatisticsData, ProfileFailure>> getTrend({
    int? workoutId,
  }) async => const Success(_trendData);

  @override
  Future<Result<VolumeStatisticsData, ProfileFailure>> getVolume({
    int? exerciseId,
    int? weekOffset,
  }) async => Success(exerciseId == 31 ? _volumeSquats : _volumeCrunches);

  @override
  Future<Result<List<ProfileWorkoutOption>, ProfileFailure>> getWorkouts() async {
    return const Success([
      ProfileWorkoutOption(
        id: 231,
        title: 'Силовая тренировка',
        completedAtFormatted: '28.03.2026',
      ),
    ]);
  }
}
