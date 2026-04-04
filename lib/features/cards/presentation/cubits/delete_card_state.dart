part of 'delete_card_cubit.dart';

/// State for [DeleteCardCubit].
@freezed
sealed class DeleteCardState with _$DeleteCardState {
  /// Initial idle state before the delete-card request starts.
  const factory DeleteCardState.initial() = _Initial;

  /// State emitted while the delete-card request is in progress.
  const factory DeleteCardState.inProgress(int pendingCardId) = _InProgress;

  /// State emitted when delete-card succeeds.
  const factory DeleteCardState.succeed() = _Succeed;

  /// State emitted when delete-card fails.
  const factory DeleteCardState.failed(CardsFailure failure) = _Failed;
}
