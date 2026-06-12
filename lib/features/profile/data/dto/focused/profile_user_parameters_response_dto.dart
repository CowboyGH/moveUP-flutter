import '../profile_user_data_dto.dart';

/// DTO for the focused `/profile/user-parameters` response.
class ProfileUserParametersResponseDto {
  /// Parameters payload, or `null` when the user has no parameters yet.
  final ProfileParametersInProfileDto? parameters;

  /// Creates an instance of [ProfileUserParametersResponseDto].
  const ProfileUserParametersResponseDto({required this.parameters});

  /// Creates a [ProfileUserParametersResponseDto] from JSON.
  factory ProfileUserParametersResponseDto.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is! Map<String, dynamic> || !data.containsKey('goal')) {
      return const ProfileUserParametersResponseDto(parameters: null);
    }
    return ProfileUserParametersResponseDto(
      parameters: ProfileParametersInProfileDto.fromJson(data),
    );
  }
}
