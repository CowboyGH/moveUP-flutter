import 'package:moveup_flutter/features/tests/attempt/data/dto/save_guest_test_result_data_dto.dart';
import 'package:moveup_flutter/features/tests/attempt/data/dto/save_guest_test_result_response_dto.dart';
import 'package:moveup_flutter/features/tests/attempt/data/dto/start_guest_test_data_dto.dart';
import 'package:moveup_flutter/features/tests/attempt/data/dto/start_guest_test_response_dto.dart';
import 'package:moveup_flutter/features/tests/attempt/data/dto/test_attempt_testing_dto.dart';
import 'package:moveup_flutter/features/tests/attempt/data/dto/testing_exercise_dto.dart';
import 'package:moveup_flutter/features/tests/attempt/data/mappers/test_attempt_mapper.dart';
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
  String title = 'Расширенная диагностика',
  int totalExercises = 4,
}) => TestAttemptTestingDto(
  title: title,
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
  TestingExerciseDto? nextExercise,
  bool? allExercisesCompleted,
}) => SaveGuestTestResultResponseDto(
  data: SaveGuestTestResultDataDto(
    saved: saved,
    nextExercise: nextExercise,
    allExercisesCompleted: allExercisesCompleted,
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
    ).data.toEntity();
