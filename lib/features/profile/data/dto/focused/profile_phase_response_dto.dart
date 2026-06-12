import '../profile_user_data_dto.dart';

/// DTO for the focused `/profile/phase` response.
class ProfilePhaseResponseDto {
  /// Phase payload, or `null` when the user has no active phase.
  final ProfilePhaseDto? phase;

  /// Creates an instance of [ProfilePhaseResponseDto].
  const ProfilePhaseResponseDto({required this.phase});

  /// Creates a [ProfilePhaseResponseDto] from JSON.
  factory ProfilePhaseResponseDto.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is! Map<String, dynamic> || !data.containsKey('has_progress')) {
      return const ProfilePhaseResponseDto(phase: null);
    }
    return ProfilePhaseResponseDto(phase: ProfilePhaseDto.fromJson(data));
  }
}
