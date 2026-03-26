import 'package:json_annotation/json_annotation.dart';

import 'workout_details_data_dto.dart';

part 'workout_details_response_dto.g.dart';

/// DTO response envelope for workout details.
@JsonSerializable(createToJson: false)
class WorkoutDetailsResponseDto {
  /// Workout details payload.
  final WorkoutDetailsDataDto data;

  /// Creates an instance of [WorkoutDetailsResponseDto].
  WorkoutDetailsResponseDto({required this.data});

  /// Creates a [WorkoutDetailsResponseDto] from JSON.
  factory WorkoutDetailsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$WorkoutDetailsResponseDtoFromJson(json);
}
