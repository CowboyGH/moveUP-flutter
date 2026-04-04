import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../uikit/buttons/button_state.dart';
import '../../../../../uikit/buttons/main_button.dart';
import '../../../../../uikit/buttons/secondary_button.dart';
import '../../../../../uikit/cards/app_card.dart';
import '../../../../../uikit/dialogs/app_action_dialog.dart';
import '../../../../../uikit/dialogs/app_feedback_dialog.dart';
import '../../../../../uikit/images/svg_picture_widget.dart';
import '../../../../../uikit/themes/colors/app_color_theme.dart';
import '../../../../../uikit/themes/text/app_text_theme.dart';
import '../../../cards/domain/entities/saved_card.dart';
import '../../../cards/presentation/cubits/cards_cubit.dart';
import '../../../cards/presentation/cubits/delete_card_cubit.dart';
import '../../../cards/presentation/cubits/save_card_cubit.dart';
import '../../../cards/presentation/cubits/set_default_card_cubit.dart';
import '../../../cards/presentation/widgets/save_card_dialog.dart';

/// Cards section rendered inside `/profile`.
class ProfileCardsSectionWidget extends StatefulWidget {
  /// Creates an instance of [ProfileCardsSectionWidget].
  const ProfileCardsSectionWidget({super.key});

  @override
  State<ProfileCardsSectionWidget> createState() => _ProfileCardsSectionWidgetState();
}

class _ProfileCardsSectionWidgetState extends State<ProfileCardsSectionWidget> {
  bool _isDeleteDialogOpen = false;

  Future<void> _openSaveCardDialog(List<SavedCard> cards) async {
    if (cards.length >= 3) {
      await showAppFeedbackDialog(
        context,
        title: AppStrings.cardsAddLimitTitle,
        message: AppStrings.cardsAddLimitMessage,
      );
      return;
    }

    final didSave = await showSaveCardDialog(
      context,
      saveCardCubit: context.read<SaveCardCubit>(),
    );
    if (!mounted || didSave != true) return;

    unawaited(context.read<CardsCubit>().loadCards());
  }

  Future<void> _openDeleteDialog(int cardId) async {
    if (_isDeleteDialogOpen) return;
    _isDeleteDialogOpen = true;
    final deleteCardCubit = context.read<DeleteCardCubit>();
    try {
      await showAppActionDialog(
        context,
        title: AppStrings.cardsDeleteTitle,
        description: AppStrings.cardsDeleteDescription,
        primaryAction: BlocProvider.value(
          value: deleteCardCubit,
          child: BlocBuilder<DeleteCardCubit, DeleteCardState>(
            builder: (context, state) {
              final isInProgress = state.maybeWhen(
                inProgress: (pendingCardId) => pendingCardId == cardId,
                orElse: () => false,
              );
              return MainButton(
                state: isInProgress ? ButtonState.loading : ButtonState.enabled,
                onPressed: () => context.read<DeleteCardCubit>().deleteCard(cardId),
                child: const Text(AppStrings.cardsDeleteConfirmButton),
              );
            },
          ),
        ),
        secondaryAction: BlocProvider.value(
          value: deleteCardCubit,
          child: BlocBuilder<DeleteCardCubit, DeleteCardState>(
            builder: (context, state) {
              final isInProgress = state.maybeWhen(
                inProgress: (_) => true,
                orElse: () => false,
              );
              return SecondaryButton(
                state: isInProgress ? ButtonState.disabled : ButtonState.enabled,
                onPressed: _closeActiveDialog,
                child: const Text(AppStrings.profileCancelButton),
              );
            },
          ),
        ),
      );
    } finally {
      _isDeleteDialogOpen = false;
    }
  }

