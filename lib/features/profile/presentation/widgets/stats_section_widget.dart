import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../uikit/buttons/button_state.dart';
import '../../../../../uikit/buttons/main_button.dart';
import '../../../../../uikit/buttons/option_button.dart';
import '../../../../../uikit/cards/app_card.dart';
import '../../../../../uikit/images/svg_picture_widget.dart';
import '../../../../../uikit/menus/app_selection_dropdown.dart';
import '../../../../../uikit/themes/colors/app_color_theme.dart';
import '../../../../../uikit/themes/text/app_text_theme.dart';
import '../../domain/entities/profile_statistics/frequency_period.dart';
import '../../domain/entities/profile_statistics/profile_exercise_option.dart';
import '../../domain/entities/profile_statistics/profile_statistics_mode.dart';
import '../../domain/entities/profile_statistics/profile_workout_option.dart';
import '../cubits/profile_statistics_cubit.dart';
import 'profile_statistics_bar_chart.dart';
import 'profile_statistics_trend_chart.dart';

enum _StatsDropdown {
  category,
  period,
}

/// The second profile section with user statistics and selectors.
class StatsSectionWidget extends StatefulWidget {
  /// Creates an instance of [StatsSectionWidget].
  const StatsSectionWidget({super.key});

  @override
  State<StatsSectionWidget> createState() => _StatsSectionWidgetState();
}

class _StatsSectionWidgetState extends State<StatsSectionWidget> {
  final _categoryLayerLink = LayerLink();
  final _periodLayerLink = LayerLink();
  final _dropdownTapRegionGroupId = Object();

  _StatsDropdown? _openDropdown;

  void _toggleDropdown(_StatsDropdown dropdown) {
    setState(() {
      _openDropdown = _openDropdown == dropdown ? null : dropdown;
    });
  }

