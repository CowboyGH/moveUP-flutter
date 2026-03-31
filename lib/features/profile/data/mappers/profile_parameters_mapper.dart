import '../../domain/entities/profile_parameters/profile_parameters_data.dart';
import '../../domain/entities/profile_parameters/profile_parameters_gender.dart';
import '../../domain/entities/profile_parameters/profile_parameters_option.dart';
import '../../domain/entities/profile_parameters/profile_parameters_references.dart';
import '../../domain/entities/profile_parameters/profile_parameters_snapshot.dart';
import '../dto/params/profile_current_parameters_response_dto.dart';
import '../dto/params/profile_parameters_references_response_dto.dart';
import '../dto/profile_user_data_dto.dart';

/// Maps aggregate `/profile` DTO subset to parameters bootstrap snapshot.
extension ProfileParametersSnapshotMapper on ProfileUserDataDto {
  /// Returns a focused parameters snapshot for the profile parameters form.
  ProfileParametersSnapshot? toParametersSnapshot() {
    final parameters = this.parameters;
    if (parameters == null) return null;

    return ProfileParametersSnapshot(
      goal: parameters.goal,
      gender: ProfileParametersGender.fromRawValue(parameters.gender),
      age: parameters.age,
      weight: parameters.weight.toDouble(),
      height: parameters.height,
      equipment: parameters.equipment,
      level: parameters.level,
    );
  }
}

/// Maps canonical `/user-parameters/me` DTOs to profile parameters entities.
extension ProfileCurrentParametersMapper on ProfileCurrentParametersDto {
  /// Returns the canonical profile parameters entity.
  ProfileParametersData toEntity() => ProfileParametersData(
    goalId: goalId,
    equipmentId: equipmentId,
    levelId: levelId,
    gender: ProfileParametersGender.fromRawValue(gender),
    age: age,
    weight: weight,
    height: height,
    goalName: goal.name,
    equipmentName: equipment.name,
    levelName: level.name,
  );
}

/// Maps references DTO to the profile parameters references entity.
extension ProfileParametersReferencesMapper on ProfileParametersReferencesDto {
  /// Returns the references entity required by the form.
  ProfileParametersReferences toEntity() => ProfileParametersReferences(
    goals: goals.map((item) => item.toEntity()).toList(growable: false),
    levels: levels.map((item) => item.toEntity()).toList(growable: false),
    equipment: equipment.map((item) => item.toEntity()).toList(growable: false),
  );
}

extension on ProfileParametersReferenceOptionDto {
  ProfileParametersOption toEntity() => ProfileParametersOption(
    id: id,
    name: name,
  );
}
