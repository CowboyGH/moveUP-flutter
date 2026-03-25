import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/router_paths.dart';
import '../../../../uikit/buttons/button_state.dart';
import '../../../../uikit/buttons/main_button.dart';
import '../../../../uikit/buttons/option_button.dart';
import '../../../../uikit/cards/app_card.dart';
import '../../../../uikit/dialogs/app_feedback_dialog.dart';
import '../../../../uikit/images/svg_picture_widget.dart';
import '../../../../uikit/inputs/app_input_field.dart';
import '../../../../uikit/themes/colors/app_color_theme.dart';
import '../../../../uikit/themes/text/app_text_theme.dart';
import '../../../auth/presentation/cubits/auth_session_cubit.dart';
import '../../domain/entities/fitness_start_gender.dart';
import '../../domain/entities/fitness_start_option.dart';
import '../../domain/entities/fitness_start_references.dart';
import '../cubits/fitness_start_cubit.dart';
import '../validators/fitness_start_validators.dart';
import '../widgets/fitness_start_flow_app_bar.dart';

/// Three-step Fitness Start quiz page.
class FitnessStartQuizPage extends StatefulWidget {
  /// Creates an instance of [FitnessStartQuizPage].
  const FitnessStartQuizPage({super.key});

  @override
  State<FitnessStartQuizPage> createState() => _FitnessStartQuizPageState();
}

class _FitnessStartQuizPageState extends State<FitnessStartQuizPage> {
  final _stepTwoFormKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  @override
  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _showFeedback(String message) {
    showAppFeedbackDialog(
      context,
      title: AppStrings.feedbackErrorTitle,
      message: message,
    );
  }

  AuthSessionCubit get _authSessionCubit => context.read<AuthSessionCubit>();

  FitnessStartCubit get _fitnessStartCubit => context.read<FitnessStartCubit>();

  Future<void> _handleGuestBack(FitnessStartState state) async {
    FocusScope.of(context).unfocus();
    if (state.currentStep == 0) {
      await _authSessionCubit.cancelGuestFlow();
      return;
    }
    _fitnessStartCubit.previousStep();
  }

  Future<void> _submitCurrentStep(FitnessStartState state) async {
    FocusScope.of(context).unfocus();
    await switch (state.currentStep) {
      0 => _submitGoal(state),
      1 => _submitAnthropometry(state),
      2 => _submitLevel(state),
      _ => null,
    };
  }

  Future<void> _submitGoal(FitnessStartState state) async {
    if (state.selectedGoalId == null) {
      _showFeedback(AppStrings.fitnessStartGoalRequired);
      return;
    }
    await _fitnessStartCubit.submitGoal();
  }

  Future<void> _submitAnthropometry(FitnessStartState state) async {
    final form = _stepTwoFormKey.currentState;
    if (form == null) return;
    if (!form.validate()) return;

    if (state.selectedGender == null) {
      _showFeedback(AppStrings.fitnessStartGenderRequired);
      return;
    }
    if (state.selectedEquipmentId == null) {
      _showFeedback(AppStrings.fitnessStartEquipmentRequired);
      return;
    }

    final age = int.tryParse(_ageController.text.trim());
    if (age == null) {
      _showFeedback(AppStrings.fitnessStartAgeInvalid);
      return;
    }

    final weight = double.tryParse(_weightController.text.trim().replaceAll(',', '.'));
    if (weight == null) {
      _showFeedback(AppStrings.fitnessStartWeightInvalid);
      return;
    }

    final height = int.tryParse(_heightController.text.trim());
    if (height == null) {
      _showFeedback(AppStrings.fitnessStartHeightInvalid);
      return;
    }

    await _fitnessStartCubit.submitAnthropometry(
      age: age,
      weight: weight,
      height: height,
    );
  }