  void _closeActiveDialog() {
    final navigator = Navigator.of(context, rootNavigator: true);
    if (!navigator.canPop()) return;

    Route<dynamic>? topRoute;
    navigator.popUntil((route) {
      topRoute = route;
      return true;
    });
    if (topRoute is! PopupRoute<dynamic>) return;

    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SetDefaultCardCubit, SetDefaultCardState>(
          listener: (context, state) {
            state.whenOrNull(
              succeed: () => unawaited(context.read<CardsCubit>().loadCards()),
              failed: (failure) {
                if (failure.message.isEmpty) return;
                unawaited(
                  showAppFeedbackDialog(
                    context,
                    title: AppStrings.feedbackErrorTitle,
                    message: failure.message,
                  ),
                );
              },
            );
          },
        ),
        BlocListener<DeleteCardCubit, DeleteCardState>(
          listener: (context, state) {
            state.whenOrNull(
              succeed: () {
                _closeActiveDialog();
                unawaited(context.read<CardsCubit>().loadCards());
              },
              failed: (failure) {
                _closeActiveDialog();
                if (failure.message.isEmpty) return;
                unawaited(
                  showAppFeedbackDialog(
                    context,
                    title: AppStrings.feedbackErrorTitle,
                    message: failure.message,
                  ),
                );
              },
            );
          },
        ),
      ],
      child: BlocBuilder<CardsCubit, CardsState>(
        builder: (context, state) {
          final cards = state.cards;
          final isInitialLoading = state.isLoading && cards.isEmpty;
          final hasInitialFailure = state.failure != null && cards.isEmpty;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppStrings.cardsSectionTitle,
                style: AppTextTheme.of(context).sectionTitle.copyWith(
                  color: AppColorTheme.of(context).onSurface,
                ),
              ),
              const SizedBox(height: 16),
              if (isInitialLoading)
                const Center(
                  child: SizedBox.square(
                    dimension: 24,
                    child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                  ),
                )
              else if (hasInitialFailure)
                _CardsRetryState(
                  onRetryPressed: () => context.read<CardsCubit>().loadCards(),
                )
              else ...[
                if (cards.isNotEmpty)
                  Column(
                    children: List.generate(cards.length, (index) {
                      final card = cards[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: index == cards.length - 1 ? 0 : 20),
                        child: _SavedCardDetailsWidget(
                          card: card,
                          onMakeDefaultPressed: () =>
                              context.read<SetDefaultCardCubit>().setDefaultCard(card.id),
                          onDeletePressed: () => _openDeleteDialog(card.id),
                        ),
                      );
                    }),
                  ),
                if (cards.isNotEmpty) const SizedBox(height: 20),
                _AddCardButton(
                  onPressed: () => _openSaveCardDialog(cards),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

final class _SavedCardDetailsWidget extends StatelessWidget {
  final SavedCard card;
  final VoidCallback onMakeDefaultPressed;
  final VoidCallback onDeletePressed;

  const _SavedCardDetailsWidget({
    required this.card,
    required this.onMakeDefaultPressed,
    required this.onDeletePressed,
  });

  String _formatExpiryYear(String value) {
    if (value.length <= 2) return value;
    return value.substring(value.length - 2);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextTheme.of(context);
    final colorTheme = AppColorTheme.of(context);
    final isSetDefaultLoading = context.select<SetDefaultCardCubit, bool>(
      (cubit) => cubit.state.maybeWhen(
        inProgress: (pendingCardId) => pendingCardId == card.id,
        orElse: () => false,
      ),
    );
    final isDeleteLoading = context.select<DeleteCardCubit, bool>(
      (cubit) => cubit.state.maybeWhen(
        inProgress: (pendingCardId) => pendingCardId == card.id,
        orElse: () => false,
      ),
    );
    final isAnyDefaultInProgress = context.select<SetDefaultCardCubit, bool>(
      (cubit) => cubit.state.maybeWhen(
        inProgress: (_) => true,
        orElse: () => false,
      ),
    );
    final isAnyDeleteInProgress = context.select<DeleteCardCubit, bool>(
      (cubit) => cubit.state.maybeWhen(
        inProgress: (_) => true,
        orElse: () => false,
      ),
    );

    return AppCard(
      contentPadding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SvgPictureWidget.icon(AppAssets.iconCardSmall),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '**** ${card.lastFour}',
                          style: textTheme.bodyMedium.copyWith(
                            fontSize: 16,
                            height: 24 / 16,
                            fontWeight: FontWeight.w500,
                            color: colorTheme.onSurface,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${card.expiryMonth}/${_formatExpiryYear(card.expiryYear)}',
                          style: textTheme.bodyMedium.copyWith(
                            fontSize: 16,
                            height: 24 / 16,
                            fontWeight: FontWeight.w400,
                            color: colorTheme.hint,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      card.holderName,
                      style: textTheme.bodyMedium.copyWith(color: colorTheme.onSurface),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  state: card.isDefault
                      ? ButtonState.disabled
                      : isSetDefaultLoading
                      ? ButtonState.loading
                      : isAnyDefaultInProgress || isAnyDeleteInProgress
                      ? ButtonState.disabled
                      : ButtonState.enabled,
                  onPressed: onMakeDefaultPressed,
                  child: Text(
                    card.isDefault
                        ? AppStrings.cardsDefaultButton
                        : AppStrings.cardsMakeDefaultButton,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              _DeleteCardButton(
                isLoading: isDeleteLoading,
                isDisabled: isAnyDeleteInProgress && !isDeleteLoading,
                onPressed: onDeletePressed,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

final class _DeleteCardButton extends StatelessWidget {
  final bool isLoading;
  final bool isDisabled;
  final VoidCallback onPressed;

  const _DeleteCardButton({
    required this.isLoading,
    required this.isDisabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    final isInactive = isDisabled || isLoading;

    return IgnorePointer(
      ignoring: isInactive,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const .all(10),
          decoration: BoxDecoration(
            color: isInactive ? colorTheme.disabled : colorTheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colorTheme.darkHint),
          ),
          child: Center(
            child: SvgPictureWidget.icon(
              AppAssets.iconCloseVariant,
              color: colorTheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

final class _CardsRetryState extends StatelessWidget {
  final VoidCallback onRetryPressed;

  const _CardsRetryState({
    required this.onRetryPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          AppStrings.cardsLoadFailed,
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium.copyWith(color: colorTheme.onSurface),
        ),
        const SizedBox(height: 16),
        MainButton(
          onPressed: onRetryPressed,
          child: const Text(AppStrings.retryButton),
        ),
      ],
    );
  }
}

final class _AddCardButton extends StatefulWidget {
  final VoidCallback onPressed;

  const _AddCardButton({
    required this.onPressed,
  });

  @override
  State<_AddCardButton> createState() => _AddCardButtonState();
}

class _AddCardButtonState extends State<_AddCardButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final foreground = _isPressed ? colorTheme.primary : colorTheme.onSurface;
    final borderColor = _isPressed ? colorTheme.primary : colorTheme.outline.withValues(alpha: 0.6);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorTheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: InkWell(
        onTap: widget.onPressed,
        onHighlightChanged: (value) {
          if (!mounted) return;
          setState(() => _isPressed = value);
        },
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          height: 38,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppStrings.cardsAddButton,
                  style: textTheme.label.copyWith(color: foreground),
                ),
                const SizedBox(width: 2),
                SvgPictureWidget.icon(
                  AppAssets.iconPlus,
                  color: foreground,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
