import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../uikit/buttons/button_state.dart';
import '../../../../uikit/buttons/main_button.dart';
import '../../../../uikit/buttons/option_button.dart';
import '../../../../uikit/cards/app_card.dart';
import '../../../../uikit/dialogs/app_feedback_dialog.dart';
import '../../../../uikit/images/network_image_widget.dart';
import '../../../../uikit/images/svg_picture_widget.dart';
import '../../../../uikit/inputs/app_input_field.dart';
import '../../../../uikit/themes/colors/app_color_theme.dart';
import '../../../../uikit/themes/text/app_text_theme.dart';
import '../../../auth/presentation/cubits/auth_session_cubit.dart';
import '../../../tests/attempt/presentation/cubits/test_attempt_cubit.dart';
import '../../../tests/attempt/presentation/validators/test_attempt_validators.dart';
import '../widgets/fitness_start_flow_app_bar.dart';

/// Fitness Start page for a single guest test attempt.
class FitnessStartTestAttemptPage extends StatefulWidget {
  /// Testing identifier used for start retry.
  final int testingId;

  /// Creates an instance of [FitnessStartTestAttemptPage].
  const FitnessStartTestAttemptPage({
    required this.testingId,
    super.key,
  });

  @override
  State<FitnessStartTestAttemptPage> createState() => _FitnessStartTestAttemptPageState();
}

class _FitnessStartTestAttemptPageState extends State<FitnessStartTestAttemptPage> {
  final _pulseFormKey = GlobalKey<FormState>();
  final _pulseController = TextEditingController();
  final _resultLabels = const [
    AppStrings.testsAttemptResultVeryPoor,
    AppStrings.testsAttemptResultPoor,
    AppStrings.testsAttemptResultNormal,
    AppStrings.testsAttemptResultGood,
  ];

  TestAttemptCubit get _cubit => context.read<TestAttemptCubit>();

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _showFeedback(String message) {
    showAppFeedbackDialog(
      context,
      title: AppStrings.feedbackErrorTitle,
      message: message,
    );
  }

  Future<void> _submitPulse() async {
    FocusScope.of(context).unfocus();
    final form = _pulseFormKey.currentState;
    if (form == null || !form.validate()) return;

    await _cubit.submitPulse(int.parse(_pulseController.text.trim()));
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    return BlocConsumer<TestAttemptCubit, TestAttemptState>(
      listenWhen: (previous, current) =>
          previous.failure != current.failure || !previous.isCompleted && current.isCompleted,
      listener: (context, state) {
        final failure = state.failure;
        if (failure != null && state.testing != null) {
          _showFeedback(failure.message);
          _cubit.clearFailure();
        }
        if (state.isCompleted) {
          unawaited(context.read<AuthSessionCubit>().completeGuestFitnessStart());
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: FitnessStartFlowAppBar(
            title: AppStrings.fitnessStartTestsTitle,
            progress: 0.5,
            showBackButton: true,
            onBackPressed: context.pop,
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
              if (state.testing == null)
                _buildStartState(context, state)
              else
                _buildLoadedState(context, state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStartState(BuildContext context, TestAttemptState state) {
    if (state.isStarting) {
      return const Center(
        child: SizedBox.square(
          dimension: 24,
          child: CircularProgressIndicator.adaptive(strokeWidth: 2),
        ),
      );
    }

    final textTheme = AppTextTheme.of(context);
    final colorTheme = AppColorTheme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppStrings.testsStartFailed,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium.copyWith(color: colorTheme.onSurface),
            ),
            const SizedBox(height: 24),
            MainButton(
              onPressed: () => _cubit.startTest(widget.testingId),
              child: const Text(AppStrings.fitnessStartRetryButton),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, TestAttemptState state) {
    if (state.isCompleted) {
      return const Center(
        child: SizedBox.square(
          dimension: 24,
          child: CircularProgressIndicator.adaptive(strokeWidth: 2),
        ),
      );
    }

    final testing = state.testing!;
    final textTheme = AppTextTheme.of(context);
    final colorTheme = AppColorTheme.of(context);
    final isPulseStep = state.isAwaitingPulse || state.currentExercise == null;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppStrings.testsAttemptTitle,
            textAlign: TextAlign.center,
            style: textTheme.title.copyWith(color: colorTheme.onSurface),
          ),
          const SizedBox(height: 8),
          Text(
            isPulseStep ? AppStrings.testsAttemptPulseTitle : AppStrings.testsAttemptDescription,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium.copyWith(color: colorTheme.onSurface),
          ),
          const SizedBox(height: 20),
          Align(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: colorTheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: colorTheme.disabled.withValues(alpha: 0.6)),
              ),
              child: Text(
                '${state.currentExerciseOrderNumber}/${testing.totalExercises}',
                style: textTheme.bodyMedium.copyWith(color: colorTheme.onSurface),
              ),
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            child: isPulseStep
                ? _buildPulseContent(context, state)
                : _buildExerciseContent(context, state),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseContent(BuildContext context, TestAttemptState state) {
    final exercise = state.currentExercise!;
    final testing = state.testing!;
    final textTheme = AppTextTheme.of(context);
    final colorTheme = AppColorTheme.of(context);
    final buttonState = state.isSubmittingResult ? ButtonState.disabled : ButtonState.enabled;

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - 8) / 2;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: NetworkImageWidget(
                imageUrl: exercise.imageUrl,
                height: constraints.maxWidth,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              testing.title,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium.copyWith(
                fontSize: 16,
                height: 24 / 16,
                fontWeight: FontWeight.w500,
                color: colorTheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              exercise.description,
              textAlign: TextAlign.center,
              style: textTheme.body.copyWith(color: colorTheme.hint),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(4, (index) {
                final value = index + 1;
                final label = _resultLabels[index];
                return SizedBox(
                  width: itemWidth,
                  child: OptionButton(
                    state: buttonState,
                    onPressed: () => _cubit.submitResult(value),
                    child: Text(label),
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPulseContent(BuildContext context, TestAttemptState state) {
    final textTheme = AppTextTheme.of(context);
    final colorTheme = AppColorTheme.of(context);
    return Form(
      key: _pulseFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            state.testing!.title,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium.copyWith(
              fontSize: 16,
              height: 24 / 16,
              fontWeight: FontWeight.w500,
              color: colorTheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            AppStrings.testsAttemptPulseTitle,
            textAlign: TextAlign.center,
            style: textTheme.body.copyWith(color: colorTheme.hint),
          ),
          const SizedBox(height: 20),
          AppInputField(
            controller: _pulseController,
            labelText: AppStrings.testsAttemptPulseLabel,
            hintText: AppStrings.testsAttemptPulseHint,
            enabled: !state.isCompleting,
            keyboardType: TextInputType.number,
            validator: TestAttemptValidators.pulse,
            textInputAction: TextInputAction.done,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 24),
          MainButton(
            state: state.isCompleting ? ButtonState.loading : ButtonState.enabled,
            onPressed: _submitPulse,
            child: const Text(AppStrings.testsAttemptCompleteButton),
          ),
        ],
      ),
    );
  }
}
