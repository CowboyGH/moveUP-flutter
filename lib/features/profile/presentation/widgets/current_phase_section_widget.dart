import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../uikit/buttons/button_state.dart';
import '../../../../../uikit/buttons/main_button.dart';
import '../../../../../uikit/themes/colors/app_color_theme.dart';
import '../../../../../uikit/themes/text/app_text_theme.dart';
import '../cubits/profile_statistics_cubit.dart';
import '../cubits/profile_user_cubit.dart';

/// Read-only profile section with the current phase name and summary numbers.
class CurrentPhaseSectionWidget extends StatelessWidget {
  /// Creates an instance of [CurrentPhaseSectionWidget].
  const CurrentPhaseSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileUserCubit, ProfileUserState>(
      buildWhen: (previous, current) =>
          previous.phaseSnapshot != current.phaseSnapshot ||
          previous.isLoading != current.isLoading,
      builder: (context, userState) {
        final phaseSnapshot = userState.phaseSnapshot;
        if (phaseSnapshot == null) {
          return _CurrentPhaseErrorState(
            onRetryPressed: () => context.read<ProfileUserCubit>().refresh(),
            isLoading: userState.isLoading,
          );
        }

        if (!phaseSnapshot.hasProgress || (phaseSnapshot.currentPhaseName?.isEmpty ?? true)) {
          return _CurrentPhaseEmptyState(
            currentPhaseName: phaseSnapshot.currentPhaseName,
          );
        }

        return BlocBuilder<ProfileStatisticsCubit, ProfileStatisticsState>(
          buildWhen: (previous, current) =>
              previous.currentPhaseSummary != current.currentPhaseSummary ||
              previous.isLoadingCurrentPhaseSummary != current.isLoadingCurrentPhaseSummary ||
              previous.currentPhaseSummaryFailure != current.currentPhaseSummaryFailure,
          builder: (context, statisticsState) {
            final currentPhaseSummary = statisticsState.currentPhaseSummary;
            if (currentPhaseSummary == null) {
              if (statisticsState.isLoadingCurrentPhaseSummary) {
                return _CurrentPhaseLoadingState(
                  currentPhaseName: phaseSnapshot.currentPhaseName!,
                );
              }

              return _CurrentPhaseErrorState(
                currentPhaseName: phaseSnapshot.currentPhaseName,
                onRetryPressed: () =>
                    context.read<ProfileStatisticsCubit>().reloadCurrentPhaseSummary(),
                isLoading: false,
              );
            }

            return _CurrentPhaseContent(
              currentPhaseName: phaseSnapshot.currentPhaseName!,
              averagePerWeek: _formatAveragePerWeek(currentPhaseSummary.averagePerWeek),
              weeklyGoal: '${currentPhaseSummary.weeklyGoal}',
            );
          },
        );
      },
    );
  }
}

final class _CurrentPhaseContent extends StatelessWidget {
  final String currentPhaseName;
  final String averagePerWeek;
  final String weeklyGoal;

  const _CurrentPhaseContent({
    required this.currentPhaseName,
    required this.averagePerWeek,
    required this.weeklyGoal,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _CurrentPhaseTitle(),
        const SizedBox(height: 4),
        _CurrentPhaseNameField(currentPhaseName: currentPhaseName),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _CurrentPhaseSummaryText(averagePerWeek: averagePerWeek),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 31),
              child: _CurrentPhaseGoalBox(weeklyGoal: weeklyGoal),
            ),
          ],
        ),
      ],
    );
  }
}

final class _CurrentPhaseLoadingState extends StatelessWidget {
  final String currentPhaseName;

  const _CurrentPhaseLoadingState({
    required this.currentPhaseName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _CurrentPhaseTitle(),
        const SizedBox(height: 4),
        _CurrentPhaseNameField(currentPhaseName: currentPhaseName),
        const SizedBox(height: 20),
        const Center(
          child: SizedBox.square(
            dimension: 24,
            child: CircularProgressIndicator.adaptive(strokeWidth: 2),
          ),
        ),
      ],
    );
  }
}

final class _CurrentPhaseErrorState extends StatelessWidget {
  final String? currentPhaseName;
  final VoidCallback onRetryPressed;
  final bool isLoading;

  const _CurrentPhaseErrorState({
    required this.onRetryPressed,
    required this.isLoading,
    this.currentPhaseName,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _CurrentPhaseTitle(),
        const SizedBox(height: 4),
        _CurrentPhaseNameField(
          currentPhaseName: currentPhaseName ?? AppStrings.profileCurrentPhaseEmpty,
        ),
        const SizedBox(height: 20),
        Text(
          AppStrings.profileCurrentPhaseLoadFailed,
          style: textTheme.body.copyWith(color: colorTheme.onSurface),
        ),
        const SizedBox(height: 16),
        MainButton(
          state: isLoading ? ButtonState.loading : ButtonState.enabled,
          onPressed: onRetryPressed,
          child: const Text(AppStrings.retryButton),
        ),
      ],
    );
  }
}

final class _CurrentPhaseEmptyState extends StatelessWidget {
  final String? currentPhaseName;

  const _CurrentPhaseEmptyState({
    this.currentPhaseName,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _CurrentPhaseTitle(),
        const SizedBox(height: 4),
        _CurrentPhaseNameField(
          currentPhaseName: currentPhaseName ?? AppStrings.profileCurrentPhaseEmpty,
        ),
        const SizedBox(height: 20),
        Text(
          AppStrings.profileCurrentPhaseEmpty,
          style: textTheme.body.copyWith(color: colorTheme.onSurface),
        ),
      ],
    );
  }
}

final class _CurrentPhaseTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return Text(
      AppStrings.profileCurrentPhaseTitle,
      style: textTheme.bodyMedium.copyWith(
        color: colorTheme.onSurface,
      ),
    );
  }
}

final class _CurrentPhaseNameField extends StatelessWidget {
  final String currentPhaseName;

  const _CurrentPhaseNameField({
    required this.currentPhaseName,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colorTheme.outline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          currentPhaseName,
          style: textTheme.bodyMedium.copyWith(
            color: colorTheme.darkHint,
          ),
        ),
      ),
    );
  }
}

final class _CurrentPhaseSummaryText extends StatelessWidget {
  final String averagePerWeek;

  const _CurrentPhaseSummaryText({
    required this.averagePerWeek,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return Text(
      '${AppStrings.profileCurrentPhaseTrainingsPerWeek(averagePerWeek)}\n'
      '${AppStrings.profileCurrentPhaseRecommendation}',
      style: textTheme.body.copyWith(
        color: colorTheme.onSurface,
      ),
    );
  }
}

final class _CurrentPhaseGoalBox extends StatelessWidget {
  final String weeklyGoal;

  const _CurrentPhaseGoalBox({
    required this.weeklyGoal,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return SizedBox(
      width: 41,
      height: 41,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: colorTheme.outline),
        ),
        child: Center(
          child: Text(
            weeklyGoal,
            style: textTheme.bodyMedium.copyWith(
              color: colorTheme.darkHint,
            ),
          ),
        ),
      ),
    );
  }
}

String _formatAveragePerWeek(double value) {
  if (value == value.roundToDouble()) {
    return value.toStringAsFixed(0);
  }

  return value.toStringAsFixed(1).replaceFirst('.', ',');
}
