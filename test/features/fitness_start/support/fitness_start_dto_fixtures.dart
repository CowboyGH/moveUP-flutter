import 'package:dio/dio.dart';
import 'package:moveup_flutter/features/fitness_start/data/dto/fitness_start_option_dto.dart';
import 'package:moveup_flutter/features/fitness_start/data/dto/fitness_start_references_data_dto.dart';
import 'package:moveup_flutter/features/fitness_start/data/dto/fitness_start_references_response_dto.dart';
import 'package:moveup_flutter/features/fitness_start/data/dto/save_user_parameter_step_response_dto.dart';
import 'package:moveup_flutter/features/fitness_start/data/mappers/fitness_start_references_mapper.dart';
import 'package:moveup_flutter/features/fitness_start/domain/entities/fitness_start_references.dart';

/// Test fixture for a Fitness Start option DTO.
FitnessStartOptionDto createFitnessStartOptionDto({
  int id = 1,
  String name = 'option_name',
}) => FitnessStartOptionDto(
  id: id,
  name: name,
);

/// Test fixture for Fitness Start references data DTO.
FitnessStartReferencesDataDto createFitnessStartReferencesDataDto() =>
    FitnessStartReferencesDataDto(
      goals: [
        createFitnessStartOptionDto(name: 'Рост силовых показателей'),
        createFitnessStartOptionDto(id: 2, name: 'Жиросжигание'),
      ],
      levels: [
        createFitnessStartOptionDto(id: 3, name: 'Новичок'),
        createFitnessStartOptionDto(id: 4, name: 'Опытный'),
      ],
      equipment: [
        createFitnessStartOptionDto(id: 5, name: 'Зал'),
        createFitnessStartOptionDto(id: 6, name: 'Смешанный'),
      ],
    );

/// Test fixture for Fitness Start references response DTO.
FitnessStartReferencesResponseDto createFitnessStartReferencesResponseDto() =>
    FitnessStartReferencesResponseDto(data: createFitnessStartReferencesDataDto());

/// Test fixture for Fitness Start references domain entity.
FitnessStartReferences createFitnessStartReferences() =>
    createFitnessStartReferencesResponseDto().data.toEntity();

/// Test fixture for save-step response DTO.
SaveUserParameterStepResponseDto createSaveUserParameterStepResponseDto() =>
    SaveUserParameterStepResponseDto();

/// Test fixture for Dio bad response exception.
DioException createFitnessStartDioBadResponseException({
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
