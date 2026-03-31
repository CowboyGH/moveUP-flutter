import 'package:dio/dio.dart';
import 'package:moveup_flutter/features/profile/data/dto/active_profile_subscription_dto.dart';
import 'package:moveup_flutter/features/profile/data/dto/profile_test_history_item_dto.dart';
import 'package:moveup_flutter/features/auth/domain/entities/user.dart';
import 'package:moveup_flutter/features/profile/data/dto/profile_user_data_dto.dart';
import 'package:moveup_flutter/features/profile/data/dto/profile_user_dto.dart';
import 'package:moveup_flutter/features/profile/data/dto/profile_user_response_dto.dart';
import 'package:moveup_flutter/features/profile/data/dto/profile_workout_history_item_dto.dart';
import 'package:moveup_flutter/features/profile/domain/entities/profile_phase_snapshot.dart';
import 'package:moveup_flutter/features/profile/domain/entities/profile_stats_history_snapshot.dart';

const testProfileUserId = 1;
const testProfileUserName = 'name';
const testProfileUserEmail = 'tests@mail.com';
const testProfileUserAvatar = 'avatar.jpg';
const testProfileUserCreatedAt = '2026-01-01T10:00:00.000000Z';
const testProfileUserEmailVerified = true;
const testProfileSubscriptionId = 21;
const testProfileSubscriptionName = '3 месяца';
const testProfileSubscriptionPrice = '1400.00';
const testProfileSubscriptionStartDate = '2026-03-15';
const testProfileSubscriptionEndDate = '2026-06-13';
const testProfileWorkoutHistoryId = 101;
const testProfileWorkoutId = 5;
const testProfileWorkoutTitle = 'Утренняя зарядка';
const testProfileWorkoutCompletedAt = '2026-03-15 10:30:00';
const testProfileTestAttemptId = 3;
const testProfileTestId = 2;
const testProfileTestTitle = 'Базовый тест';
const testProfileTestCompletedAt = '2026-03-14 15:20:00';
const testProfilePhaseId = 7;
const testProfilePhaseName = 'A1';
const testProfileHasProgress = true;

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
  ProfileSubscriptionsDto? subscriptions,
  ProfileWorkoutsDto? workouts,
  ProfileTestsDto? tests,
  ProfilePhaseDto? phase,
}) => ProfileUserResponseDto(
  data: ProfileUserDataDto(
    user: user ?? createProfileUserDto(),
    subscriptions: subscriptions,
    workouts: workouts,
    tests: tests,
    phase: phase,
  ),
);

/// Test fixture for [ProfilePhaseDto].
ProfilePhaseDto createProfilePhaseDto({
  bool hasProgress = testProfileHasProgress,
  ProfileCurrentPhaseDto? currentPhase,
}) => ProfilePhaseDto(
  hasProgress: hasProgress,
  currentPhase: currentPhase ?? createProfileCurrentPhaseDto(),
);

/// Test fixture for [ProfileCurrentPhaseDto].
ProfileCurrentPhaseDto createProfileCurrentPhaseDto({
  int id = testProfilePhaseId,
  String name = testProfilePhaseName,
}) => ProfileCurrentPhaseDto(
  id: id,
  name: name,
);

/// Test fixture for [ProfileSubscriptionsDto].
ProfileSubscriptionsDto createProfileSubscriptionsDto({
  ActiveProfileSubscriptionDto? active,
}) => ProfileSubscriptionsDto(
  active: active ?? createActiveProfileSubscriptionDto(),
);

/// Test fixture for [ActiveProfileSubscriptionDto].
ActiveProfileSubscriptionDto createActiveProfileSubscriptionDto({
  int id = testProfileSubscriptionId,
  String name = testProfileSubscriptionName,
  String price = testProfileSubscriptionPrice,
  String startDate = testProfileSubscriptionStartDate,
  String endDate = testProfileSubscriptionEndDate,
  double? daysLeft = 89.38,
}) => ActiveProfileSubscriptionDto(
  id: id,
  name: name,
  price: price,
  startDate: startDate,
  endDate: endDate,
  daysLeft: daysLeft,
);

/// Test fixture for [ProfileWorkoutsDto].
ProfileWorkoutsDto createProfileWorkoutsDto({
  List<ProfileWorkoutHistoryItemDto>? history,
}) => ProfileWorkoutsDto(
  history: history ?? [createProfileWorkoutHistoryItemDto()],
);

/// Test fixture for [ProfileWorkoutHistoryItemDto].
ProfileWorkoutHistoryItemDto createProfileWorkoutHistoryItemDto({
  int id = testProfileWorkoutHistoryId,
  int workoutId = testProfileWorkoutId,
  String title = testProfileWorkoutTitle,
  String completedAt = testProfileWorkoutCompletedAt,
  int? durationMinutes = 45,
}) => ProfileWorkoutHistoryItemDto(
  id: id,
  workout: ProfileWorkoutHistoryWorkoutDto(
    id: workoutId,
    title: title,
  ),
  completedAt: completedAt,
  durationMinutes: durationMinutes,
);

/// Test fixture for [ProfileTestsDto].
ProfileTestsDto createProfileTestsDto({
  List<ProfileTestHistoryItemDto>? history,
}) => ProfileTestsDto(
  history: history ?? [createProfileTestHistoryItemDto()],
);

/// Test fixture for [ProfileTestHistoryItemDto].
ProfileTestHistoryItemDto createProfileTestHistoryItemDto({
  int attemptId = testProfileTestAttemptId,
  int testingId = testProfileTestId,
  String title = testProfileTestTitle,
  String completedAt = testProfileTestCompletedAt,
  int? pulse = 120,
  int? exercisesCount = 5,
}) => ProfileTestHistoryItemDto(
  attemptId: attemptId,
  testing: ProfileTestHistoryTestingDto(
    id: testingId,
    title: title,
  ),
  completedAt: completedAt,
  pulse: pulse,
  exercisesCount: exercisesCount,
);

/// Test fixture for [ProfileStatsHistorySnapshot].
ProfileStatsHistorySnapshot createProfileStatsHistorySnapshot({
  ProfileActiveSubscriptionSnapshot? activeSubscription,
  ProfileLatestWorkoutSnapshot? latestWorkout,
  ProfileLatestTestSnapshot? latestTest,
}) => ProfileStatsHistorySnapshot(
  activeSubscription:
      activeSubscription ??
      const ProfileActiveSubscriptionSnapshot(
        id: testProfileSubscriptionId,
        name: testProfileSubscriptionName,
        price: testProfileSubscriptionPrice,
        startDate: testProfileSubscriptionStartDate,
        endDate: testProfileSubscriptionEndDate,
      ),
  latestWorkout:
      latestWorkout ??
      const ProfileLatestWorkoutSnapshot(
        id: testProfileWorkoutHistoryId,
        title: testProfileWorkoutTitle,
        completedAt: testProfileWorkoutCompletedAt,
      ),
  latestTest:
      latestTest ??
      const ProfileLatestTestSnapshot(
        attemptId: testProfileTestAttemptId,
        title: testProfileTestTitle,
        completedAt: testProfileTestCompletedAt,
      ),
);

/// Test fixture for [ProfilePhaseSnapshot].
ProfilePhaseSnapshot createProfilePhaseSnapshot({
  bool hasProgress = testProfileHasProgress,
  String? currentPhaseName = testProfilePhaseName,
}) => ProfilePhaseSnapshot(
  hasProgress: hasProgress,
  currentPhaseName: currentPhaseName,
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
