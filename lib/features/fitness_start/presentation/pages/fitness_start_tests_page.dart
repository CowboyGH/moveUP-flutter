import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/router_paths.dart';
import '../../../../uikit/buttons/main_button.dart';
import '../../../../uikit/images/svg_picture_widget.dart';
import '../../../../uikit/themes/colors/app_color_theme.dart';
import '../../../../uikit/themes/text/app_text_theme.dart';
import '../../../auth/presentation/cubits/auth_session_cubit.dart';
import '../../../tests/catalog/presentation/cubits/tests_catalog_cubit.dart';
import '../../../tests/catalog/presentation/widgets/testing_catalog_carousel.dart';
import '../widgets/fitness_start_flow_app_bar.dart';

/// Fitness Start screen that displays tests catalog carousel.
class FitnessStartTestsPage extends StatelessWidget {
  /// Creates an instance of [FitnessStartTestsPage].
  const FitnessStartTestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authSessionCubit = context.read<AuthSessionCubit>();
    final textTheme = AppTextTheme.of(context);
    final colorTheme = AppColorTheme.of(context);
    return Scaffold(
      appBar: FitnessStartFlowAppBar(
        title: AppStrings.fitnessStartTestsTitle,
        progress: 0.75,
        showBackButton: true,
        onBackPressed: () => unawaited(authSessionCubit.cancelGuestFlow()),
      ),
      body: Stack(
        children: [
          Positioned(
            right: -120,
            bottom: -180,
            child: IgnorePointer(
              child: ExcludeSemantics(
                child: SvgPictureWidget.frame(
                  AppAssets.imageFigure,
                  color: colorTheme.primary.withValues(alpha: 0.3),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  AppStrings.fitnessStartTestsDescription,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorTheme.onSurface,
                  ),
                ),
                const SizedBox(height: 20),
                BlocBuilder<TestsCatalogCubit, TestsCatalogState>(
                  builder: (context, state) {
                    return state.when(
                      initial: SizedBox.shrink,
                      inProgress: _buildLoadingState,
                      loaded: (items) {
                        if (items.isEmpty) return _buildRetryState(context);
                        return TestingCatalogCarousel(
                          items: items,
                          onTestingSelected: (item) => context.push(
                            AppRoutePaths.fitnessStartTestAttemptDetailsPath(item.id),
                          ),
                        );
                      },
                      failed: (_) => _buildRetryState(context),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: SizedBox.square(
          dimension: 24,
          child: CircularProgressIndicator.adaptive(strokeWidth: 2),
        ),
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
            AppStrings.testsLoadFailed,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium.copyWith(color: colorTheme.onSurface),
          ),
          const SizedBox(height: 24),
          MainButton(
            onPressed: context.read<TestsCatalogCubit>().loadTestings,
            child: const Text(AppStrings.fitnessStartRetryButton),
          ),
        ],
      ),
    );
  }
}