  void _closeDropdown() {
    if (_openDropdown == null) return;
    setState(() => _openDropdown = null);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileStatisticsCubit, ProfileStatisticsState>(
      builder: (context, state) {
        final categoryItems = _buildCategoryItems(state);
        final isCategoryEnabled =
            state.mode != ProfileStatisticsMode.frequency && categoryItems.isNotEmpty;
        final showCategoryDropdown = _openDropdown == _StatsDropdown.category && isCategoryEnabled;
        final showPeriodDropdown =
            _openDropdown == _StatsDropdown.period && state.mode == ProfileStatisticsMode.frequency;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            TapRegion(
              groupId: _dropdownTapRegionGroupId,
              onTapOutside: (_) => _closeDropdown(),
              child: AppCard(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _StatsSummaryRow(state: state),
                    const SizedBox(height: 24),
                    _ModeButtons(
                      state: state,
                      onSelected: (mode) {
                        _closeDropdown();
                        context.read<ProfileStatisticsCubit>().selectMode(mode);
                      },
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TapRegion(
                        groupId: _dropdownTapRegionGroupId,
                        onTapOutside: (_) => _closeDropdown(),
                        child: CompositedTransformTarget(
                          link: _categoryLayerLink,
                          child: SizedBox(
                            width: 168,
                            child: _SelectionButton(
                              label: _resolveCategoryButtonLabel(state),
                              icon: Icons.keyboard_arrow_down_rounded,
                              onPressed: isCategoryEnabled
                                  ? () => _toggleDropdown(_StatsDropdown.category)
                                  : () {},
                              buttonState: isCategoryEnabled
                                  ? ButtonState.enabled
                                  : ButtonState.disabled,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      AppStrings.profileStatsTitle,
                      style: AppTextTheme.of(context).title.copyWith(
                        fontSize: 18,
                        height: 27 / 18,
                        fontWeight: FontWeight.w500,
                        color: AppColorTheme.of(context).onSurface,
                      ),
                    ),
                    if (state.mode != ProfileStatisticsMode.trend) ...[
                      const SizedBox(height: 20),
                      _PeriodControl(
                        state: state,
                        periodLayerLink: _periodLayerLink,
                        dropdownTapRegionGroupId: _dropdownTapRegionGroupId,
                        onToggleDropdown: () => _toggleDropdown(_StatsDropdown.period),
                        onPreviousPressed: () {
                          _closeDropdown();
                          context.read<ProfileStatisticsCubit>().loadPreviousPeriod();
                        },
                        onNextPressed: () {
                          _closeDropdown();
                          context.read<ProfileStatisticsCubit>().loadNextPeriod();
                        },
                        onTapOutside: _closeDropdown,
                      ),
                    ],
                    const SizedBox(height: 28),
                    if (state.isLoading && !_hasCurrentPayload(state))
                      const _StatsLoadingState()
                    else if (state.failure != null && !_hasCurrentPayload(state))
                      _StatsErrorState(
                        onRetryPressed: () {
                          _closeDropdown();
                          context.read<ProfileStatisticsCubit>().reload();
                        },
                      )
                    else
                      _StatsContent(state: state),
                  ],
                ),
              ),
            ),
            if (showCategoryDropdown)
              CompositedTransformFollower(
                link: _categoryLayerLink,
                showWhenUnlinked: false,
                targetAnchor: Alignment.bottomLeft,
                offset: const Offset(0, 8),
                child: TapRegion(
                  groupId: _dropdownTapRegionGroupId,
                  onTapOutside: (_) => _closeDropdown(),
                  child: AppSelectionDropdown<int>(
                    mode: AppSelectionDropdownMode.single,
                    constraints: const BoxConstraints(
                      maxHeight: 280,
                      minWidth: 188,
                      maxWidth: 240,
                    ),
                    items: categoryItems,
                    selectedValues: _selectedCategoryValues(state),
                    onChanged: (selectedValues) {
                      if (selectedValues.isEmpty) return;
                      final selectedValue = selectedValues.first;

                      _closeDropdown();
                      final cubit = context.read<ProfileStatisticsCubit>();
                      switch (state.mode) {
                        case ProfileStatisticsMode.volume:
                          cubit.selectExercise(selectedValue);
                        case ProfileStatisticsMode.frequency:
                          return;
                        case ProfileStatisticsMode.trend:
                          cubit.selectWorkout(selectedValue);
                      }
                    },
                  ),
                ),
              ),
            if (showPeriodDropdown)
              CompositedTransformFollower(
                link: _periodLayerLink,
                showWhenUnlinked: false,
                targetAnchor: Alignment.bottomLeft,
                offset: const Offset(0, 8),
                child: TapRegion(
                  groupId: _dropdownTapRegionGroupId,
                  onTapOutside: (_) => _closeDropdown(),
                  child: AppSelectionDropdown<FrequencyPeriod>(
                    mode: AppSelectionDropdownMode.single,
                    constraints: const BoxConstraints(
                      maxHeight: 280,
                      minWidth: 188,
                      maxWidth: 220,
                    ),
                    items: FrequencyPeriod.values
                        .map(
                          (period) => AppSelectionDropdownItem<FrequencyPeriod>(
                            value: period,
                            label: _frequencyPeriodLabel(period),
                          ),
                        )
                        .toList(growable: false),
                    selectedValues: {state.selectedFrequencyPeriod},
                    onChanged: (selectedValues) {
                      if (selectedValues.isEmpty) return;
                      final selectedValue = selectedValues.first;

                      _closeDropdown();
                      context.read<ProfileStatisticsCubit>().selectFrequencyPeriod(selectedValue);
                    },
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

final class _StatsSummaryRow extends StatelessWidget {
  final ProfileStatisticsState state;

  const _StatsSummaryRow({required this.state});

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextTheme.of(context);
    final colorTheme = AppColorTheme.of(context);
    final leftText = switch (state.mode) {
      ProfileStatisticsMode.volume =>
        state.volumeData?.title.isNotEmpty == true
            ? state.volumeData!.title
            : AppStrings.profileStatsExercisesButton,
      ProfileStatisticsMode.frequency =>
        state.frequencyData?.label.isNotEmpty == true
            ? state.frequencyData!.label
            : _frequencyPeriodLabel(state.selectedFrequencyPeriod),
      ProfileStatisticsMode.trend =>
        state.trendData?.title.isNotEmpty == true
            ? state.trendData!.title
            : AppStrings.profileStatsWorkoutsButton,
    };
    final subtitle = state.mode == ProfileStatisticsMode.trend
        ? state.trendData?.completedAtFormatted
        : null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                leftText,
                maxLines: 2,
                style: textTheme.bodyMedium.copyWith(
                  fontSize: 14,
                  height: 21 / 14,
                  fontWeight: FontWeight.w500,
                  color: colorTheme.onSurface,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (subtitle != null && subtitle.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  maxLines: 1,
                  style: textTheme.bodySmall.copyWith(
                    fontSize: 11,
                    height: 16 / 11,
                    color: colorTheme.darkHint,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 12),
        switch (state.mode) {
          ProfileStatisticsMode.frequency => _SummaryValueText(
            value: AppStrings.profileStatsAveragePerWeek(
              _formatAveragePerWeek(state.frequencyData?.averagePerWeek ?? 0),
            ),
          ),
          ProfileStatisticsMode.volume => _SummaryScore(
            percent: state.volumeData?.averageScorePercent ?? 0,
            scoreLabel: state.volumeData?.averageScoreLabel ?? '',
          ),
          ProfileStatisticsMode.trend => _SummaryScore(
            percent: state.trendData?.averageScorePercent ?? 0,
            scoreLabel: state.trendData?.averageScoreLabel ?? '',
          ),
        },
      ],
    );
  }
}

final class _ModeButtons extends StatelessWidget {
  final ProfileStatisticsState state;
  final ValueChanged<ProfileStatisticsMode> onSelected;

  const _ModeButtons({
    required this.state,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isLoading = state.isLoading;
    return Row(
      children: [
        Expanded(
          child: OptionButton(
            state: isLoading ? ButtonState.disabled : ButtonState.enabled,
            isSelected: state.mode == ProfileStatisticsMode.volume,
            onPressed: () => onSelected(ProfileStatisticsMode.volume),
            child: const Text(AppStrings.profileStatsVolumeMode),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OptionButton(
            state: isLoading ? ButtonState.disabled : ButtonState.enabled,
            isSelected: state.mode == ProfileStatisticsMode.frequency,
            onPressed: () => onSelected(ProfileStatisticsMode.frequency),
            child: const Text(AppStrings.profileStatsFrequencyMode),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OptionButton(
            state: isLoading ? ButtonState.disabled : ButtonState.enabled,
            isSelected: state.mode == ProfileStatisticsMode.trend,
            onPressed: () => onSelected(ProfileStatisticsMode.trend),
            child: const Text(AppStrings.profileStatsTrendMode),
          ),
        ),
      ],
    );
  }
}

final class _PeriodControl extends StatelessWidget {
  final ProfileStatisticsState state;
  final LayerLink periodLayerLink;
  final Object dropdownTapRegionGroupId;
  final VoidCallback onToggleDropdown;
  final VoidCallback onPreviousPressed;
  final VoidCallback onNextPressed;
  final VoidCallback onTapOutside;

  const _PeriodControl({
    required this.state,
    required this.periodLayerLink,
    required this.dropdownTapRegionGroupId,
    required this.onToggleDropdown,
    required this.onPreviousPressed,
    required this.onNextPressed,
    required this.onTapOutside,
  });

  @override
  Widget build(BuildContext context) {
    final canGoPrevious = switch (state.mode) {
      ProfileStatisticsMode.volume => state.volumeData?.period.canGoPrevious ?? false,
      ProfileStatisticsMode.frequency => true,
      ProfileStatisticsMode.trend => false,
    };
    final canGoNext = switch (state.mode) {
      ProfileStatisticsMode.volume => state.volumeData?.period.canGoNext ?? false,
      ProfileStatisticsMode.frequency => state.selectedFrequencyOffset > 0,
      ProfileStatisticsMode.trend => false,
    };
    final centerLabel = switch (state.mode) {
      ProfileStatisticsMode.volume => state.volumeData?.period.label ?? '',
      ProfileStatisticsMode.frequency => _frequencyPeriodLabel(state.selectedFrequencyPeriod),
      ProfileStatisticsMode.trend => '',
    };
    final isFrequency = state.mode == ProfileStatisticsMode.frequency;

    return Row(
      children: [
        _ArrowButton(
          icon: Icons.chevron_left_rounded,
          isEnabled: canGoPrevious && !state.isLoading,
          onPressed: onPreviousPressed,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: isFrequency
              ? TapRegion(
                  groupId: dropdownTapRegionGroupId,
                  onTapOutside: (_) => onTapOutside(),
                  child: CompositedTransformTarget(
                    link: periodLayerLink,
                    child: _SelectionButton(
                      label: centerLabel,
                      icon: Icons.keyboard_arrow_down_rounded,
                      onPressed: state.isLoading ? () {} : onToggleDropdown,
                      buttonState: state.isLoading ? ButtonState.disabled : ButtonState.enabled,
                    ),
                  ),
                )
              : _PeriodLabel(label: centerLabel),
        ),
        const SizedBox(width: 12),
        _ArrowButton(
          icon: Icons.chevron_right_rounded,
          isEnabled: canGoNext && !state.isLoading,
          onPressed: onNextPressed,
        ),
      ],
    );
  }
}

final class _StatsContent extends StatelessWidget {
  final ProfileStatisticsState state;

  const _StatsContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final content = switch (state.mode) {
      ProfileStatisticsMode.volume => _buildVolumeContent(),
      ProfileStatisticsMode.frequency => _buildFrequencyContent(),
      ProfileStatisticsMode.trend => _buildTrendContent(),
    };

    if (state.isLoading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox.square(
              dimension: 18,
              child: CircularProgressIndicator.adaptive(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColorTheme.of(context).primary),
              ),
            ),
          ),
          const SizedBox(height: 12),
          content,
        ],
      );
    }

    return content;
  }

  Widget _buildVolumeContent() {
    final data = state.volumeData;
    if (data == null || !data.hasData || data.chart.isEmpty) {
      return const _StatsEmptyState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionTitle(title: AppStrings.profileStatsVolumeChartTitle),
        const SizedBox(height: 20),
        ProfileStatisticsBarChart(
          items: data.chart
              .map(
                (item) => ProfileStatisticsBarChartItem(
                  label: item.label,
                  value: item.value,
                ),
              )
              .toList(growable: false),
        ),
      ],
    );
  }

  Widget _buildFrequencyContent() {
    final data = state.frequencyData;
    if (data == null || !data.hasData || data.chart.isEmpty) {
      return const _StatsEmptyState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionTitle(title: AppStrings.profileStatsFrequencyChartTitle),
        const SizedBox(height: 20),
        ProfileStatisticsBarChart(
          items: data.chart
              .map(
                (item) => ProfileStatisticsBarChartItem(
                  label: item.shortLabel,
                  value: item.count.toDouble(),
                ),
              )
              .toList(growable: false),
        ),
      ],
    );
  }

  Widget _buildTrendContent() {
    final data = state.trendData;
    if (data == null || !data.hasData || data.exercises.isEmpty) {
      return const _StatsEmptyState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionTitle(title: AppStrings.profileStatsTrendChartTitle),
        const SizedBox(height: 20),
        ProfileStatisticsTrendChart(exercises: data.exercises),
      ],
    );
  }
}

final class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextTheme.of(context);
    final colorTheme = AppColorTheme.of(context);
    return Text(
      title,
      style: textTheme.bodyMedium.copyWith(
        fontSize: 14,
        height: 21 / 14,
        fontWeight: FontWeight.w500,
        color: colorTheme.onSurface,
      ),
    );
  }
}

final class _StatsLoadingState extends StatelessWidget {
  const _StatsLoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox.square(
        dimension: 24,
        child: CircularProgressIndicator.adaptive(strokeWidth: 2),
      ),
    );
  }
}

