part of 'save_card_cubit.dart';

/// State for [SaveCardCubit].
@freezed
sealed class SaveCardState with _$SaveCardState {
  /// Initial idle state before the save-card request starts.
  const factory SaveCardState.initial() = _Initial;

  /// State emitted while the save-card request is in progress.
  const factory SaveCardState.inProgress() = _InProgress;

  /// State emitted when save-card succeeds.
  const factory SaveCardState.succeed() = _Succeed;

  /// State emitted when save-card fails.
  const factory SaveCardState.failed(CardsFailure failure) = _Failed;
}
