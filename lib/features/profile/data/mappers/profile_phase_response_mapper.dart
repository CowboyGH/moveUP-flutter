import '../../domain/entities/profile_phase_snapshot.dart';
import '../dto/focused/profile_phase_response_dto.dart';

/// Maps `/profile/phase` DTO to phase snapshot entity.
extension ProfilePhaseResponseMapper on ProfilePhaseResponseDto {
  /// Returns a focused phase snapshot for the profile current phase UI.
  ProfilePhaseSnapshot toPhaseSnapshot() => ProfilePhaseSnapshot(
    hasProgress: phase?.hasProgress ?? false,
    currentPhaseName: phase?.currentPhase?.name,
  );
}
