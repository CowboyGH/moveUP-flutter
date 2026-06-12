import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/router_paths.dart';
import '../../../../uikit/buttons/app_back_button.dart';
import '../../../../uikit/buttons/main_button.dart';
import '../../../../uikit/cards/app_card.dart';
import '../../../../uikit/images/svg_picture_widget.dart';
import '../../../../uikit/themes/colors/app_color_theme.dart';
import '../../../../uikit/themes/text/app_text_theme.dart';
import '../../domain/entities/subscription_catalog_item.dart';
import '../cubits/subscription_details_cubit.dart';
import '../cubits/subscription_payment_cubit.dart';
import '../widgets/subscription_card.dart';
import '../widgets/subscription_payment_dialog.dart';

/// Subscription details page.
class SubscriptionsDetailsPage extends StatelessWidget {
  /// Requested subscription identifier used by retry actions.
  final int subscriptionId;

  /// Creates an instance of [SubscriptionsDetailsPage].
  const SubscriptionsDetailsPage({
    required this.subscriptionId,
    super.key,
  });

  void _handleBack(BuildContext context) {
    if (Navigator.canPop(context)) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.subscriptionsCatalogPath);
  }

  Future<void> _openPaymentDialog(
    BuildContext context,
    SubscriptionCatalogItem item,
  ) async {
    final didPay = await showSubscriptionPaymentDialog(
      context,
      item: item,
      paymentCubit: context.read<SubscriptionPaymentCubit>(),
    );
    if (!context.mounted || didPay != true) return;
    context.go(AppRoutePaths.profilePath);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: AppBackButton(onPressed: () => _handleBack(context)),
        title: Text(
          AppStrings.subscriptionsCatalogTitle,
          style: textTheme.appBarTitle,
        ),
      ),
      body: BlocBuilder<SubscriptionDetailsCubit, SubscriptionDetailsState>(
        builder: (context, state) {
          return _buildStateSection(context, state);
        },
      ),
    );
  }

  Widget _buildStateSection(BuildContext context, SubscriptionDetailsState state) {
    return state.when(
      initial: () => const SizedBox.shrink(),
      inProgress: _buildLoadingState,
      loaded: (item) => _buildLoadedState(context, item),
      failed: (_) => _buildRetryState(context),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: SizedBox.square(
        dimension: 24,
        child: CircularProgressIndicator.adaptive(strokeWidth: 2),
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, SubscriptionCatalogItem item) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SubscriptionCard(item: item),
          const SizedBox(height: 36),
          _SubscriptionInfoCard(
            item: item,
            onPurchasePressed: () => _openPaymentDialog(context, item),
          ),
          const SizedBox(height: 36),
          const _SubscriptionAdvantagesSection(),
        ],
      ),
    );
  }

  Widget _buildRetryState(BuildContext context) {
    final textTheme = AppTextTheme.of(context);
    final colorTheme = AppColorTheme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppStrings.subscriptionsDetailsLoadFailed,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium.copyWith(color: colorTheme.onSurface),
          ),
          const SizedBox(height: 24),
          MainButton(
            onPressed: () => context.read<SubscriptionDetailsCubit>().loadInitial(subscriptionId),
            child: const Text(AppStrings.retryButton),
          ),
        ],
      ),
    );
  }
}

final class _SubscriptionInfoCard extends StatelessWidget {
  final SubscriptionCatalogItem item;
  final VoidCallback onPurchasePressed;

