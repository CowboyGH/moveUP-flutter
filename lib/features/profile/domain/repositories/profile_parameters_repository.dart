import '../../../../core/failures/feature/profile/profile_failure.dart';
import '../../../../core/result/result.dart';
import '../entities/profile_parameters/profile_parameters_data.dart';
import '../entities/profile_parameters/profile_parameters_references.dart';
import '../entities/profile_parameters/profile_parameters_submit_payload.dart';

/// Repository interface for the profile parameters section.
abstract interface class ProfileParametersRepository {
  /// Returns references required by the profile parameters form.
  Future<Result<ProfileParametersReferences, ProfileFailure>> getReferences();

  /// Returns canonical authenticated parameters for the current user.
  Future<Result<ProfileParametersData, ProfileFailure>> getCurrentParameters();

  /// Saves all changed profile parameters and returns the refreshed payload.
  Future<Result<ProfileParametersData, ProfileFailure>> saveParameters({
    required ProfileParametersData currentParameters,
    required int currentWeeklyGoal,
    required ProfileParametersSubmitPayload payload,
  });
}
