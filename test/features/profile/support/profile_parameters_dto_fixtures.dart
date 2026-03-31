import 'package:moveup_flutter/features/profile/data/dto/params/profile_current_parameters_response_dto.dart';
import 'package:moveup_flutter/features/profile/data/dto/params/profile_parameters_references_response_dto.dart';
import 'package:moveup_flutter/features/profile/domain/entities/profile_parameters/profile_parameters_data.dart';
import 'package:moveup_flutter/features/profile/domain/entities/profile_parameters/profile_parameters_gender.dart';
import 'package:moveup_flutter/features/profile/domain/entities/profile_parameters/profile_parameters_option.dart';
import 'package:moveup_flutter/features/profile/domain/entities/profile_parameters/profile_parameters_references.dart';
import 'package:moveup_flutter/features/profile/domain/entities/profile_parameters/profile_parameters_submit_payload.dart';

const testProfileParametersGoalId = 1;
const testProfileParametersGoalName = 'Рост силовых показателей';
const testProfileParametersUpdatedGoalId = 2;
const testProfileParametersUpdatedGoalName = 'Снижение веса';
const testProfileParametersEquipmentId = 2;
const testProfileParametersEquipmentName = 'Смешанное';
const testProfileParametersUpdatedEquipmentId = 1;
const testProfileParametersUpdatedEquipmentName = 'Зал';
const testProfileParametersLevelId = 3;
const testProfileParametersLevelName = 'Профессионал';
const testProfileParametersUpdatedLevelId = 1;
const testProfileParametersUpdatedLevelName = 'Начинающий';
const testProfileParametersAgeValue = 18;
const testProfileParametersWeightValue = 80.0;
const testProfileParametersHeightValue = 150;
const testProfileParametersWeeklyGoal = 3;
const testProfileParametersUpdatedWeeklyGoal = 5;

const testProfileParametersReferences = ProfileParametersReferences(
  goals: [
    ProfileParametersOption(id: 1, name: 'Рост силовых показателей'),
    ProfileParametersOption(id: 2, name: 'Снижение веса'),
  ],
  levels: [
    ProfileParametersOption(id: 1, name: 'Начинающий'),
    ProfileParametersOption(id: 3, name: 'Профессионал'),
  ],
  equipment: [
    ProfileParametersOption(id: 1, name: 'Зал'),
    ProfileParametersOption(id: 2, name: 'Смешанное'),
  ],
);

const testProfileParametersData = ProfileParametersData(
  goalId: testProfileParametersGoalId,
  equipmentId: testProfileParametersEquipmentId,
  levelId: testProfileParametersLevelId,
  gender: ProfileParametersGender.female,
  age: testProfileParametersAgeValue,
  weight: testProfileParametersWeightValue,
  height: testProfileParametersHeightValue,
  goalName: testProfileParametersGoalName,
  equipmentName: testProfileParametersEquipmentName,
  levelName: testProfileParametersLevelName,
);

const testProfileParametersSubmitPayload = ProfileParametersSubmitPayload(
  goalId: testProfileParametersGoalId,
  gender: ProfileParametersGender.female,
  age: testProfileParametersAgeValue,
  weight: testProfileParametersWeightValue,
  height: testProfileParametersHeightValue,
  equipmentId: testProfileParametersEquipmentId,
  levelId: testProfileParametersLevelId,
  weeklyGoal: testProfileParametersWeeklyGoal,
);

/// Test fixture for profile parameters references response DTO.
ProfileParametersReferencesResponseDto createProfileParametersReferencesResponseDto({
  ProfileParametersReferencesDto? data,
}) => ProfileParametersReferencesResponseDto(
  data: data ?? createProfileParametersReferencesDto(),
);

/// Test fixture for references DTO payload.
ProfileParametersReferencesDto createProfileParametersReferencesDto({
  List<ProfileParametersReferenceOptionDto>? goals,
  List<ProfileParametersReferenceOptionDto>? levels,
  List<ProfileParametersReferenceOptionDto>? equipment,
}) => ProfileParametersReferencesDto(
  goals: goals ?? createProfileParametersGoalOptionsDto(),
  levels: levels ?? createProfileParametersLevelOptionsDto(),
  equipment: equipment ?? createProfileParametersEquipmentOptionsDto(),
);