  const _SubscriptionInfoCard({
    required this.item,
    required this.onPurchasePressed,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextTheme.of(context);
    final colorTheme = AppColorTheme.of(context);
    final descriptionItems = _splitDescription(item.description);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '${AppStrings.subscriptionsDetailsInfoPrefix} "${item.name}"',
          style: textTheme.title.copyWith(
            fontSize: 18,
            height: 27 / 18,
            fontWeight: FontWeight.w600,
            color: colorTheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          AppStrings.subscriptionsDetailsAccessDescription,
          style: textTheme.bodyMedium.copyWith(color: colorTheme.onSurface),
        ),
        const SizedBox(height: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(descriptionItems.length, (index) {
            final line = descriptionItems[index];
            return Padding(
              padding: EdgeInsets.only(bottom: index == descriptionItems.length - 1 ? 0 : 8),
              child: Row(
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
                      line,
                      style: textTheme.body.copyWith(color: colorTheme.onSurface),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
        const SizedBox(height: 32),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '${SubscriptionCard.formatPrice(item.price)} ${AppStrings.subscriptionsCatalogRubles}',
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
          onPressed: onPurchasePressed,
          child: const Text(AppStrings.subscriptionsDetailsBuyButton),
        ),
      ],
    );
  }

  List<String> _splitDescription(String description) {
    final normalized = description.replaceAll('\n', ' ').replaceAll('\r', ' ').trim();
    if (normalized.isEmpty) return const [];

    final items = <String>[];
    var buffer = StringBuffer();

    for (var index = 0; index < normalized.length; index++) {
      final char = normalized[index];
      buffer.write(char);
      if (char == '.' || char == '!' || char == '?') {
        final sentence = buffer.toString().trim();
        if (sentence.isNotEmpty) {
          items.add(sentence);
        }
        buffer = StringBuffer();
      }
    }

    final tail = buffer.toString().trim();
    if (tail.isNotEmpty) {
      items.add(tail);
    }

    return items;
  }
}

final class _SubscriptionAdvantagesSection extends StatelessWidget {
  const _SubscriptionAdvantagesSection();

  @override
  Widget build(BuildContext context) {
    return const Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: -5,
          right: 0,
          top: -30,
          child: IgnorePointer(
            child: ExcludeSemantics(
              child: SvgPictureWidget.frame(AppAssets.imageLineVariant),
            ),
          ),
        ),
        _SubscriptionAdvantagesCard(),
      ],
    );
  }
}

final class _SubscriptionAdvantagesCard extends StatelessWidget {
  const _SubscriptionAdvantagesCard();

  static const _items = [
    (
      AppStrings.subscriptionsDetailsAdvantageLoadTitle,
      AppStrings.subscriptionsDetailsAdvantageLoadSubtitle,
    ),
    (
      AppStrings.subscriptionsDetailsAdvantageInjuryTitle,
      AppStrings.subscriptionsDetailsAdvantageInjurySubtitle,
    ),
    (
      AppStrings.subscriptionsDetailsAdvantageDiagnosticsTitle,
      AppStrings.subscriptionsDetailsAdvantageDiagnosticsSubtitle,
    ),
    (
      AppStrings.subscriptionsDetailsAdvantagePlanTitle,
      AppStrings.subscriptionsDetailsAdvantagePlanSubtitle,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextTheme.of(context);
    final colorTheme = AppColorTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorTheme.secondary.withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.subscriptionsDetailsAdvantagesTitle,
              style: textTheme.title.copyWith(
                fontSize: 18,
                height: 27 / 18,
                fontWeight: FontWeight.w600,
                color: colorTheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                style: textTheme.body.copyWith(color: colorTheme.onSurface),
                children: [
                  const TextSpan(text: AppStrings.subscriptionsDetailsAdvantagesDescriptionPrefix),
                  TextSpan(
                    text: AppStrings.subscriptionsDetailsAdvantagesDescriptionHighlighted,
                    style: textTheme.body.copyWith(
                      color: colorTheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const TextSpan(text: AppStrings.subscriptionsDetailsAdvantagesDescriptionSuffix),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ...List.generate(_items.length, (index) {
              final item = _items[index];
              return Padding(
                padding: EdgeInsets.only(bottom: index == _items.length - 1 ? 0 : 20),
                child: _SubscriptionAdvantageItemCard(
                  title: item.$1,
                  subtitle: item.$2,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

final class _SubscriptionAdvantageItemCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SubscriptionAdvantageItemCard({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextTheme.of(context);
    final colorTheme = AppColorTheme.of(context);
    return AppCard(
      height: 248,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPictureWidget.icon(
            AppAssets.iconStats,
            color: colorTheme.secondary,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: textTheme.bodyMedium.copyWith(
              fontSize: 16,
              height: 24 / 16,
              fontWeight: FontWeight.w600,
              color: colorTheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            subtitle,
            style: textTheme.body.copyWith(color: colorTheme.onSurface),
          ),
        ],
      ),
    );
  }
}
