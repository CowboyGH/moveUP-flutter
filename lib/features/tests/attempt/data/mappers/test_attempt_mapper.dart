import '../../../data/mappers/testing_image_url_mapper.dart';
import '../../domain/entities/test_attempt_result.dart';
import '../../domain/entities/test_attempt_start.dart';
import '../../domain/entities/test_attempt_testing.dart';
import '../../domain/entities/testing_exercise.dart';
import '../dto/save_test_result_data_dto.dart';
import '../dto/start_guest_test_data_dto.dart';
import '../dto/start_test_data_dto.dart';
import '../dto/test_attempt_testing_dto.dart';
import '../dto/testing_exercise_dto.dart';

/// Extension that maps [TestingExerciseDto] to [TestingExercise].
extension TestingExerciseMapper on TestingExerciseDto {
  /// Converts DTO to a domain entity.
  TestingExercise toEntity() => TestingExercise(
    id: id,
    description: description,
    imageUrl: normalizeTestingImageUrl(image),
    orderNumber: orderNumber,
  );
}

/// Extension that maps [TestAttemptTestingDto] to [TestAttemptTesting].
extension TestAttemptTestingMapper on TestAttemptTestingDto {
  /// Converts DTO to a domain entity.
  TestAttemptTesting toEntity() => TestAttemptTesting(
    title: title,
    totalExercises: totalExercises,
  );
}

/// Extension that maps [StartGuestTestDataDto] to [TestAttemptStart].
extension StartGuestTestMapper on StartGuestTestDataDto {
  /// Converts DTO to a domain entity.
  TestAttemptStart toEntity() => TestAttemptStart(
    attemptId: attemptId,
    testing: testing.toEntity(),
    currentExercise: currentExercise.toEntity(),
  );
}

/// Extension that maps [StartTestDataDto] to [TestAttemptStart].
extension StartTestMapper on StartTestDataDto {
  /// Converts DTO to a domain entity.
  TestAttemptStart toEntity() => TestAttemptStart(
    attemptId: attemptId.toString(),
    testing: testing.toEntity(),
    currentExercise: currentExercise.toEntity(),
  );
}

/// Extension that maps save-result DTOs to [TestAttemptResult].
extension SaveGuestTestResultMapper on SaveTestResultDataDto {
  /// Converts DTO to a domain entity.
  TestAttemptResult toEntity() => TestAttemptResult(
    nextExercise: nextExercise?.toEntity(),
    isAwaitingPulse: allExercisesCompleted == true,
  );
}