final class _StatsEmptyState extends StatelessWidget {
  const _StatsEmptyState();

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextTheme.of(context);
    final colorTheme = AppColorTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        AppStrings.profileStatsEmpty,
        textAlign: TextAlign.center,
        style: textTheme.bodyMedium.copyWith(
          color: colorTheme.darkHint,
        ),
      ),
    );
  }
}

final class _StatsErrorState extends StatelessWidget {
  final VoidCallback onRetryPressed;

  const _StatsErrorState({required this.onRetryPressed});

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextTheme.of(context);
    final colorTheme = AppColorTheme.of(context);
    return Column(
      children: [
        Text(
          AppStrings.profileStatsLoadFailed,
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

final class _SummaryValueText extends StatelessWidget {
  final String value;

  const _SummaryValueText({required this.value});

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextTheme.of(context);
    final colorTheme = AppColorTheme.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 132),
      child: Text(
        value,
        textAlign: TextAlign.right,
        style: textTheme.bodyMedium.copyWith(
          fontSize: 13,
          height: 19 / 13,
          fontWeight: FontWeight.w500,
          color: colorTheme.onSurface,
        ),
      ),
    );
  }
}

final class _SummaryScore extends StatelessWidget {
  final int percent;
  final String scoreLabel;

  const _SummaryScore({
    required this.percent,
    required this.scoreLabel,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextTheme.of(context);
    final colorTheme = AppColorTheme.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 148),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPictureWidget.icon(
            _resolveFaceAsset(scoreLabel),
            width: 24,
            height: 24,
            color: colorTheme.darkHint,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              AppStrings.profileStatsAverageScore(percent),
              textAlign: TextAlign.right,
              style: textTheme.bodyMedium.copyWith(
                fontSize: 13,
                height: 19 / 13,
                fontWeight: FontWeight.w500,
                color: colorTheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final class _SelectionButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  final ButtonState buttonState;

  const _SelectionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.buttonState,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    return OptionButton(
      state: buttonState,
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (icon != null) ...[
            const SizedBox(width: 8),
            Icon(icon, size: 18, color: colorTheme.hint),
          ],
        ],
      ),
    );
  }
}

final class _PeriodLabel extends StatelessWidget {
  final String label;

