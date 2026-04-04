import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/router/router_paths.dart';
import '../../../../../uikit/buttons/button_state.dart';
import '../../../../../uikit/buttons/main_button.dart';
import '../../../../../uikit/buttons/secondary_button.dart';
import '../../../../../uikit/dialogs/app_action_dialog.dart';
import '../../../../../uikit/dialogs/app_feedback_dialog.dart';
import '../../../../../uikit/themes/colors/app_color_theme.dart';
import '../../../../../uikit/themes/text/app_text_theme.dart';
import '../../../subscriptions/domain/entities/subscription_catalog_item.dart';
import '../../../subscriptions/presentation/cubits/cancel_subscription_cubit.dart';
import '../../../subscriptions/presentation/widgets/subscription_card.dart';
import '../../domain/entities/profile_stats_history_snapshot.dart';
import '../cubits/profile_refresh_cubit.dart';
import '../cubits/profile_subscription_cubit.dart';

/// Subscription section rendered inside `/profile`.
class ProfileSubscriptionSectionWidget extends StatefulWidget {
  /// Active subscription snapshot from the canonical `/profile` payload.
  final ProfileActiveSubscriptionSnapshot? activeSubscription;

  /// Creates an instance of [ProfileSubscriptionSectionWidget].
  const ProfileSubscriptionSectionWidget({
    required this.activeSubscription,
    super.key,
  });

  @override
  State<ProfileSubscriptionSectionWidget> createState() => _ProfileSubscriptionSectionWidgetState();
}

class _ProfileSubscriptionSectionWidgetState extends State<ProfileSubscriptionSectionWidget> {
  bool _isCancelDialogOpen = false;

  @override
  void initState() {
    super.initState();
    _syncActiveSubscription();
  }

