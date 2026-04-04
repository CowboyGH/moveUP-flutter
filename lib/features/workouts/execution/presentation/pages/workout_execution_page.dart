import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/router/router_paths.dart';
import '../../../../../uikit/buttons/app_back_button.dart';
import '../../../../../uikit/buttons/button_state.dart';
import '../../../../../uikit/buttons/main_button.dart';
import '../../../../../uikit/buttons/secondary_button.dart';
import '../../../../../uikit/dialogs/app_action_dialog.dart';
import '../../../../../uikit/dialogs/app_feedback_dialog.dart';
import '../../../../../uikit/images/app_decorative_figure.dart';
import '../../../../../uikit/images/network_image_widget.dart';
import '../../../../../uikit/themes/colors/app_color_theme.dart';
import '../../../../../uikit/themes/text/app_text_theme.dart';
import '../../domain/entities/workout_execution_entry_mode.dart';
import '../../domain/entities/workout_execution_result.dart';
import '../../domain/entities/workout_execution_step.dart';
import '../../domain/entities/workout_exercise_reaction.dart';
import '../cubits/workout_execution_cubit.dart';
import '../widgets/workout_close_button.dart';
import '../widgets/workout_reaction_picker.dart';
import '../widgets/workout_weight_input_dialog.dart';

/// Fullscreen workout execution page for warmups and exercises.
class WorkoutExecutionPage extends StatefulWidget {
  /// User workout identifier used for retry and fallback navigation.
  final int userWorkoutId;

  /// Execution entry mode selected on the details screen.
  final WorkoutExecutionEntryMode entryMode;

  /// Creates an instance of [WorkoutExecutionPage].
  const WorkoutExecutionPage({
    required this.userWorkoutId,
    required this.entryMode,
    super.key,
  });

  @override
  State<WorkoutExecutionPage> createState() => _WorkoutExecutionPageState();
}

class _WorkoutExecutionPageState extends State<WorkoutExecutionPage> {
  static const _initialRestSeconds = 90;

  Timer? _restTimer;
  int _remainingRestSeconds = _initialRestSeconds;
  int? _activeExerciseId;
  WorkoutExerciseReaction? _selectedReaction;
  bool _isExitDialogOpen = false;

