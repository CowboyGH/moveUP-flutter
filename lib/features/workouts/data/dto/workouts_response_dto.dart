import 'package:json_annotation/json_annotation.dart';

import 'workouts_list_data_dto.dart';

part 'workouts_response_dto.g.dart';

/// DTO response envelope for workouts overview.
@JsonSerializable(createToJson: false)
class WorkoutsResponseDto {
  /// Workouts overview payload.
  final WorkoutsListDataDto data;

  /// Creates an instance of [WorkoutsResponseDto].
  WorkoutsResponseDto({required this.data});

  /// Creates a [WorkoutsResponseDto] from JSON.
  factory WorkoutsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$WorkoutsResponseDtoFromJson(json);
}
