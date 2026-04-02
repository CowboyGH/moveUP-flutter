import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/router_paths.dart';
import '../../../../uikit/buttons/app_back_button.dart';
import '../../../../uikit/buttons/main_button.dart';
import '../../../../uikit/images/app_decorative_figure.dart';
import '../../../../uikit/themes/colors/app_color_theme.dart';
import '../../../../uikit/themes/text/app_text_theme.dart';
import '../../domain/entities/subscription_catalog_item.dart';
import '../cubits/subscriptions_cubit.dart';
import '../widgets/subscription_card.dart';

/// Fullscreen subscriptions catalog page.
class SubscriptionsCatalogPage extends StatelessWidget {
  /// Creates an instance of [SubscriptionsCatalogPage].
  const SubscriptionsCatalogPage({super.key});

  void _handleBack(BuildContext context) {
    if (Navigator.canPop(context)) {
      context.pop();
      return;
    }
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
      body: BlocBuilder<SubscriptionsCubit, SubscriptionsState>(
        builder: (context, state) {
          return Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                left: -140,
                top: 113,
                child: IgnorePointer(
                  child: ExcludeSemantics(
                    child: Transform.scale(
                      scaleY: -1,
                      child: Transform.rotate(
                        angle: -163 * (math.pi / 180),
                        child: const AppDecorativeFigure(tone: FigureTone.primary),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: -80,
                bottom: 20,
                child: IgnorePointer(
                  child: ExcludeSemantics(
                    child: Transform.scale(
                      scaleY: -1,
                      child: Transform.rotate(
                        angle: -180 * (math.pi / 180),
                        child: const AppDecorativeFigure(tone: FigureTone.secondary),
                      ),
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

  Widget _buildStateSection(BuildContext context, SubscriptionsState state) {
    return state.when(
      initial: () => const SizedBox.shrink(),
      inProgress: _buildLoadingState,
      loaded: (items) => _buildLoadedState(context, items),
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

  Widget _buildLoadedState(BuildContext context, List<SubscriptionCatalogItem> items) {
    if (items.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            AppStrings.subscriptionsCatalogEmpty,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(items.length, (index) {
          final item = items[index];
          return Padding(
            padding: EdgeInsets.only(bottom: index == items.length - 1 ? 0 : 12),
            child: SubscriptionCard(
              item: item,
              onPressed: () => context.push(
                AppRoutePaths.subscriptionsDetailsConcretePath(item.id),
                extra: item,
              ),
            ),
          );
        }),
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
            AppStrings.subscriptionsCatalogLoadFailed,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium.copyWith(color: colorTheme.onSurface),
          ),
          const SizedBox(height: 24),
          MainButton(
            onPressed: context.read<SubscriptionsCubit>().loadSubscriptions,
            child: const Text(AppStrings.retryButton),
          ),
        ],
      ),
    );
  }
}