  const _PeriodLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextTheme.of(context);
    final colorTheme = AppColorTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colorTheme.outline),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium.copyWith(
            fontSize: 14,
            height: 21 / 14,
            color: colorTheme.onSurface,
          ),
        ),
      ),
    );
  }
}

final class _ArrowButton extends StatelessWidget {
  final IconData icon;
  final bool isEnabled;
  final VoidCallback onPressed;

  const _ArrowButton({
    required this.icon,
    required this.isEnabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    return SizedBox(
      width: 44,
      height: 44,
      child: OutlinedButton(
        onPressed: isEnabled ? onPressed : null,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          side: BorderSide(color: isEnabled ? colorTheme.outline : colorTheme.disabled),
        ),
        child: Icon(
          icon,
          size: 22,
          color: isEnabled ? colorTheme.onSurface : colorTheme.disabled,
        ),
      ),
    );
  }
}

List<AppSelectionDropdownItem<int>> _buildCategoryItems(ProfileStatisticsState state) {
  switch (state.mode) {
    case ProfileStatisticsMode.volume:
      return state.exerciseOptions
          .map(
            (option) => AppSelectionDropdownItem<int>(
              value: option.id,
              label: option.name,
            ),
          )
          .toList(growable: false);
    case ProfileStatisticsMode.frequency:
      return const <AppSelectionDropdownItem<int>>[];
    case ProfileStatisticsMode.trend:
      return state.workoutOptions
          .map(
            (option) => AppSelectionDropdownItem<int>(
              value: option.id,
              label: option.title,
            ),
          )
          .toList(growable: false);
  }
}

