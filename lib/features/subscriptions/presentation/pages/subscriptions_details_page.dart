import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/router_paths.dart';
import '../../../../uikit/buttons/app_back_button.dart';
import '../../../../uikit/buttons/button_state.dart';
import '../../../../uikit/buttons/main_button.dart';
import '../../../../uikit/cards/app_card.dart';
import '../../../../uikit/images/svg_picture_widget.dart';
import '../../../../uikit/themes/colors/app_color_theme.dart';
import '../../../../uikit/themes/text/app_text_theme.dart';
import '../../domain/entities/subscription_catalog_item.dart';
import '../cubits/subscription_details_cubit.dart';
import '../widgets/subscription_card.dart';

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
          return Stack(
            fit: StackFit.expand,
            children: [
              const Positioned(
                left: 100,
                top: 100,
                child: IgnorePointer(
                  child: ExcludeSemantics(
                    child: SvgPictureWidget.frame(
                      AppAssets.imageLine,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
              _buildStateSection(context, state),
            ],
          );
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
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 132),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SubscriptionCard(item: item),
          const SizedBox(height: 36),
          _SubscriptionInfoCard(item: item),
          const SizedBox(height: 36),
          const _SubscriptionAdvantagesCard(),
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

  const _SubscriptionInfoCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextTheme.of(context);
    final colorTheme = AppColorTheme.of(context);
    final descriptionItems = item.description
        .split(RegExp(r'\r?\n'))
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList(growable: false);

    return AppCard(
      contentPadding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${AppStrings.subscriptionsDetailsInfoPrefix} ${item.name}',
            style: textTheme.title.copyWith(
              fontSize: 18,
              height: 27 / 18,
              fontWeight: FontWeight.w600,
              color: colorTheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Row(
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
                  AppStrings.subscriptionsDetailsAccessDescription,
                  style: textTheme.bodyMedium.copyWith(color: colorTheme.onSurface),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: descriptionItems
                .map(
                  (line) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '•',
                          style: textTheme.body.copyWith(color: colorTheme.onSurface),
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
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 32),
          Text(
            '${SubscriptionCard.formatPrice(item.price)} ${AppStrings.subscriptionsCatalogRubles}',
            style: textTheme.bodyMedium.copyWith(
              fontSize: 20,
              height: 24 / 20,
              fontWeight: FontWeight.w600,
              color: colorTheme.onSurface,
            ),
          ),
          const SizedBox(height: 24),
          MainButton(
            state: ButtonState.disabled,
            onPressed: () {},
            child: const Text(AppStrings.subscriptionsDetailsBuyButton),
          ),
        ],
      ),
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
    return AppCard(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
              padding: EdgeInsets.only(bottom: index == _items.length - 1 ? 0 : 12),
              child: _SubscriptionAdvantageItemCard(
                title: item.$1,
                subtitle: item.$2,
              ),
            );
          }),
        ],
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
