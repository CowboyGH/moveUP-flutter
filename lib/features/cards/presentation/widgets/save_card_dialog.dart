import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../uikit/buttons/button_state.dart';
import '../../../../uikit/buttons/main_button.dart';
import '../../../../uikit/buttons/secondary_button.dart';
import '../../../../uikit/dialogs/app_feedback_dialog.dart';
import '../../../../uikit/images/svg_picture_widget.dart';
import '../../../../uikit/themes/colors/app_color_theme.dart';
import '../../../../uikit/themes/text/app_text_theme.dart';
import '../../../profile/presentation/widgets/profile_dialog_shell.dart';
import '../../domain/entities/save_card_payload.dart';
import '../cubits/save_card_cubit.dart';
import '../validators/card_form_validators.dart';
import 'card_form_text_field.dart';

/// Opens the save-card dialog.
Future<bool?> showSaveCardDialog(
  BuildContext context, {
  required SaveCardCubit saveCardCubit,
}) {
  return showProfileDialog<bool>(
    context,
    insetPadding: const EdgeInsets.symmetric(horizontal: 24),
    contentPadding: EdgeInsets.zero,
    child: BlocProvider.value(
      value: saveCardCubit,
      child: const SaveCardDialog(),
    ),
  );
}

/// Dialog with manual card form for saving a card.
class SaveCardDialog extends StatefulWidget {
  /// Creates an instance of [SaveCardDialog].
  const SaveCardDialog({super.key});

  @override
  State<SaveCardDialog> createState() => _SaveCardDialogState();
}