  @override
  void dispose() {
    _restTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextTheme.of(context);
    final state = context.watch<WorkoutExecutionCubit>().state;
    final currentStep = state.currentStep;
    final isWarmupScreen = switch (currentStep) {
      WorkoutWarmupStep() => true,
      WorkoutExerciseStep() => false,
      null => widget.entryMode == WorkoutExecutionEntryMode.warmup,
    };

    return Scaffold(
      appBar: AppBar(
        leading: isWarmupScreen
            ? AppBackButton(
                onPressed: _canHandleUserAction(state)
                    ? () => context.read<WorkoutExecutionCubit>().abandonWorkout()
                    : null,
              )
            : WorkoutCloseButton(
                onPressed: _canHandleUserAction(state) ? () => _showExitDialog(context) : null,
              ),
        title: Text(
          isWarmupScreen
              ? AppStrings.workoutExecutionWarmupTitle
              : AppStrings.workoutExecutionTitle,
          style: textTheme.appBarTitle,
        ),
      ),
      body: BlocConsumer<WorkoutExecutionCubit, WorkoutExecutionState>(
        listenWhen: (previous, current) {
          final previousStepKey = _stepKey(previous.currentStep);
          final currentStepKey = _stepKey(current.currentStep);
          return previousStepKey != currentStepKey ||
              previous.failure != current.failure ||
              previous.isCompleted != current.isCompleted ||
              previous.shouldPopToDetails != current.shouldPopToDetails;
        },
        listener: _handleStateChanged,
        builder: (context, state) {
          return Stack(
            children: [
              Positioned(
                left: -140,
                top: 25,
                child: Transform.scale(
                  scaleY: -1,
                  child: Transform.rotate(
                    angle: -162 * (math.pi / 180),
                    child: const AppDecorativeFigure(tone: FigureTone.primary),
                  ),
                ),
              ),
              const Positioned(
                right: -75,
                bottom: -115,
                child: AppDecorativeFigure(tone: FigureTone.secondary),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 14, 24, 28),
                child: _buildStateSection(context, state),
              ),
            ],
          );
        },
      ),
    );
  }

  bool _canHandleUserAction(WorkoutExecutionState state) {
    return !state.isStarting &&
        !state.isAdvancingWarmup &&
        !state.isSubmittingResult &&
        !state.isCompleting &&
        !state.isAbandoning;
  }

  Widget _buildStateSection(BuildContext context, WorkoutExecutionState state) {
    if (state.isStarting && state.currentStep == null) {
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

    final currentStep = state.currentStep;
    if (currentStep == null) {
      return _buildRetryState(context);
    }

    return switch (currentStep) {
      WorkoutWarmupStep() => _buildWarmupContent(context, state, currentStep),
      WorkoutExerciseStep() => _buildWorkoutContent(context, state, currentStep),
    };
  }

  Widget _buildRetryState(BuildContext context) {
    final textTheme = AppTextTheme.of(context);
    final colorTheme = AppColorTheme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppStrings.workoutExecutionLoadFailed,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium.copyWith(color: colorTheme.onSurface),
          ),
          const SizedBox(height: 24),
          MainButton(
            onPressed: () => context.read<WorkoutExecutionCubit>().startExecution(
              widget.userWorkoutId,
              widget.entryMode,
            ),
            child: const Text(AppStrings.fitnessStartRetryButton),
          ),
        ],
      ),
    );
  }

  Widget _buildWarmupContent(
    BuildContext context,
    WorkoutExecutionState state,
    WorkoutWarmupStep step,
  ) {
    final textTheme = AppTextTheme.of(context);
    final colorTheme = AppColorTheme.of(context);
    final buttonState = state.isAdvancingWarmup || state.isAbandoning
        ? ButtonState.disabled
        : ButtonState.enabled;
    final description = step.durationSeconds > 0
        ? '${step.description}\n${step.durationSeconds} сек.'
        : step.description;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          step.name,
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
            color: colorTheme.onSurface,
          ),
        ),
        const SizedBox(height: 20),
        _StepImage(imageUrl: step.imageUrl),
        const SizedBox(height: 12),
        Text(
          description,
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium.copyWith(color: colorTheme.onSurface),
        ),
        const SizedBox(height: 24),
        MainButton(
          state: buttonState,
          onPressed: context.read<WorkoutExecutionCubit>().nextWarmup,
          child: Text(
            step.isLast
                ? AppStrings.workoutExecutionFinishWarmupButton
                : AppStrings.workoutExecutionNextWarmupButton,
          ),
        ),
        if (!step.isLast) ...[
          const SizedBox(height: 8),
          SecondaryButton(
            state: buttonState,
            onPressed: context.read<WorkoutExecutionCubit>().skipWarmup,
            child: const Text(AppStrings.workoutExecutionFinishWarmupButton),
          ),
        ],
      ],
    );
  }

  Widget _buildWorkoutContent(
    BuildContext context,
    WorkoutExecutionState state,
    WorkoutExerciseStep step,
  ) {
    final textTheme = AppTextTheme.of(context);
    final colorTheme = AppColorTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          children: [
            Text(
              AppStrings.workoutExecutionRestPrefix,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium.copyWith(color: colorTheme.onSurface),
            ),
            Text(
              _formatRestTime(_remainingRestSeconds),
              style: textTheme.bodyMedium.copyWith(
                fontSize: 16,
                height: 24 / 16,
                fontWeight: FontWeight.w500,
                color: colorTheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          step.title,
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
            color: colorTheme.onSurface,
          ),
        ),
        const SizedBox(height: 20),
        _StepImage(imageUrl: step.imageUrl),
        const SizedBox(height: 12),
        Text(
          _buildExerciseInstruction(step),
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium.copyWith(color: colorTheme.onSurface),
        ),
        const SizedBox(height: 24),
        Text(
          AppStrings.workoutExecutionReactionPrompt,
          textAlign: TextAlign.center,
          style: textTheme.body.copyWith(color: colorTheme.darkHint),
        ),
        const SizedBox(height: 12),
        Align(
          child: WorkoutReactionPicker(
            selectedReaction: _selectedReaction,
            isEnabled: !state.isSubmittingResult && !state.isCompleting && !state.isAbandoning,
            onSelected: (reaction) => _handleReactionSelected(context, reaction),
          ),
        ),
      ],
    );
  }

  Future<void> _handleStateChanged(
    BuildContext context,
    WorkoutExecutionState state,
  ) async {
    _syncRestTimer(state.currentStep);
    final cubit = context.read<WorkoutExecutionCubit>();
    final adjustment = cubit.consumePendingAdjustment();

    if (state.shouldPopToDetails) {
      _closeExitDialogIfOpen();
      cubit.clearPopToDetails();
      if (!mounted) return;
      if (Navigator.canPop(context)) {
        context.pop(false);
      } else {
        context.go(AppRoutePaths.workoutDetailsConcretePath(widget.userWorkoutId));
      }
      return;
    }

    final failure = state.failure;
    if (failure != null && state.currentStep != null) {
      _closeExitDialogIfOpen();
      await showAppFeedbackDialog(
        context,
        title: AppStrings.feedbackErrorTitle,
        message: failure.message,
      );
      if (!mounted) return;
      cubit.clearFailure();
      return;
    }

    if (adjustment != null) {
      await showAppFeedbackDialog(
        context,
        title: AppStrings.workoutExecutionAdjustmentTitle,
        message: _buildAdjustmentMessage(adjustment),
      );
      if (!context.mounted) return;
      if (!state.isCompleted) return;
    }

    if (state.isCompleted) {
      await _showCompletedDialog(context);
    }
  }

  void _syncRestTimer(WorkoutExecutionStep? step) {
    if (step case WorkoutExerciseStep(:final id)) {
      if (_activeExerciseId == id) return;
      _activeExerciseId = id;
      _remainingRestSeconds = _initialRestSeconds;
      _selectedReaction = null;
      _restTimer?.cancel();
      _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        if (_remainingRestSeconds == 0) {
          timer.cancel();
          return;
        }
        setState(() => _remainingRestSeconds -= 1);
      });
      if (mounted) setState(() {});
      return;
    }

    _activeExerciseId = null;
    _selectedReaction = null;
    _restTimer?.cancel();
    _remainingRestSeconds = _initialRestSeconds;
  }

  Future<void> _handleReactionSelected(
    BuildContext context,
    WorkoutExerciseReaction reaction,
  ) async {
    final cubit = context.read<WorkoutExecutionCubit>();
    final currentStep = cubit.state.currentStep;
    if (currentStep is! WorkoutExerciseStep) return;

    setState(() => _selectedReaction = reaction);

    double? weightUsed;
    if (currentStep.needsWeightInput) {
      weightUsed = await _showWeightInputDialog(context, currentStep);
      if (!mounted) return;
    }

    await cubit.submitReaction(
      reaction,
      weightUsed: weightUsed,
    );
  }

  String _formatRestTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  String _formatWorkoutWeight(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(1);
  }

  String _buildExerciseInstruction(WorkoutExerciseStep step) {
    final setsLabel = _buildSetsLabel(step.sets);
    return AppStrings.workoutExecutionInstruction(
      sets: step.sets,
      setsLabel: setsLabel,
      reps: step.reps,
      weight: step.currentWeight == null ? null : _formatWorkoutWeight(step.currentWeight!),
    );
  }

  Future<double?> _showWeightInputDialog(
    BuildContext context,
    WorkoutExerciseStep step,
  ) async {
    final colorTheme = AppColorTheme.of(context);
    return showDialog<double?>(
      context: context,
      barrierDismissible: false,
      barrierColor: colorTheme.onSurface.withValues(alpha: 0.16),
      builder: (dialogContext) => PopScope(
        canPop: false,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: WorkoutWeightInputDialog(initialWeight: step.currentWeight),
        ),
      ),
    );
  }

  Future<void> _showExitDialog(BuildContext context) {
    if (_isExitDialogOpen) return Future.value();

    _isExitDialogOpen = true;
    final cubit = context.read<WorkoutExecutionCubit>();
    return showAppActionDialog(
      context,
      title: AppStrings.workoutExecutionExitTitle,
      description: AppStrings.workoutExecutionExitDescription,
      primaryAction: BlocProvider.value(
        value: cubit,
        child: BlocBuilder<WorkoutExecutionCubit, WorkoutExecutionState>(
          builder: (context, state) {
            return MainButton(
              state: state.isAbandoning ? ButtonState.loading : ButtonState.enabled,
              onPressed: context.read<WorkoutExecutionCubit>().abandonWorkout,
              child: const Text(AppStrings.workoutExecutionExitPrimary),
            );
          },
        ),
      ),
      secondaryAction: BlocProvider.value(
        value: cubit,
        child: BlocBuilder<WorkoutExecutionCubit, WorkoutExecutionState>(
          builder: (context, state) {
            return SecondaryButton(
              state: state.isAbandoning ? ButtonState.disabled : ButtonState.enabled,
              onPressed: _closeExitDialogIfOpen,
              child: const Text(AppStrings.workoutExecutionExitSecondary),
            );
          },
        ),
      ),
    ).whenComplete(() => _isExitDialogOpen = false);
  }

  Future<void> _showCompletedDialog(BuildContext context) {
    return showAppActionDialog(
      context,
      title: AppStrings.workoutExecutionCompletedTitle,
      description: AppStrings.workoutExecutionCompletedDescription,
      primaryAction: MainButton(
        onPressed: () {
          context.pop();
          context.pop(true);
        },
        child: const Text(AppStrings.workoutExecutionCompletedPrimary),
      ),
    );
  }

  void _closeExitDialogIfOpen() {
    if (!_isExitDialogOpen || !mounted) return;

    final navigator = Navigator.of(context, rootNavigator: true);
    if (!navigator.canPop()) {
      _isExitDialogOpen = false;
      return;
    }

    Route<dynamic>? topRoute;
    navigator.popUntil((route) {
      topRoute = route;
      return true;
    });
    if (topRoute is! PopupRoute<dynamic>) {
      _isExitDialogOpen = false;
      return;
    }

    navigator.pop();
    _isExitDialogOpen = false;
  }
}

