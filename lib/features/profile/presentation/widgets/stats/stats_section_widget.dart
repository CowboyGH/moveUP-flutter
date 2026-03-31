import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/constants/app_assets.dart';
import '../../../../../../core/constants/app_strings.dart';
import '../../../../../../uikit/buttons/button_state.dart';
import '../../../../../../uikit/buttons/main_button.dart';
import '../../../../../../uikit/buttons/option_button.dart';
import '../../../../../../uikit/cards/app_card.dart';
import '../../../../../../uikit/images/svg_picture_widget.dart';
import '../../../../../../uikit/menus/app_selection_dropdown.dart';
import '../../../../../../uikit/themes/colors/app_color_theme.dart';
import '../../../../../../uikit/themes/text/app_text_theme.dart';
import '../../../../../uikit/buttons/button_size.dart';
import '../../../domain/entities/profile_statistics/frequency_period.dart';
import '../../../domain/entities/profile_statistics/frequency_statistics_data.dart';
import '../../../domain/entities/profile_statistics/profile_exercise_option.dart';
import '../../../domain/entities/profile_statistics/profile_statistics_mode.dart';
import '../../../domain/entities/profile_statistics/profile_workout_option.dart';
import '../../cubits/profile_statistics_cubit.dart';
import '../profile_statistics_trend_chart.dart';
import 'profile_statistics_bar_chart.dart';

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
  final _dropdownOverlayController = OverlayPortalController();

  _StatsDropdown? _openDropdown;

  void _toggleDropdown(_StatsDropdown dropdown) {
    setState(() {
      _openDropdown = _openDropdown == dropdown ? null : dropdown;
    });
    if (_openDropdown == null) {
      _dropdownOverlayController.hide();
      return;
    }
    _dropdownOverlayController.show();
  }

  void _closeDropdown() {
    if (_openDropdown == null) return;
    setState(() => _openDropdown = null);
    _dropdownOverlayController.hide();
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

        return OverlayPortal(
          controller: _dropdownOverlayController,
          overlayChildBuilder: (context) => Stack(
            clipBehavior: Clip.none,
            children: [
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
                        maxHeight: 200,
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
          ),
          child: TapRegion(
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
                  const SizedBox(height: 20),
                  Text(
                    AppStrings.profileStatsTitle,
                    style: AppTextTheme.of(context).title.copyWith(
                      fontSize: 16,
                      height: 24 / 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  if (state.mode != ProfileStatisticsMode.trend) ...[
                    const SizedBox(height: 12),
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
                  const SizedBox(height: 24),
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
                style: textTheme.body.copyWith(
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
        SizedBox(
          height: subtitle != null && subtitle.isNotEmpty ? 36 : 24,
          child: VerticalDivider(
            width: 1,
            thickness: 1,
            color: colorTheme.onSurface,
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
            size: ButtonSize.small,
            state: isLoading ? ButtonState.disabled : ButtonState.enabled,
            isSelected: state.mode == ProfileStatisticsMode.volume,
            onPressed: () => onSelected(ProfileStatisticsMode.volume),
            child: const Text(AppStrings.profileStatsVolumeMode),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OptionButton(
            size: ButtonSize.small,
            state: isLoading ? ButtonState.disabled : ButtonState.enabled,
            isSelected: state.mode == ProfileStatisticsMode.frequency,
            onPressed: () => onSelected(ProfileStatisticsMode.frequency),
            child: const Text(AppStrings.profileStatsFrequencyMode),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OptionButton(
            size: ButtonSize.small,
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
    final isFrequency = state.mode == ProfileStatisticsMode.frequency;
    final periodPresentation = _resolvePeriodPresentation(state);

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
                    child: _PeriodLabel(
                      title: periodPresentation.title,
                      dateRange: periodPresentation.dateRange,
                      year: periodPresentation.year,
                      onPressed: state.isLoading ? null : onToggleDropdown,
                    ),
                  ),
                )
              : _PeriodLabel(
                  title: periodPresentation.title,
                  dateRange: periodPresentation.dateRange,
                  year: periodPresentation.year,
                ),
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

    final chartItems = _buildFrequencyChartItems(data);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionTitle(title: AppStrings.profileStatsFrequencyChartTitle),
        const SizedBox(height: 20),
        ProfileStatisticsBarChart(items: chartItems),
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

  List<ProfileStatisticsBarChartItem> _buildFrequencyChartItems(
    FrequencyStatisticsData data,
  ) {
    return switch (data.period) {
      FrequencyPeriod.week =>
        data.chart
            .map(
              (item) => ProfileStatisticsBarChartItem(
                label: item.label,
                value: item.count.toDouble(),
              ),
            )
            .toList(growable: false),
      FrequencyPeriod.month || FrequencyPeriod.threeMonths =>
        data.chart
            .map(
              (item) => ProfileStatisticsBarChartItem(
                label: item.shortLabel,
                value: item.count.toDouble(),
              ),
            )
            .toList(growable: false),
      FrequencyPeriod.sixMonths => _buildMonthlyFrequencyChartItems(
        data.chart,
        targetCount: 6,
      ),
      FrequencyPeriod.year => _buildMonthlyFrequencyChartItems(
        data.chart,
        targetCount: 12,
      ),
    };
  }

  List<ProfileStatisticsBarChartItem> _buildMonthlyFrequencyChartItems(
    List<FrequencyChartBarData> chart, {
    required int targetCount,
  }) {
    final buckets = <String, _FrequencyMonthBucket>{};

    for (final item in chart) {
      final date = _parseFrequencyBucketDate(item);
      if (date == null) {
        final bucketKey = '${buckets.length}';
        final existingBucket = buckets[bucketKey];
        if (existingBucket != null) {
          buckets[bucketKey] = existingBucket.copyWith(
            value: existingBucket.value + item.count.toDouble(),
          );
          continue;
        }

        buckets[bucketKey] = _FrequencyMonthBucket(
          label: item.shortLabel,
          value: item.count.toDouble(),
          sortKey: DateTime(1970),
        );
        continue;
      }

      final bucketKey = '${date.year}-${date.month.toString().padLeft(2, '0')}';
      final existingBucket = buckets[bucketKey];
      if (existingBucket != null) {
        buckets[bucketKey] = existingBucket.copyWith(
          value: existingBucket.value + item.count.toDouble(),
        );
        continue;
      }

      buckets[bucketKey] = _FrequencyMonthBucket(
        label: date.month.toString(),
        value: item.count.toDouble(),
        sortKey: DateTime(date.year, date.month),
      );
    }

    final sortedBuckets = buckets.values.toList(growable: false)
      ..sort((left, right) => left.sortKey.compareTo(right.sortKey));
    final visibleBuckets = sortedBuckets.length > targetCount
        ? sortedBuckets.sublist(sortedBuckets.length - targetCount)
        : sortedBuckets;

    return visibleBuckets.indexed
        .map(
          (entry) => ProfileStatisticsBarChartItem(
            label: '${entry.$1 + 1}',
            value: entry.$2.value,
          ),
        )
        .toList(growable: false);
  }

  DateTime? _parseFrequencyBucketDate(FrequencyChartBarData item) {
    final rawValue = item.startDate ?? item.endDate;
    if (rawValue == null || rawValue.isEmpty) return null;

    return DateTime.tryParse(rawValue);
  }
}

final class _FrequencyMonthBucket {
  final String label;
  final double value;
  final DateTime sortKey;

  const _FrequencyMonthBucket({
    required this.label,
    required this.value,
    required this.sortKey,
  });

  _FrequencyMonthBucket copyWith({
    String? label,
    double? value,
    DateTime? sortKey,
  }) {
    return _FrequencyMonthBucket(
      label: label ?? this.label,
      value: value ?? this.value,
      sortKey: sortKey ?? this.sortKey,
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
      style: textTheme.label.copyWith(
        color: colorTheme.darkHint,
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
    return Text(
      value,
      textAlign: TextAlign.right,
      style: textTheme.body,
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
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppStrings.profileStatsAverageScoreLabel,
          style: textTheme.body,
        ),
        const SizedBox(width: 8),
        SvgPictureWidget.icon(
          _resolveFaceAsset(scoreLabel),
          height: 18,
          color: colorTheme.hint,
        ),
        const SizedBox(width: 4),
        Text(
          '$percent%',
          style: textTheme.body,
        ),
      ],
    );
  }
}

final class _SelectionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final ButtonState buttonState;

  const _SelectionButton({
    required this.label,
    required this.onPressed,
    required this.buttonState,
  });

  @override
  Widget build(BuildContext context) {
    return OptionButton(
      size: ButtonSize.small,
      state: buttonState,
      onPressed: onPressed,
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

final class _PeriodLabel extends StatelessWidget {
  final String title;
  final String dateRange;
  final String year;
  final VoidCallback? onPressed;

  const _PeriodLabel({
    required this.title,
    required this.dateRange,
    required this.year,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextTheme.of(context);
    final colorTheme = AppColorTheme.of(context);
    final content = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorTheme.outline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.body.copyWith(color: colorTheme.onSurface),
              ),
              const SizedBox(width: 8),
              Text(
                dateRange,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.body.copyWith(color: colorTheme.onSurface),
              ),
              const SizedBox(width: 4),
              SizedBox(
                height: 12,
                child: VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: colorTheme.outline,
                ),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  year,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.body.copyWith(color: colorTheme.onSurface),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (onPressed == null) return content;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: content,
      ),
    );
  }
}

final class _ResolvedPeriodPresentation {
  final String title;
  final String dateRange;
  final String year;

  const _ResolvedPeriodPresentation({
    required this.title,
    required this.dateRange,
    required this.year,
  });
}

_ResolvedPeriodPresentation _resolvePeriodPresentation(ProfileStatisticsState state) {
  return switch (state.mode) {
    ProfileStatisticsMode.volume => _resolveVolumePeriodPresentation(state),
    ProfileStatisticsMode.frequency => _resolveFrequencyPeriodPresentation(state),
    ProfileStatisticsMode.trend => const _ResolvedPeriodPresentation(
      title: '',
      dateRange: '',
      year: '',
    ),
  };
}

_ResolvedPeriodPresentation _resolveVolumePeriodPresentation(ProfileStatisticsState state) {
  final period = state.volumeData?.period;
  final fallbackRange = _resolveFrequencyRange(
    FrequencyPeriod.week,
    period?.weekOffset ?? 0,
  );

  return _ResolvedPeriodPresentation(
    title: _resolveVolumePeriodTitle(period?.label),
    dateRange: _formatPeriodDateRange(
      period?.start.isNotEmpty == true ? period!.start : fallbackRange.start,
      period?.end.isNotEmpty == true ? period!.end : fallbackRange.end,
    ),
    year: _formatPeriodYear(
      period?.start.isNotEmpty == true ? period!.start : fallbackRange.start,
      period?.end.isNotEmpty == true ? period!.end : fallbackRange.end,
    ),
  );
}

_ResolvedPeriodPresentation _resolveFrequencyPeriodPresentation(ProfileStatisticsState state) {
  final period = state.frequencyData?.period ?? state.selectedFrequencyPeriod;
  final offset = state.frequencyData?.offset ?? state.selectedFrequencyOffset;
  final range = _resolveFrequencyRange(period, offset);

  return _ResolvedPeriodPresentation(
    title: _frequencyPeriodLabel(period),
    dateRange: _formatPeriodDateRange(range.start, range.end),
    year: _formatPeriodYear(range.start, range.end),
  );
}

String _resolveVolumePeriodTitle(String? label) {
  if (label == null || label.isEmpty) return _frequencyPeriodLabel(FrequencyPeriod.week);
  return label.replaceFirst(RegExp(r'\s+\d+$'), '');
}

({DateTime start, DateTime end}) _resolveFrequencyRange(FrequencyPeriod period, int offset) {
  final now = DateTime.now();
  final currentDate = DateTime(now.year, now.month, now.day);

  return switch (period) {
    FrequencyPeriod.week => _resolveWeekRange(currentDate, offset),
    FrequencyPeriod.month => _resolveMonthRange(currentDate, offset),
    FrequencyPeriod.threeMonths => _resolveMultiMonthRange(
      currentDate,
      offset,
      monthSpan: 3,
    ),
    FrequencyPeriod.sixMonths => _resolveMultiMonthRange(
      currentDate,
      offset,
      monthSpan: 6,
    ),
    FrequencyPeriod.year => _resolveYearRange(currentDate, offset),
  };
}

({DateTime start, DateTime end}) _resolveWeekRange(DateTime currentDate, int offset) {
  final currentWeekStart = currentDate.subtract(Duration(days: currentDate.weekday - 1));
  final start = currentWeekStart.subtract(Duration(days: offset * 7));
  final end = start.add(const Duration(days: 6));
  return (start: start, end: end);
}

({DateTime start, DateTime end}) _resolveMonthRange(DateTime currentDate, int offset) {
  final start = DateTime(currentDate.year, currentDate.month - offset);
  final end = DateTime(start.year, start.month + 1, 0);
  return (start: start, end: end);
}

({DateTime start, DateTime end}) _resolveMultiMonthRange(
  DateTime currentDate,
  int offset, {
  required int monthSpan,
}) {
  final endMonthStart = DateTime(currentDate.year, currentDate.month - (offset * monthSpan));
  final start = DateTime(endMonthStart.year, endMonthStart.month - (monthSpan - 1));
  final end = DateTime(endMonthStart.year, endMonthStart.month + 1, 0);
  return (start: start, end: end);
}

({DateTime start, DateTime end}) _resolveYearRange(DateTime currentDate, int offset) {
  final year = currentDate.year - offset;
  return (
    start: DateTime(year),
    end: DateTime(year, 12, 31),
  );
}

String _formatPeriodDateRange(Object startValue, Object endValue) {
  final start = _parseStatsDate(startValue);
  final end = _parseStatsDate(endValue);
  if (start == null || end == null) return '';

  return '${_formatPeriodDate(start)} - ${_formatPeriodDate(end)}';
}

String _formatPeriodYear(Object startValue, Object endValue) {
  final start = _parseStatsDate(startValue);
  final end = _parseStatsDate(endValue);
  if (start == null || end == null) return '';
  if (start.year == end.year) return start.year.toString();
  return '${_formatShortYear(start.year)}-${_formatShortYear(end.year)}';
}

DateTime? _parseStatsDate(Object rawValue) {
  if (rawValue is DateTime) return rawValue;
  if (rawValue is! String || rawValue.isEmpty) return null;

  final normalizedValue = rawValue.contains(' ') ? rawValue.replaceFirst(' ', 'T') : rawValue;
  return DateTime.tryParse(normalizedValue);
}

String _formatPeriodDate(DateTime dateTime) {
  final day = dateTime.day.toString().padLeft(2, '0');
  final month = dateTime.month.toString().padLeft(2, '0');
  return '$day.$month';
}

String _formatShortYear(int year) {
  return (year % 100).toString().padLeft(2, '0');
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
      width: 38,
      height: 38,
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