class _SaveCardDialogState extends State<SaveCardDialog> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _previewCardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryMonthController = TextEditingController();
  final _expiryYearController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cardNumberController.addListener(_syncPreviewCardNumber);
    _cardNumberController.addListener(_handlePreviewChanged);
    _cardHolderController.addListener(_handlePreviewChanged);
    _expiryMonthController.addListener(_handlePreviewChanged);
    _expiryYearController.addListener(_handlePreviewChanged);
  }

  @override
  void dispose() {
    _cardNumberController
      ..removeListener(_syncPreviewCardNumber)
      ..removeListener(_handlePreviewChanged)
      ..dispose();
    _cardHolderController.removeListener(_handlePreviewChanged);
    _previewCardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryMonthController.removeListener(_handlePreviewChanged);
    _expiryMonthController.dispose();
    _expiryYearController.removeListener(_handlePreviewChanged);
    _expiryYearController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _handlePreviewChanged() {
    if (!mounted) return;
    setState(() {});
  }

  void _syncPreviewCardNumber() {
    final digits = _cardNumberController.text.replaceAll(RegExp(r'\D'), '');
    final chunks = <String>[];
    for (var index = 0; index < digits.length; index += 4) {
      final end = (index + 4).clamp(0, digits.length);
      chunks.add(digits.substring(index, end));
    }
    _previewCardNumberController.text = chunks.join(' ');
  }

  void _submit() {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    context.read<SaveCardCubit>().saveCard(
      payload: SaveCardPayload(
        cardNumber: _cardNumberController.text.replaceAll(RegExp(r'\D'), ''),
        cardHolder: _cardHolderController.text.trim(),
        expiryMonth: _expiryMonthController.text.trim(),
        expiryYear: _expiryYearController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SaveCardCubit, SaveCardState>(
      listener: (context, state) {
        state.whenOrNull(
          succeed: () => Navigator.of(context).pop(true),
          failed: (failure) {
            if (failure.message.isEmpty) return;
            showAppFeedbackDialog(
              context,
              title: AppStrings.feedbackErrorTitle,
              message: failure.message,
            );
          },
        );
      },
      builder: (context, state) {
        final isInProgress = state.maybeWhen(
          inProgress: () => true,
          orElse: () => false,
        );
        final colorTheme = AppColorTheme.of(context);
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 83, 28, 40),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CardFormTextField(
                      controller: _cardNumberController,
                      labelText: AppStrings.subscriptionsPaymentCardNumberLabel,
                      labelColor: colorTheme.hint,
                      hintText: AppStrings.subscriptionsPaymentCardNumberHint,
                      enabled: !isInProgress,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [const _CardNumberTextInputFormatter()],
                      validator: CardFormValidators.cardNumber,
                    ),
                    const SizedBox(height: 12),
                    CardFormTextField(
                      controller: _cardHolderController,
                      labelText: AppStrings.subscriptionsPaymentCardHolderLabel,
                      labelColor: colorTheme.hint,
                      hintText: AppStrings.subscriptionsPaymentCardHolderHint,
                      enabled: !isInProgress,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      validator: CardFormValidators.cardHolder,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ExcludeSemantics(
                                child: Text(
                                  AppStrings.subscriptionsPaymentExpiryLabel,
                                  style: AppTextTheme.of(context).label.copyWith(
                                    color: colorTheme.hint,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Expanded(
                                    child: CardFormTextField(
                                      controller: _expiryMonthController,
                                      labelText: AppStrings.subscriptionsPaymentExpiryLabel,
                                      semanticsLabel: AppStrings.subscriptionsPaymentExpiryLabel,
                                      hintText: AppStrings.subscriptionsPaymentExpiryMonthHint,
                                      showErrorText: false,
                                      enabled: !isInProgress,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                      showLabel: false,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(2),
                                      ],
                                      validator: (value) => CardFormValidators.expiryMonth(
                                        value,
                                        yearValue: _expiryYearController.text,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: CardFormTextField(
                                      controller: _expiryYearController,
                                      labelText: AppStrings.subscriptionsPaymentYearLabel,
                                      semanticsLabel: AppStrings.subscriptionsPaymentYearLabel,
                                      hintText: AppStrings.subscriptionsPaymentExpiryYearHint,
                                      showErrorText: false,
                                      enabled: !isInProgress,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                      showLabel: false,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(4),
                                      ],
                                      validator: (value) => CardFormValidators.expiryYear(
                                        value,
                                        monthValue: _expiryMonthController.text,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CardFormTextField(
                            controller: _cvvController,
                            labelText: AppStrings.subscriptionsPaymentCvvLabel,
                            labelColor: colorTheme.hint,
                            hintText: AppStrings.subscriptionsPaymentCvvHint,
                            showErrorText: false,
                            enabled: !isInProgress,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            obscureText: true,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(3),
                            ],
                            validator: CardFormValidators.cvv,
                            onFieldSubmitted: (_) => _submit(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 36),
                    MainButton(
                      state: isInProgress ? ButtonState.loading : ButtonState.enabled,
                      onPressed: _submit,
                      child: const Text(AppStrings.cardsAddButton),
                    ),
                    const SizedBox(height: 12),
                    SecondaryButton(
                      state: isInProgress ? ButtonState.disabled : ButtonState.enabled,
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text(AppStrings.profileCancelButton),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: -100,
              left: 0,
              right: 0,
              child: _CardPreview(
                previewCardNumberController: _previewCardNumberController,
                cardHolderValue: _cardHolderController.text,
                expiryMonthValue: _expiryMonthController.text.trim(),
                expiryYearValue: _expiryYearController.text.trim(),
              ),
            ),
          ],
        );
      },
    );
  }
}

final class _CardPreview extends StatelessWidget {
  final TextEditingController previewCardNumberController;
  final String cardHolderValue;
  final String expiryMonthValue;
  final String expiryYearValue;

  const _CardPreview({
    required this.previewCardNumberController,
    required this.cardHolderValue,
    required this.expiryMonthValue,
    required this.expiryYearValue,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    final textTheme = AppTextTheme.of(context);
    return Stack(
      children: [
        const Positioned.fill(
          child: IgnorePointer(
            child: ExcludeSemantics(
              child: SvgPictureWidget.icon(AppAssets.iconCardBig),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 51, 24, 12),
          child: Column(
            children: [
              SizedBox(
                width: 224,
                child: _PreviewNumberField(controller: previewCardNumberController),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.subscriptionsPaymentCardHolderLabel,
                            style: textTheme.label.copyWith(color: colorTheme.onPrimary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            cardHolderValue.isEmpty
                                ? AppStrings.subscriptionsPaymentCardHolderHint
                                : cardHolderValue,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.label.copyWith(color: colorTheme.onPrimary),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          AppStrings.subscriptionsPaymentPreviewExpiryLabel,
                          style: textTheme.label.copyWith(color: colorTheme.onPrimary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          [expiryMonthValue, expiryYearValue]
                              .where((value) => value.isNotEmpty)
                              .join('/')
                              .ifEmpty(
                                '${AppStrings.subscriptionsPaymentPreviewExpiryMonthLabel}/'
                                '${AppStrings.subscriptionsPaymentPreviewExpiryYearLabel}',
                              ),
                          style: textTheme.label.copyWith(color: colorTheme.onPrimary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

final class _PreviewNumberField extends StatelessWidget {
  final TextEditingController controller;

  const _PreviewNumberField({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final displayText = controller.text.isEmpty
        ? AppStrings.subscriptionsPaymentCardNumberHint
        : controller.text;
    final textColor = controller.text.isEmpty ? colorTheme.outline : colorTheme.onSurface;

    return Semantics(
      label: AppStrings.subscriptionsPaymentCardNumberLabel,
      textField: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorTheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colorTheme.outline),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Text(
            displayText,
            style: textTheme.body.copyWith(color: textColor),
          ),
        ),
      ),
    );
  }
}

final class _CardNumberTextInputFormatter extends TextInputFormatter {
  const _CardNumberTextInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final limitedDigits = digits.length > 16 ? digits.substring(0, 16) : digits;
    final buffer = StringBuffer();

    for (var index = 0; index < limitedDigits.length; index++) {
      if (index > 0 && index % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(limitedDigits[index]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

extension on String {
  String ifEmpty(String fallback) => isEmpty ? fallback : this;
}
