part of 'cards_cubit.dart';

/// State for [CardsCubit].
@freezed
abstract class CardsState with _$CardsState {
  /// Creates an instance of [CardsState].
  const factory CardsState({
    @Default(false) bool isLoading,
    @Default(<SavedCard>[]) List<SavedCard> cards,
    CardsFailure? failure,
  }) = _CardsState;
}