Set<int> _selectedCategoryValues(ProfileStatisticsState state) {
  final selectedValue = switch (state.mode) {
    ProfileStatisticsMode.volume => state.selectedExerciseId,
    ProfileStatisticsMode.frequency => null,
    ProfileStatisticsMode.trend => state.selectedWorkoutId,
  };

  if (selectedValue == null) return <int>{};
  return {selectedValue};
}

String _resolveCategoryButtonLabel(ProfileStatisticsState state) {
  switch (state.mode) {
    case ProfileStatisticsMode.volume:
      final selectedId = state.selectedExerciseId;
      final selectedOption = _findExerciseOptionLabel(
        state,
        selectedId,
      );
      return selectedOption?.name ?? AppStrings.profileStatsCategoriesButton;
    case ProfileStatisticsMode.frequency:
      return AppStrings.profileStatsCategoriesButton;
    case ProfileStatisticsMode.trend:
      final selectedId = state.selectedWorkoutId;
      final selectedOption = _findWorkoutOptionLabel(
        state,
        selectedId,
      );
      return selectedOption?.title ?? AppStrings.profileStatsWorkoutsButton;
  }
}

bool _hasCurrentPayload(ProfileStatisticsState state) {
  return switch (state.mode) {
    ProfileStatisticsMode.volume => state.volumeData != null,
    ProfileStatisticsMode.frequency => state.frequencyData != null,
    ProfileStatisticsMode.trend => state.trendData != null,
  };
}

String _frequencyPeriodLabel(FrequencyPeriod period) {
  return switch (period) {
    FrequencyPeriod.week => 'Неделя',
    FrequencyPeriod.month => 'Месяц',
    FrequencyPeriod.threeMonths => '3 месяца',
    FrequencyPeriod.sixMonths => '6 месяцев',
    FrequencyPeriod.year => 'Год',
  };
}

String _formatAveragePerWeek(double value) {
  final roundedValue = value % 1 == 0 ? value.toStringAsFixed(0) : value.toStringAsFixed(1);
  return roundedValue.replaceFirst('.', ',');
}

String _resolveFaceAsset(String rawValue) {
  final normalizedValue = rawValue.trim().toLowerCase();
  if (normalizedValue.contains('bad') || normalizedValue.contains('плох')) {
    return AppAssets.iconBadFace;
  }
  if (normalizedValue.contains('good') ||
      normalizedValue.contains('хорош') ||
      normalizedValue.contains('отлич')) {
    return AppAssets.iconGoodFace;
  }
  return AppAssets.iconNormalFace;
}

ProfileExerciseOption? _findExerciseOptionLabel(ProfileStatisticsState state, int? selectedId) {
  for (final option in state.exerciseOptions) {
    if (option.id == selectedId) return option;
  }
  return null;
}

ProfileWorkoutOption? _findWorkoutOptionLabel(ProfileStatisticsState state, int? selectedId) {
  for (final option in state.workoutOptions) {
    if (option.id == selectedId) return option;
  }
  return null;
}