/// Test fixture for current parameters response DTO.
ProfileCurrentParametersResponseDto createProfileCurrentParametersResponseDto({
  ProfileCurrentParametersDto? data,
}) => ProfileCurrentParametersResponseDto(
  data: data ?? createProfileCurrentParametersDto(),
);

/// Test fixture for current parameters DTO.
ProfileCurrentParametersDto createProfileCurrentParametersDto({
  int id = 54,
  int userId = 336,
  int equipmentId = testProfileParametersEquipmentId,
  int levelId = testProfileParametersLevelId,
  int goalId = testProfileParametersGoalId,
  int height = testProfileParametersHeightValue,
  double weight = testProfileParametersWeightValue,
  int age = testProfileParametersAgeValue,
  String gender = 'female',
  ProfileCurrentParameterNamedItemDto? goal,
  ProfileCurrentParameterNamedItemDto? level,
  ProfileCurrentParameterNamedItemDto? equipment,
}) => ProfileCurrentParametersDto(
  id: id,
  userId: userId,
  equipmentId: equipmentId,
  levelId: levelId,
  goalId: goalId,
  height: height,
  weight: weight,
  age: age,
  gender: gender,
  goal:
      goal ??
      createProfileCurrentParameterNamedItemDto(
        id: goalId,
        name: goalId == testProfileParametersGoalId
            ? testProfileParametersGoalName
            : testProfileParametersUpdatedGoalName,
      ),
  level:
      level ??
      createProfileCurrentParameterNamedItemDto(
        id: levelId,
        name: levelId == testProfileParametersLevelId
            ? testProfileParametersLevelName
            : testProfileParametersUpdatedLevelName,
      ),
  equipment:
      equipment ??
      createProfileCurrentParameterNamedItemDto(
        id: equipmentId,
        name: equipmentId == testProfileParametersEquipmentId
            ? testProfileParametersEquipmentName
            : testProfileParametersUpdatedEquipmentName,
      ),
);

/// Test fixture for nested current parameters named item DTO.
ProfileCurrentParameterNamedItemDto createProfileCurrentParameterNamedItemDto({
  required int id,
  required String name,
}) => ProfileCurrentParameterNamedItemDto(
  id: id,
  name: name,
);

/// Helper to create changed submit payloads.
ProfileParametersSubmitPayload createProfileParametersSubmitPayload({
  int goalId = testProfileParametersGoalId,
  ProfileParametersGender gender = ProfileParametersGender.female,
  int age = testProfileParametersAgeValue,
  double weight = testProfileParametersWeightValue,
  int height = testProfileParametersHeightValue,
  int equipmentId = testProfileParametersEquipmentId,
  int levelId = testProfileParametersLevelId,
  int weeklyGoal = testProfileParametersWeeklyGoal,
}) => ProfileParametersSubmitPayload(
  goalId: goalId,
  gender: gender,
  age: age,
  weight: weight,
  height: height,
  equipmentId: equipmentId,
  levelId: levelId,
  weeklyGoal: weeklyGoal,
);

List<ProfileParametersReferenceOptionDto> createProfileParametersGoalOptionsDto() => [
  ProfileParametersReferenceOptionDto(
    id: testProfileParametersGoalId,
    name: testProfileParametersGoalName,
  ),
  ProfileParametersReferenceOptionDto(
    id: testProfileParametersUpdatedGoalId,
    name: testProfileParametersUpdatedGoalName,
  ),
];

List<ProfileParametersReferenceOptionDto> createProfileParametersLevelOptionsDto() => [
  ProfileParametersReferenceOptionDto(
    id: testProfileParametersUpdatedLevelId,
    name: testProfileParametersUpdatedLevelName,
  ),
  ProfileParametersReferenceOptionDto(
    id: testProfileParametersLevelId,
    name: testProfileParametersLevelName,
  ),
];

List<ProfileParametersReferenceOptionDto> createProfileParametersEquipmentOptionsDto() => [
  ProfileParametersReferenceOptionDto(
    id: testProfileParametersUpdatedEquipmentId,
    name: testProfileParametersUpdatedEquipmentName,
  ),
  ProfileParametersReferenceOptionDto(
    id: testProfileParametersEquipmentId,
    name: testProfileParametersEquipmentName,
  ),
];
