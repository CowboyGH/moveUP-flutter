import 'package:dio/dio.dart';
import 'package:moveup_flutter/features/workouts/data/dto/user_workout_overview_item_dto.dart';
import 'package:moveup_flutter/features/workouts/data/dto/warmup_item_dto.dart';
import 'package:moveup_flutter/features/workouts/data/dto/workout_details_data_dto.dart';
import 'package:moveup_flutter/features/workouts/data/dto/workout_details_response_dto.dart';
import 'package:moveup_flutter/features/workouts/data/dto/workout_summary_dto.dart';
import 'package:moveup_flutter/features/workouts/data/dto/workouts_list_data_dto.dart';
import 'package:moveup_flutter/features/workouts/data/dto/workouts_response_dto.dart';
import 'package:moveup_flutter/features/workouts/data/mappers/workout_details_mapper.dart';
import 'package:moveup_flutter/features/workouts/data/mappers/workout_overview_mapper.dart';
import 'package:moveup_flutter/features/workouts/details/domain/entities/workout_details_item.dart';
import 'package:moveup_flutter/features/workouts/overview/domain/entities/workout_overview_item.dart';

/// Test fixture for workouts response DTO.
WorkoutsResponseDto createWorkoutsResponseDto() => WorkoutsResponseDto(
  data: WorkoutsListDataDto(
    started: [
      UserWorkoutOverviewItemDto(
        userWorkoutId: 1,
        workout: WorkoutSummaryDto(
          id: 1,
          title: 'title',
          description: 'description',
          durationMinutes: '1',
          image: 'image.png',
        ),
        status: 'started',
      ),
    ],
    assigned: [
      UserWorkoutOverviewItemDto(
        userWorkoutId: 202,
        workout: WorkoutSummaryDto(
          id: 2,
          title: 'title',
          description: 'description',
          durationMinutes: '2',
          image: 'image_2.png',
        ),
        status: 'assigned',
      ),
    ],
    hasActive: true,
  ),
);

/// Test fixture for workouts overview domain entities.
List<WorkoutOverviewItem> createWorkoutOverviewItems() => [
  ...createWorkoutsResponseDto().data.started,
  ...createWorkoutsResponseDto().data.assigned,
].map((item) => item.toEntity(hasActive: true)).toList(growable: false);

/// Test fixture for workout details response DTO.
WorkoutDetailsResponseDto createWorkoutDetailsResponseDto({
  String status = 'started',
}) => WorkoutDetailsResponseDto(
  data: WorkoutDetailsDataDto(
    status: status,
    warmups: [
      WarmupItemDto(
        id: 1,
        name: 'name',
        description: 'description',
        image: 'test.png',
        durationSeconds: 270,
        isLast: true,
      ),
    ],
    workout: WorkoutSummaryDto(
      id: 1,
      title: 'title',
      description: 'description',
      durationMinutes: '1',
      image: 'test.png',
    ),
  ),
);

/// Test fixture for workout details domain entities.
List<WorkoutDetailsItem> createWorkoutDetailsItems() =>
    createWorkoutDetailsResponseDto().data.toEntities();

/// Test fixture for Dio bad response exception.
DioException createWorkoutsDioBadResponseException({
  required String path,
  required int statusCode,
  required String code,
  String message = 'error_message',
}) {
  final requestOptions = RequestOptions(path: path);
  return DioException(
    requestOptions: requestOptions,
    type: DioExceptionType.badResponse,
    response: Response<Map<String, dynamic>>(
      requestOptions: requestOptions,
      statusCode: statusCode,
      data: {
        'code': code,
        'message': message,
      },
    ),
  );
}
