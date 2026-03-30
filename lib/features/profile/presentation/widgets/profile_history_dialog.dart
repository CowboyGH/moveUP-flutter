import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../uikit/buttons/button_state.dart';
import '../../../../../uikit/buttons/option_button.dart';
import '../../../../../uikit/buttons/secondary_button.dart';
import '../../../../../uikit/themes/colors/app_color_theme.dart';
import '../../../../../uikit/themes/text/app_text_theme.dart';
import '../../domain/entities/profile_statistics/profile_history_tab.dart';
import '../../domain/entities/profile_stats_history_snapshot.dart';
import '../cubits/profile_statistics_cubit.dart';
import 'profile_dialog_shell.dart';

/// Opens the profile statistics history dialog.
Future<void> showProfileHistoryDialog(BuildContext context) {
  final cubit = context.read<ProfileStatisticsCubit>();
  cubit.selectHistoryTab(ProfileHistoryTab.subscriptions);

  return showProfileDialog<void>(
    context,
    insetPadding: const EdgeInsets.symmetric(horizontal: 19.5),
    child: BlocProvider.value(
      value: cubit,
      child: const ProfileHistoryDialog(),
    ),
  );
}

/// Dialog with local tabs for profile history snapshot.
class ProfileHistoryDialog extends StatelessWidget {
  /// Creates an instance of [ProfileHistoryDialog].
  const ProfileHistoryDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextTheme.of(context);
    return BlocBuilder<ProfileStatisticsCubit, ProfileStatisticsState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            Text(
              AppStrings.profileStatsHistoryTitle,
              textAlign: TextAlign.center,
              style: textTheme.title.copyWith(
                fontSize: 18,
                height: 27 / 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 28),
            _HistoryTabs(
              selectedTab: state.selectedHistoryTab,
              isEnabled: state.historySnapshot != null,
              onSelected: (tab) => context.read<ProfileStatisticsCubit>().selectHistoryTab(tab),
            ),
            const SizedBox(height: 20),
            if (state.historySnapshot == null)
              const _HistoryLoadingState()
            else
              _HistoryContent(
                snapshot: state.historySnapshot!,
                selectedTab: state.selectedHistoryTab,
              ),
            const SizedBox(height: 24),
            SecondaryButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(AppStrings.profileStatsHistoryCloseButton),
            ),
          ],
        );
      },
    );
  }
}

final class _HistoryTabs extends StatelessWidget {
  final ProfileHistoryTab selectedTab;
  final bool isEnabled;
  final ValueChanged<ProfileHistoryTab> onSelected;

  const _HistoryTabs({
    required this.selectedTab,
    required this.isEnabled,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final buttonState = isEnabled ? ButtonState.enabled : ButtonState.disabled;

    return Row(
      children: [
        Expanded(
          child: OptionButton(
            state: buttonState,
            isSelected: selectedTab == ProfileHistoryTab.subscriptions,
            onPressed: () => onSelected(ProfileHistoryTab.subscriptions),
            child: const Text(AppStrings.profileStatsHistorySubscriptionsTab),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OptionButton(
            state: buttonState,
            isSelected: selectedTab == ProfileHistoryTab.workouts,
            onPressed: () => onSelected(ProfileHistoryTab.workouts),
            child: const Text(AppStrings.profileStatsHistoryWorkoutsTab),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OptionButton(
            state: buttonState,
            isSelected: selectedTab == ProfileHistoryTab.tests,
            onPressed: () => onSelected(ProfileHistoryTab.tests),
            child: const Text(AppStrings.profileStatsHistoryTestsTab),
          ),
        ),
      ],
    );
  }
}

final class _HistoryLoadingState extends StatelessWidget {
  const _HistoryLoadingState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 28),
      child: Center(
        child: SizedBox.square(
          dimension: 24,
          child: CircularProgressIndicator.adaptive(strokeWidth: 2),
        ),
      ),
    );
  }
}

final class _HistoryContent extends StatelessWidget {
  final ProfileStatsHistorySnapshot snapshot;
  final ProfileHistoryTab selectedTab;

  const _HistoryContent({
    required this.snapshot,
    required this.selectedTab,
  });

