import 'package:equatable/equatable.dart';

/// Focused phase snapshot used by the profile current phase section.
final class ProfilePhaseSnapshot extends Equatable {
  /// Whether the authenticated user has active phase progress.
  final bool hasProgress;

  /// Current phase display name.
  final String? currentPhaseName;

  /// Creates an instance of [ProfilePhaseSnapshot].
  const ProfilePhaseSnapshot({
    required this.hasProgress,
    required this.currentPhaseName,
  });

  @override
  List<Object?> get props => [hasProgress, currentPhaseName];
}