  Future<void> _submitLevel(FitnessStartState state) async {
    if (state.selectedLevelId == null) {
      _showFeedback(AppStrings.fitnessStartLevelRequired);
      return;
    }
    await _fitnessStartCubit.submitLevel();
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    final isGuestOnboarding = context.select<AuthSessionCubit, bool>(
      (cubit) => cubit.state.maybeWhen(
        guest: () => true,
        orElse: () => false,
      ),
    );
    return BlocConsumer<FitnessStartCubit, FitnessStartState>(
      listenWhen: (previous, current) =>
          previous.failure != current.failure || !previous.isCompleted && current.isCompleted,
      listener: (context, state) {
        final failure = state.failure;
        if (failure != null && failure.message.isNotEmpty) {
          if (state.references != null) {
            _showFeedback(failure.message);
          }
          _fitnessStartCubit.clearFailure();
        }
        if (state.isCompleted) {
          context.go(
            AppRoutePaths.fitnessStartTestsPath,
            extra: AppRoutePaths.fitnessStartQuizPath,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: FitnessStartFlowAppBar(
            title: AppStrings.fitnessStartTitle,
            progress: (state.currentStep + 1) / 4,
            showBackButton: isGuestOnboarding,
            onBackPressed: isGuestOnboarding ? () => unawaited(_handleGuestBack(state)) : null,
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 88, 24, 24),
                child: SizedBox(
                  width: constraints.maxWidth,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      _buildBackgroundLine(
                        colorTheme: colorTheme,
                        top: -24,
                      ),
                      _buildBackgroundLine(
                        colorTheme: colorTheme,
                        bottom: -42,
                      ),
                      AppCard(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 24,
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 220),
                          switchInCurve: Curves.easeInOut,
                          switchOutCurve: Curves.easeInOut,
                          child: _buildCardContent(state),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildBackgroundLine({
    required AppColorTheme colorTheme,
    double? top,
    double? bottom,
  }) {
    return Positioned(
      left: -48,
      right: -48,
      top: top,
      bottom: bottom,
      child: IgnorePointer(
        child: ExcludeSemantics(
          child: SvgPictureWidget.frame(
            AppAssets.imageLine,
            fit: BoxFit.fitWidth,
            color: colorTheme.primary.withValues(alpha: 0.3),
          ),
        ),
      ),
    );
  }

  Widget _buildCardContent(FitnessStartState state) {
    final references = state.references;
    if (state.isLoadingReferences) {
      return _buildLoadingState();
    }
    if (references == null) {
      return _buildReferencesLoadFailedState();
    }
    return KeyedSubtree(
      key: ValueKey(state.currentStep),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            _titleForStep(state.currentStep),
            textAlign: TextAlign.center,
            style: AppTextTheme.of(context).bodyMedium,
          ),
          const SizedBox(height: 24),
          _buildStepContent(state, references),
          const SizedBox(height: 24),
          MainButton(
            state: state.isSubmitting ? ButtonState.loading : ButtonState.enabled,
            onPressed: () => _submitCurrentStep(state),
            child: const Text(AppStrings.fitnessStartContinueButton),
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
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  Widget _buildReferencesLoadFailedState() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          AppStrings.fitnessStartReferencesLoadFailed,
          textAlign: TextAlign.center,
          style: AppTextTheme.of(context).bodyMedium,
        ),
        const SizedBox(height: 24),
        MainButton(
          onPressed: _fitnessStartCubit.loadReferences,
          child: const Text(AppStrings.fitnessStartRetryButton),
        ),
      ],
    );
  }

  String _titleForStep(int step) {
    return switch (step) {
      0 => AppStrings.fitnessStartGoalStepTitle,
      1 => AppStrings.fitnessStartAnthropometryStepTitle,
      _ => AppStrings.fitnessStartLevelStepTitle,
    };
  }

  Widget _buildStepContent(FitnessStartState state, FitnessStartReferences references) {
    return switch (state.currentStep) {
      0 => _buildSingleColumnOptions(
        options: references.goals,
        selectedId: state.selectedGoalId,
        enabled: !state.isSubmitting,
        onSelected: _fitnessStartCubit.selectGoal,
      ),
      1 => Form(
        key: _stepTwoFormKey,
        child: _buildAnthropometryStep(
          state,
          references.equipment,
        ),
      ),
      2 => _buildSingleColumnOptions(
        options: references.levels,
        selectedId: state.selectedLevelId,
        enabled: !state.isSubmitting,
        onSelected: _fitnessStartCubit.selectLevel,
      ),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _buildSingleColumnOptions({
    required List<FitnessStartOption> options,
    required int? selectedId,
    required bool enabled,
    required ValueChanged<int> onSelected,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var index = 0; index < options.length; index++) ...[
          OptionButton(
            state: enabled ? ButtonState.enabled : ButtonState.disabled,
            isSelected: selectedId == options[index].id,
            onPressed: () => onSelected(options[index].id),
            child: Text(
              options[index].name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (index < options.length - 1) const SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _buildAnthropometryStep(
    FitnessStartState state,
    List<FitnessStartOption> equipmentOptions,
  ) {
    final textTheme = AppTextTheme.of(context);
    final colorTheme = AppColorTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.fitnessStartGenderLabel,
          style: textTheme.label.copyWith(color: colorTheme.hint),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: OptionButton(
                state: state.isSubmitting ? ButtonState.disabled : ButtonState.enabled,
                isSelected: state.selectedGender == FitnessStartGender.male,
                onPressed: () => _fitnessStartCubit.selectGender(FitnessStartGender.male),
                child: const Text(
                  AppStrings.fitnessStartMaleOption,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OptionButton(
                state: state.isSubmitting ? ButtonState.disabled : ButtonState.enabled,
                isSelected: state.selectedGender == FitnessStartGender.female,
                onPressed: () => _fitnessStartCubit.selectGender(FitnessStartGender.female),
                child: const Text(
                  AppStrings.fitnessStartFemaleOption,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AppInputField(
                controller: _ageController,
                enabled: !state.isSubmitting,
                labelText: AppStrings.fitnessStartAgeLabel,
                hintText: AppStrings.fitnessStartAgeHint,
                keyboardType: TextInputType.number,
                validator: FitnessStartValidators.age,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppInputField(
                controller: _weightController,
                enabled: !state.isSubmitting,
                labelText: AppStrings.fitnessStartWeightLabel,
                hintText: AppStrings.fitnessStartWeightHint,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: FitnessStartValidators.weight,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppInputField(
                controller: _heightController,
                enabled: !state.isSubmitting,
                labelText: AppStrings.fitnessStartHeightLabel,
                hintText: AppStrings.fitnessStartHeightHint,
                keyboardType: TextInputType.number,
                validator: FitnessStartValidators.height,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          AppStrings.fitnessStartEquipmentLabel,
          style: textTheme.label.copyWith(color: colorTheme.hint),
        ),
        const SizedBox(height: 6),
        LayoutBuilder(
          builder: (context, constraints) {
            final itemWidth = (constraints.maxWidth - 12) / 2;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: equipmentOptions
                  .map(
                    (option) => SizedBox(
                      width: itemWidth,
                      child: OptionButton(
                        state: state.isSubmitting ? ButtonState.disabled : ButtonState.enabled,
                        isSelected: state.selectedEquipmentId == option.id,
                        onPressed: () => _fitnessStartCubit.selectEquipment(option.id),
                        child: Text(
                          option.name,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  )
                  .toList(growable: false),
            );
          },
        ),
      ],
    );
  }
}
