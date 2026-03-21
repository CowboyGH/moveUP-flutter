import 'package:moveup_flutter/features/tests/attempt/data/dto/complete_guest_test_data_dto.dart';
import 'package:moveup_flutter/features/tests/attempt/data/dto/complete_guest_test_response_dto.dart';
import 'package:moveup_flutter/features/tests/attempt/data/dto/save_guest_test_result_data_dto.dart';
import 'package:moveup_flutter/features/tests/attempt/data/dto/save_guest_test_result_response_dto.dart';
import 'package:moveup_flutter/features/tests/attempt/data/dto/start_guest_test_data_dto.dart';
import 'package:moveup_flutter/features/tests/attempt/data/dto/start_guest_test_response_dto.dart';
import 'package:moveup_flutter/features/tests/attempt/data/dto/test_attempt_testing_dto.dart';
import 'package:moveup_flutter/features/tests/attempt/data/dto/test_exercise_result_dto.dart';
import 'package:moveup_flutter/features/tests/attempt/data/dto/testing_exercise_dto.dart';
import 'package:moveup_flutter/features/tests/attempt/data/mappers/test_attempt_mapper.dart';
import 'package:moveup_flutter/features/tests/attempt/domain/entities/completed_test_attempt.dart';
import 'package:moveup_flutter/features/tests/attempt/domain/entities/test_attempt_result.dart';
import 'package:moveup_flutter/features/tests/attempt/domain/entities/test_attempt_start.dart';

/// Test fixture for exercise DTO.
TestingExerciseDto createTestingExerciseDto({
  int id = 16,
  String description = 'Приседания за 1 минуту',
  String image = 'testing_exercises/squat.jpg',
  int orderNumber = 1,
}) => TestingExerciseDto(
  id: id,
  description: description,
  image: image,
  orderNumber: orderNumber,
);

/// Test fixture for attempt testing DTO.
TestAttemptTestingDto createTestAttemptTestingDto({
  int id = 8,
  String title = 'Расширенная диагностика',
  String description = 'Описание теста',
  String durationMinutes = '31',
  String image = 'tests/balance.jpg',
  int totalExercises = 4,
}) => TestAttemptTestingDto(
  id: id,
  title: title,
  description: description,
  durationMinutes: durationMinutes,
  image: image,
  totalExercises: totalExercises,
);

/// Test fixture for guest start response DTO.
StartGuestTestResponseDto createStartGuestTestResponseDto({
  String attemptId = 'guest_attempt_1',
  TestAttemptTestingDto? testing,
  TestingExerciseDto? currentExercise,
}) => StartGuestTestResponseDto(
  data: StartGuestTestDataDto(
    attemptId: attemptId,
    testing: testing ?? createTestAttemptTestingDto(),
    currentExercise: currentExercise ?? createTestingExerciseDto(),
  ),
);

/// Test fixture for save-result response DTO.
SaveGuestTestResultResponseDto createSaveGuestTestResultResponseDto({
  bool saved = true,
  TestExerciseResultDto? result,
  TestingExerciseDto? nextExercise,
  bool? allExercisesCompleted,
  String? message,
}) => SaveGuestTestResultResponseDto(
  data: SaveGuestTestResultDataDto(
    saved: saved,
    result: result ?? TestExerciseResultDto(testingExerciseId: 16, resultValue: 2),
    nextExercise: nextExercise,
    allExercisesCompleted: allExercisesCompleted,
    message: message,
  ),
);

/// Test fixture for complete response DTO.
CompleteGuestTestResponseDto createCompleteGuestTestResponseDto({
  String attemptId = 'guest_attempt_1',
  String completedAt = '2026-03-13 14:30:11',
  int pulse = 151,
}) => CompleteGuestTestResponseDto(
  data: CompleteGuestTestDataDto(
    attemptId: attemptId,
    completedAt: completedAt,
    pulse: pulse,
  ),
);

/// Test fixture for started attempt entity.
TestAttemptStart createTestAttemptStart() => createStartGuestTestResponseDto().data.toEntity();

/// Test fixture for next-exercise result entity.
TestAttemptResult createTestAttemptNextExerciseResult() =>
    createSaveGuestTestResultResponseDto(
      nextExercise: createTestingExerciseDto(id: 17, orderNumber: 2),
      allExercisesCompleted: false,
    ).data.toEntity();

/// Test fixture for completed-exercises result entity.
TestAttemptResult createTestAttemptAwaitingPulseResult() =>
    createSaveGuestTestResultResponseDto(
      allExercisesCompleted: true,
      message: 'Все упражнения выполнены. Введите пульс для завершения теста.',
    ).data.toEntity();

/// Test fixture for completed attempt entity.
CompletedTestAttempt createCompletedTestAttempt() =>
    createCompleteGuestTestResponseDto().data.toEntity();