  @override
  void didUpdateWidget(covariant ProfileSubscriptionSectionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activeSubscription == widget.activeSubscription) return;
    _syncActiveSubscription();
  }

  void _syncActiveSubscription() {
    unawaited(
      context.read<ProfileSubscriptionCubit>().syncActiveSubscription(widget.activeSubscription),
    );
  }

  void _openCatalog() {
    unawaited(context.push(AppRoutePaths.subscriptionsCatalogPath));
  }

  void _showCancelDialog() {
    unawaited(_openCancelDialog());
  }

  Future<void> _openCancelDialog() async {
    if (_isCancelDialogOpen) return;
    _isCancelDialogOpen = true;
    final cancelCubit = context.read<CancelSubscriptionCubit>();
    try {
      await showAppActionDialog(
        context,
        title: AppStrings.profileSubscriptionCancelTitle,
        description: AppStrings.profileSubscriptionCancelDescription,
        primaryAction: BlocProvider.value(
          value: cancelCubit,
          child: BlocBuilder<CancelSubscriptionCubit, CancelSubscriptionState>(
            builder: (context, state) {
              final isInProgress = state.maybeWhen(
                inProgress: () => true,
                orElse: () => false,
              );
              return MainButton(
                state: isInProgress ? ButtonState.loading : ButtonState.enabled,
                onPressed: () => context.read<CancelSubscriptionCubit>().cancelSubscription(),
                child: const Text(AppStrings.profileSubscriptionCancelConfirm),
              );
            },
          ),
        ),
        secondaryAction: BlocProvider.value(
          value: cancelCubit,
          child: BlocBuilder<CancelSubscriptionCubit, CancelSubscriptionState>(
            builder: (context, state) {
              final isInProgress = state.maybeWhen(
                inProgress: () => true,
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
      _isCancelDialogOpen = false;
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
    final activeSubscription = widget.activeSubscription;

    return BlocListener<CancelSubscriptionCubit, CancelSubscriptionState>(
      listener: (context, state) {
        state.whenOrNull(
          succeed: () {
            _closeActiveDialog();
            context.read<ProfileRefreshCubit>().requestRefresh();
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
      child: BlocBuilder<ProfileSubscriptionCubit, ProfileSubscriptionState>(
        builder: (context, state) {
          if (activeSubscription == null) {
            return _ProfileSubscriptionEmptyState(
              onPressed: _openCatalog,
            );
          }

          return _ProfileSubscriptionActiveState(
            activeSubscription: activeSubscription,
            item: state.item,
            isCardLoading: state.isLoading,
            hasCardFailure: state.failure != null,
            onRetryPressed: () => context.read<ProfileSubscriptionCubit>().retry(),
            onRenewPressed: _openCatalog,
            onCancelPressed: _showCancelDialog,
          );
        },
      ),
    );
  }
}

final class _ProfileSubscriptionActiveState extends StatelessWidget {
  final ProfileActiveSubscriptionSnapshot activeSubscription;
  final SubscriptionCatalogItem? item;
  final bool isCardLoading;
  final bool hasCardFailure;
  final VoidCallback onRetryPressed;
  final VoidCallback onRenewPressed;
  final VoidCallback onCancelPressed;

  const _ProfileSubscriptionActiveState({
    required this.activeSubscription,
    required this.item,
    required this.isCardLoading,
    required this.hasCardFailure,
    required this.onRetryPressed,
    required this.onRenewPressed,
    required this.onCancelPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final resolvedPrice = item?.price ?? activeSubscription.price;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RichText(
          text: TextSpan(
            style: textTheme.sectionTitle,
            children: [
              TextSpan(
                text: '*',
                style: textTheme.sectionTitle.copyWith(color: colorTheme.onSurface),
              ),
              TextSpan(
                text: AppStrings.profileSubscriptionActiveTitleAccent,
                style: textTheme.sectionTitle.copyWith(color: colorTheme.secondary),
              ),
              TextSpan(
                text: AppStrings.profileSubscriptionActiveTitleSuffix,
                style: textTheme.sectionTitle.copyWith(color: colorTheme.onSurface),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _formatExpireDate(activeSubscription.endDate),
          style: textTheme.bodyMedium.copyWith(color: colorTheme.onSurface),
        ),
        const SizedBox(height: 12),
        if (item != null)
          SubscriptionCard(
            item: item!,
            onPressed: () => context.push(AppRoutePaths.subscriptionsDetailsConcretePath(item!.id)),
          )
        else if (isCardLoading)
          const _ProfileSubscriptionCardLoadingState()
        else if (hasCardFailure)
          _ProfileSubscriptionCardRetryState(onRetryPressed: onRetryPressed)
        else
          const _ProfileSubscriptionCardLoadingState(),
        const SizedBox(height: 28),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '${SubscriptionCard.formatPrice(resolvedPrice)} ${AppStrings.subscriptionsCatalogRubles}',
            style: textTheme.bodyMedium.copyWith(
              fontSize: 20,
              height: 24 / 20,
              fontWeight: FontWeight.w600,
              color: colorTheme.onSurface,
            ),
          ),
        ),
        const SizedBox(height: 24),
        MainButton(
          onPressed: onRenewPressed,
          child: const Text(AppStrings.profileSubscriptionRenewButton),
        ),
        const SizedBox(height: 12),
        SecondaryButton(
          onPressed: onCancelPressed,
          child: const Text(AppStrings.profileSubscriptionCancelButton),
        ),
      ],
    );
  }
}

final class _ProfileSubscriptionCardLoadingState extends StatelessWidget {
  const _ProfileSubscriptionCardLoadingState();

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);

    return Container(
      height: 306,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colorTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorTheme.secondary.withValues(alpha: 0.25),
        ),
      ),
      child: const SizedBox.square(
        dimension: 24,
        child: CircularProgressIndicator.adaptive(strokeWidth: 2),
      ),
    );
  }
}

final class _ProfileSubscriptionCardRetryState extends StatelessWidget {
  final VoidCallback onRetryPressed;

  const _ProfileSubscriptionCardRetryState({
    required this.onRetryPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorTheme.secondary.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppStrings.profileSubscriptionCardLoadFailed,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium.copyWith(color: colorTheme.onSurface),
          ),
          const SizedBox(height: 16),
          MainButton(
            onPressed: onRetryPressed,
            child: const Text(AppStrings.profileSubscriptionCardRetryButton),
          ),
        ],
      ),
    );
  }
}

final class _ProfileSubscriptionEmptyState extends StatelessWidget {
  final VoidCallback onPressed;

  const _ProfileSubscriptionEmptyState({
    required this.onPressed,
  });

  static const _benefits = [
    AppStrings.profileSubscriptionBenefitTrainings,
    AppStrings.profileSubscriptionBenefitTestsAndExercises,
  ];

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          AppStrings.profileSubscriptionEmptyTitle,
          style: textTheme.sectionTitle.copyWith(color: colorTheme.onSurface),
        ),
        const SizedBox(height: 8),
        Text(
          AppStrings.profileSubscriptionEmptySubtitle,
          style: textTheme.bodyMedium.copyWith(color: colorTheme.onSurface),
        ),
        const SizedBox(height: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(_benefits.length, (index) {
            return Padding(
              padding: EdgeInsets.only(bottom: index == _benefits.length - 1 ? 0 : 8),
              child: _ProfileSubscriptionBenefitRow(text: _benefits[index]),
            );
          }),
        ),
        const SizedBox(height: 24),
        MainButton(
          onPressed: onPressed,
          child: const Text(AppStrings.profileSubscriptionsButton),
        ),
      ],
    );
  }
}

final class _ProfileSubscriptionBenefitRow extends StatelessWidget {
  final String text;

  const _ProfileSubscriptionBenefitRow({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorTheme.secondary.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: textTheme.body.copyWith(color: colorTheme.onSurface),
          ),
        ),
      ],
    );
  }
}

String _formatExpireDate(String rawDate) {
  final parsed = DateTime.tryParse(rawDate);
  if (parsed == null) {
    return '${AppStrings.profileSubscriptionExpiryPrefix} $rawDate';
  }

  const months = [
    'января',
    'февраля',
    'марта',
    'апреля',
    'мая',
    'июня',
    'июля',
    'августа',
    'сентября',
    'октября',
    'ноября',
    'декабря',
  ];

  return '${AppStrings.profileSubscriptionExpiryPrefix} '
      '${parsed.day} ${months[parsed.month - 1]} ${parsed.year} г.';
}