String _buildAdjustmentMessage(WorkoutLoadAdjustment adjustment) {
  final newWeight = adjustment.newWeight;
  if (newWeight == null) return AppStrings.workoutExecutionAdjustmentFallback;

  final formattedWeight = _formatAdjustmentWeight(newWeight);
  return switch (adjustment.type) {
    'increase' => AppStrings.workoutExecutionAdjustmentIncrease(formattedWeight),
    'decrease' => AppStrings.workoutExecutionAdjustmentDecrease(formattedWeight),
    _ => AppStrings.workoutExecutionAdjustmentFallback,
  };
}

String _formatAdjustmentWeight(double value) {
  if (value == value.roundToDouble()) {
    return value.toInt().toString();
  }
  return value.toStringAsFixed(1);
}

String _buildSetsLabel(int sets) {
  final mod100 = sets % 100;
  if (mod100 >= 11 && mod100 <= 14) {
    return 'подходов';
  }

  return switch (sets % 10) {
    1 => 'подход',
    2 || 3 || 4 => 'подхода',
    _ => 'подходов',
  };
}

class _StepImage extends StatelessWidget {
  final String imageUrl;

  const _StepImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: NetworkImageWidget(
            imageUrl: imageUrl,
            height: constraints.maxWidth,
          ),
        );
      },
    );
  }
}

String _stepKey(WorkoutExecutionStep? step) => switch (step) {
  null => 'null',
  WorkoutWarmupStep(:final id) => 'warmup:$id',
  WorkoutExerciseStep(:final id) => 'exercise:$id',
};
