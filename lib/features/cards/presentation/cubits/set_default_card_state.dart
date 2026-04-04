part of 'set_default_card_cubit.dart';

/// State for [SetDefaultCardCubit].
@freezed
sealed class SetDefaultCardState with _$SetDefaultCardState {
  /// Initial idle state before the default-card request starts.
  const factory SetDefaultCardState.initial() = _Initial;

  /// State emitted while the default-card request is in progress.
  const factory SetDefaultCardState.inProgress(int pendingCardId) = _InProgress;

  /// State emitted when default-card succeeds.
  const factory SetDefaultCardState.succeed() = _Succeed;

  /// State emitted when default-card fails.
  const factory SetDefaultCardState.failed(CardsFailure failure) = _Failed;
}