  @override
  Widget build(BuildContext context) {
    final content = switch (selectedTab) {
      ProfileHistoryTab.subscriptions => _buildSubscriptionContent(),
      ProfileHistoryTab.workouts => _buildWorkoutContent(),
      ProfileHistoryTab.tests => _buildTestContent(),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColorTheme.of(context).outline.withValues(alpha: 0.7)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: content,
      ),
    );
  }

  Widget _buildSubscriptionContent() {
    final subscription = snapshot.activeSubscription;
    if (subscription == null) {
      return const _HistoryEmptyState(
        message: AppStrings.profileStatsHistorySubscriptionEmpty,
      );
    }

    return _HistoryValueList(
      items: [
        _HistoryValueItem(
          label: AppStrings.profileStatsHistoryNameLabel,
          value: subscription.name,
        ),
        _HistoryValueItem(
          label: AppStrings.profileStatsHistoryPriceLabel,
          value: subscription.price,
        ),
        _HistoryValueItem(
          label: AppStrings.profileStatsHistoryPeriodLabel,
          value: '${_formatDate(subscription.startDate)} - ${_formatDate(subscription.endDate)}',
        ),
      ],
    );
  }

  Widget _buildWorkoutContent() {
    final workout = snapshot.latestWorkout;
    if (workout == null) {
      return const _HistoryEmptyState(
        message: AppStrings.profileStatsHistoryWorkoutEmpty,
      );
    }

    return _HistoryValueList(
      items: [
        _HistoryValueItem(
          label: AppStrings.profileStatsHistoryNameLabel,
          value: workout.title,
        ),
        _HistoryValueItem(
          label: AppStrings.profileStatsHistoryCompletedAtLabel,
          value: _formatDate(workout.completedAt),
        ),
      ],
    );
  }

  Widget _buildTestContent() {
    final test = snapshot.latestTest;
    if (test == null) {
      return const _HistoryEmptyState(
        message: AppStrings.profileStatsHistoryTestEmpty,
      );
    }

    return _HistoryValueList(
      items: [
        _HistoryValueItem(
          label: AppStrings.profileStatsHistoryNameLabel,
          value: test.title,
        ),
        _HistoryValueItem(
          label: AppStrings.profileStatsHistoryCompletedAtLabel,
          value: _formatDate(test.completedAt),
        ),
      ],
    );
  }
}

final class _HistoryValueList extends StatelessWidget {
  final List<_HistoryValueItem> items;

  const _HistoryValueList({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: item == items.last ? 0 : 16),
              child: _HistoryValueRow(item: item),
            ),
          )
          .toList(growable: false),
    );
  }
}

final class _HistoryValueRow extends StatelessWidget {
  final _HistoryValueItem item;

  const _HistoryValueRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextTheme.of(context);
    final colorTheme = AppColorTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.label,
          style: textTheme.bodySmall.copyWith(
            fontSize: 11,
            height: 16 / 11,
            color: colorTheme.darkHint,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          item.value,
          style: textTheme.bodyMedium.copyWith(
            fontSize: 14,
            height: 21 / 14,
            fontWeight: FontWeight.w500,
            color: colorTheme.onSurface,
          ),
        ),
      ],
    );
  }
}

final class _HistoryEmptyState extends StatelessWidget {
  final String message;

  const _HistoryEmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextTheme.of(context);
    final colorTheme = AppColorTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: textTheme.bodyMedium.copyWith(color: colorTheme.darkHint),
      ),
    );
  }
}

final class _HistoryValueItem {
  final String label;
  final String value;

  const _HistoryValueItem({
    required this.label,
    required this.value,
  });
}

String _formatDate(String rawValue) {
  if (rawValue.contains('.')) {
    return rawValue.split(' ').first;
  }

  final normalizedValue = rawValue.contains(' ') ? rawValue.replaceFirst(' ', 'T') : rawValue;
  final dateTime = DateTime.tryParse(normalizedValue);
  if (dateTime == null) return rawValue;

  final day = dateTime.day.toString().padLeft(2, '0');
  final month = dateTime.month.toString().padLeft(2, '0');
  final year = dateTime.year.toString().padLeft(4, '0');
  return '$day.$month.$year';
}
