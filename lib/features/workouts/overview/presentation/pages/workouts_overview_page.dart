import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/router/router_paths.dart';
import '../../../presentation/widgets/workout_card.dart';
import '../../../../../uikit/buttons/main_button.dart';
import '../../../../../uikit/inputs/app_search_field.dart';
import '../../../../../uikit/themes/colors/app_color_theme.dart';
import '../../../../../uikit/themes/text/app_text_theme.dart';
import '../../domain/entities/workout_overview_item.dart';
import '../cubits/workouts_overview_cubit.dart';

/// Authenticated workouts overview page.
class WorkoutsOverviewPage extends StatefulWidget {
  /// Creates an instance of [WorkoutsOverviewPage].
  const WorkoutsOverviewPage({super.key});

  @override
  State<WorkoutsOverviewPage> createState() => _WorkoutsOverviewPageState();
}

class _WorkoutsOverviewPageState extends State<WorkoutsOverviewPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_handleSearchChanged);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_handleSearchChanged)
      ..dispose();
    super.dispose();
  }

  void _handleSearchChanged() => setState(() {});

  List<WorkoutOverviewItem> _filterItems(List<WorkoutOverviewItem> items) {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return items;

    return items
        .where((item) {
          final title = item.title.toLowerCase();
          final description = item.description.toLowerCase();
          return title.contains(query) || description.contains(query);
        })
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextTheme.of(context);
    final colorTheme = AppColorTheme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.workoutsOverviewTitle,
          style: textTheme.appBarTitle,
        ),
      ),
      body: BlocBuilder<WorkoutsOverviewCubit, WorkoutsOverviewState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 14, 24, 132),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  AppStrings.workoutsOverviewDescriptionPrimary,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorTheme.hint,
                  ),
                ),
                Text(
                  AppStrings.workoutsOverviewDescriptionSecondary,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorTheme.hint,
                  ),
                ),
                const SizedBox(height: 32),
                AppSearchField(
                  controller: _searchController,
                  hintText: AppStrings.workoutsOverviewSearchHint,
                ),
                const SizedBox(height: 24),
                _buildStateSection(context, state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStateSection(BuildContext context, WorkoutsOverviewState state) {
    return state.when(
      initial: () => const SizedBox.shrink(),
      inProgress: _buildLoadingState,
      loaded: (items) => _buildLoadedState(
        fullItems: items,
        filteredItems: _filterItems(items),
      ),
      failed: (_) => _buildRetryState(context),
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

  Widget _buildLoadedState({
    required List<WorkoutOverviewItem> fullItems,
    required List<WorkoutOverviewItem> filteredItems,
  }) {
    if (fullItems.isEmpty) {
      return const Center(
        child: Text(
          AppStrings.workoutsEmpty,
          textAlign: TextAlign.center,
        ),
      );
    }

    if (filteredItems.isEmpty) {
      return const Center(
        child: Text(
          AppStrings.workoutsSearchEmpty,
          textAlign: TextAlign.center,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(filteredItems.length, (index) {
        final item = filteredItems[index];
        return Padding(
          padding: EdgeInsets.only(bottom: index == filteredItems.length - 1 ? 0 : 20),
          child: WorkoutCard(
            title: item.title,
            description: item.description,
            durationMinutes: item.durationMinutes,
            imageUrl: item.imageUrl,
            buttonLabel: AppStrings.workoutsOverviewOpenButton,
            onPressed: () => context.push(
              AppRoutePaths.workoutDetailsConcretePath(item.userWorkoutId),
            ),
          ),
        );
      }),
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
            AppStrings.workoutsLoadFailed,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium.copyWith(color: colorTheme.onSurface),
          ),
          const SizedBox(height: 24),
          MainButton(
            onPressed: context.read<WorkoutsOverviewCubit>().loadWorkouts,
            child: const Text(AppStrings.fitnessStartRetryButton),
          ),
        ],
      ),
    );
  }
}
