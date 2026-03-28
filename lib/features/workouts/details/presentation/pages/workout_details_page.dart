import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/router/router_paths.dart';
import '../../../../../uikit/buttons/app_back_button.dart';
import '../../../../../uikit/buttons/main_button.dart';
import '../../../../../uikit/images/app_decorative_figure.dart';
import '../../../../../uikit/themes/colors/app_color_theme.dart';
import '../../../../../uikit/themes/text/app_text_theme.dart';
import '../../../execution/domain/entities/workout_execution_entry_mode.dart';
import '../../../presentation/widgets/workout_card.dart';
import '../../domain/entities/workout_details_item.dart';
import '../cubits/workout_details_cubit.dart';

/// Workout details page shown after selecting a workout from overview.
class WorkoutDetailsPage extends StatefulWidget {
  /// User workout identifier for retry actions.
  final int userWorkoutId;

  /// Creates an instance of [WorkoutDetailsPage].
  const WorkoutDetailsPage({
    required this.userWorkoutId,
    super.key,
  });

  @override
  State<WorkoutDetailsPage> createState() => _WorkoutDetailsPageState();
}

class _WorkoutDetailsPageState extends State<WorkoutDetailsPage> {
  bool _shouldRefreshOverviewOnExit = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextTheme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: AppBackButton(onPressed: () => _handleBack(context)),
        title: Text(
          AppStrings.workoutDetailsTitle,
          style: textTheme.appBarTitle,
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            right: -90,
            bottom: -30,
            child: Transform.rotate(
              angle: 14 * (math.pi / 180),
              child: const AppDecorativeFigure(tone: FigureTone.primary),
            ),
          ),
          BlocBuilder<WorkoutDetailsCubit, WorkoutDetailsState>(
            builder: (context, state) {
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 132),
                child: _buildStateSection(context, state),
              );
            },
          ),
        ],
      ),
    );
  }

  void _handleBack(BuildContext context) {
    if (Navigator.canPop(context)) {
      if (_shouldRefreshOverviewOnExit) {
        context.pop(false);
        return;
      }
      context.pop();
      return;
    }
    context.go(AppRoutePaths.workoutsPath);
  }

  Widget _buildStateSection(BuildContext context, WorkoutDetailsState state) {
    return state.when(
      initial: () => const SizedBox.shrink(),
      inProgress: _buildLoadingState,
      loaded: (items) => _buildLoadedState(context, items),
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

  Widget _buildLoadedState(BuildContext context, List<WorkoutDetailsItem> items) {
    if (items.isEmpty) {
      return const Center(
        child: Text(
          AppStrings.workoutsEmpty,
          textAlign: TextAlign.center,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(items.length, (index) {
        final item = items[index];
        return Padding(
          padding: EdgeInsets.only(bottom: index == items.length - 1 ? 0 : 24),
          child: WorkoutCard(
            title: item.title,
            description: item.description,
            durationMinutes: item.durationMinutes,
            imageUrl: item.imageUrl,
            buttonLabel: switch (item.type) {
              WorkoutDetailsItemType.warmup => AppStrings.workoutDetailsStartWarmupButton,
              WorkoutDetailsItemType.workout => AppStrings.workoutDetailsStartWorkoutButton,
            },
            onPressed: () => _openExecution(context, item.type),
          ),
        );
      }),
    );
  }

  Future<void> _openExecution(
    BuildContext context,
    WorkoutDetailsItemType itemType,
  ) async {
    final didChange = await context.push<bool>(
      AppRoutePaths.workoutExecutionConcretePath(widget.userWorkoutId),
      extra: switch (itemType) {
        WorkoutDetailsItemType.warmup => WorkoutExecutionEntryMode.warmup,
        WorkoutDetailsItemType.workout => WorkoutExecutionEntryMode.workout,
      },
    );
    if (!context.mounted || didChange == null) return;
    if (didChange) {
      context.pop(true);
      return;
    }
    setState(() => _shouldRefreshOverviewOnExit = true);
  }

  Widget _buildRetryState(BuildContext context) {
    final textTheme = AppTextTheme.of(context);
    final colorTheme = AppColorTheme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppStrings.workoutDetailsLoadFailed,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium.copyWith(color: colorTheme.onSurface),
          ),
          const SizedBox(height: 24),
          MainButton(
            onPressed: () => context
                .read<WorkoutDetailsCubit>()
                .loadWorkoutDetails(widget.userWorkoutId),
            child: const Text(AppStrings.fitnessStartRetryButton),
          ),
        ],
      ),
    );
  }
}
