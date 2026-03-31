import '../../domain/entities/profile_phase_snapshot.dart';
import '../dto/profile_user_data_dto.dart';

/// Maps aggregate `/profile` DTO subset to phase snapshot entities.
extension ProfilePhaseSnapshotMapper on ProfileUserDataDto {
  /// Returns a focused phase snapshot for the profile current phase UI.
  ProfilePhaseSnapshot toPhaseSnapshot() => ProfilePhaseSnapshot(
    hasProgress: phase?.hasProgress ?? false,
    currentPhaseName: phase?.currentPhase?.name,
  );
}
