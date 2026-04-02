import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../uikit/buttons/button_state.dart';
import '../../../../uikit/buttons/main_button.dart';
import '../../../../uikit/buttons/secondary_button.dart';
import '../../../../uikit/dialogs/app_feedback_dialog.dart';
import '../../../../uikit/inputs/app_input_field.dart';
import '../../../../uikit/themes/colors/app_color_theme.dart';
import '../../../../uikit/themes/text/app_text_theme.dart';
import '../../../profile/presentation/widgets/profile_dialog_shell.dart';
import '../../domain/entities/subscription_catalog_item.dart';
import '../../domain/entities/subscription_payment_payload.dart';
import '../cubits/subscription_payment_cubit.dart';
import 'subscription_card.dart';

/// Opens the subscription payment dialog.
Future<bool?> showSubscriptionPaymentDialog(
  BuildContext context, {
  required SubscriptionCatalogItem item,
  required SubscriptionPaymentCubit paymentCubit,
}) {
  return showProfileDialog<bool>(
    context,
    insetPadding: const EdgeInsets.symmetric(horizontal: 20),
    contentPadding: EdgeInsets.zero,
    child: BlocProvider.value(
      value: paymentCubit,
      child: SubscriptionPaymentDialog(item: item),
    ),
  );
}

/// Dialog with manual card form for paying for a subscription.
class SubscriptionPaymentDialog extends StatefulWidget {
  /// Subscription currently being purchased.
  final SubscriptionCatalogItem item;

  /// Creates an instance of [SubscriptionPaymentDialog].
  const SubscriptionPaymentDialog({
    required this.item,
    super.key,
  });

  @override
  State<SubscriptionPaymentDialog> createState() => _SubscriptionPaymentDialogState();
}

class _SubscriptionPaymentDialogState extends State<SubscriptionPaymentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _previewCardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryMonthController = TextEditingController();
  final _expiryYearController = TextEditingController();
  final _cvvController = TextEditingController();

  bool _rememberData = false;

  @override
  void initState() {
    super.initState();
    _cardNumberController.addListener(_syncPreviewCardNumber);
    _cardHolderController.addListener(_handlePreviewChanged);
    _expiryMonthController.addListener(_handlePreviewChanged);
    _expiryYearController.addListener(_handlePreviewChanged);
  }

  @override
  void dispose() {
    _cardNumberController
      ..removeListener(_syncPreviewCardNumber)
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

  String? _cardNumberValidator(String? value) {
    final digits = (value ?? '').replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return AppStrings.subscriptionsPaymentCardNumberLabel;
    if (digits.length != 16) return AppStrings.subscriptionsPaymentCardNumberHint;
    return null;
  }

  String? _requiredValidator(String? value, String fallback) {
    if (value == null || value.trim().isEmpty) return fallback;
    return null;
  }

  String? _expiryMonthValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.subscriptionsPaymentExpiryMonthHint;
    }
    final month = int.tryParse(value);
    if (month == null || month < 1 || month > 12) {
      return AppStrings.subscriptionsPaymentExpiryMonthHint;
    }
    return null;
  }

  String? _expiryYearValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.subscriptionsPaymentExpiryYearHint;
    }
    if (value.trim().length != 4) {
      return AppStrings.subscriptionsPaymentExpiryYearHint;
    }
    return null;
  }

  String? _cvvValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.subscriptionsPaymentCvvHint;
    }
    if (value.trim().length != 3) {
      return AppStrings.subscriptionsPaymentCvvHint;
    }
    return null;
  }

  void _submit() {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    context.read<SubscriptionPaymentCubit>().pay(
      payload: SubscriptionPaymentPayload(
        subscriptionId: widget.item.id,
        saveCard: _rememberData,
        cardNumber: _cardNumberController.text.replaceAll(RegExp(r'\D'), ''),
        cardHolder: _cardHolderController.text.trim(),
        expiryMonth: _expiryMonthController.text.trim(),
        expiryYear: _expiryYearController.text.trim(),
        cvv: _cvvController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SubscriptionPaymentCubit, SubscriptionPaymentState>(
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
        final textTheme = AppTextTheme.of(context);
        final colorTheme = AppColorTheme.of(context);
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 172, 24, 32),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppInputField(
                      controller: _cardNumberController,
                      labelText: AppStrings.subscriptionsPaymentCardNumberLabel,
                      hintText: AppStrings.subscriptionsPaymentCardNumberHint,
                      enabled: !isInProgress,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      textAlign: TextAlign.start,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(16),
                      ],
                      validator: _cardNumberValidator,
                    ),
                    const SizedBox(height: 12),
                    AppInputField(
                      controller: _cardHolderController,
                      labelText: AppStrings.subscriptionsPaymentCardHolderLabel,
                      hintText: AppStrings.subscriptionsPaymentCardHolderHint,
                      enabled: !isInProgress,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      textAlign: TextAlign.start,
                      validator: (value) => _requiredValidator(
                        value,
                        AppStrings.subscriptionsPaymentCardHolderHint,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: AppInputField(
                            controller: _expiryMonthController,
                            labelText: AppStrings.subscriptionsPaymentExpiryLabel,
                            hintText: AppStrings.subscriptionsPaymentExpiryMonthHint,
                            enabled: !isInProgress,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(2),
                            ],
                            validator: _expiryMonthValidator,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppInputField(
                            controller: _expiryYearController,
                            labelText: AppStrings.subscriptionsPaymentYearLabel,
                            semanticsLabel: AppStrings.subscriptionsPaymentYearLabel,
                            hintText: AppStrings.subscriptionsPaymentExpiryYearHint,
                            enabled: !isInProgress,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            showLabel: false,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                            ],
                            validator: _expiryYearValidator,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppInputField(
                            controller: _cvvController,
                            labelText: AppStrings.subscriptionsPaymentCvvLabel,
                            hintText: AppStrings.subscriptionsPaymentCvvHint,
                            enabled: !isInProgress,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(3),
                            ],
                            validator: _cvvValidator,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _RememberDataRow(
                      value: _rememberData,
                      enabled: !isInProgress,
                      onChanged: () => setState(() => _rememberData = !_rememberData),
                    ),
                    const SizedBox(height: 36),
                    MainButton(
                      state: isInProgress ? ButtonState.loading : ButtonState.enabled,
                      onPressed: _submit,
                      child: Text(
                        '${AppStrings.subscriptionsPaymentPayButton} '
                        '${SubscriptionCard.formatPrice(widget.item.price)}₽',
                      ),
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
              left: 24,
              right: 24,
              top: 24,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    colors: [
                      colorTheme.primary,
                      colorTheme.secondary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorTheme.onSurface.withValues(alpha: 0.12),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 51, 24, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorTheme.onPrimary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: AppInputField(
                          controller: _previewCardNumberController,
                          labelText: AppStrings.subscriptionsPaymentCardNumberLabel,
                          semanticsLabel: AppStrings.subscriptionsPaymentCardNumberLabel,
                          hintText: AppStrings.subscriptionsPaymentCardNumberHint,
                          enabled: false,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          showLabel: false,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppStrings.subscriptionsPaymentCardHolderLabel,
                                  style: textTheme.label.copyWith(color: colorTheme.onPrimary),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  _cardHolderController.text.isEmpty
                                      ? AppStrings.subscriptionsPaymentCardHolderHint
                                      : _cardHolderController.text,
                                  style: textTheme.label.copyWith(color: colorTheme.onPrimary),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppStrings.subscriptionsPaymentPreviewExpiryLabel,
                                  style: textTheme.label.copyWith(color: colorTheme.onPrimary),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  [
                                    _expiryMonthController.text.trim(),
                                    _expiryYearController.text.trim(),
                                  ].where((value) => value.isNotEmpty).join('/').ifEmpty(
                                        '${AppStrings.subscriptionsPaymentExpiryMonthHint}/'
                                        '${AppStrings.subscriptionsPaymentExpiryYearHint}',
                                      ),
                                  style: textTheme.label.copyWith(color: colorTheme.onPrimary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

final class _RememberDataRow extends StatelessWidget {
  final bool value;
  final bool enabled;
  final VoidCallback onChanged;

  const _RememberDataRow({
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    final textTheme = AppTextTheme.of(context);
    return Row(
      children: [
        Semantics(
          label: AppStrings.subscriptionsPaymentRememberData,
          checked: value,
          enabled: enabled,
          onTap: enabled ? onChanged : null,
          child: InkWell(
            onTap: enabled ? onChanged : null,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 16,
              height: 16,
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: value ? colorTheme.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(3),
                border: Border.all(
                  color: value ? colorTheme.primary : colorTheme.outline,
                ),
              ),
              child: value
                  ? Icon(
                      Icons.check_rounded,
                      size: 12,
                      color: colorTheme.onPrimary,
                    )
                  : null,
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          AppStrings.subscriptionsPaymentRememberData,
          style: textTheme.bodySmall.copyWith(
            fontSize: 10,
            height: 15 / 10,
            fontWeight: FontWeight.w400,
            color: colorTheme.onSurface,
          ),
        ),
      ],
    );
  }
}

extension on String {
  String ifEmpty(String fallback) => isEmpty ? fallback : this;
}
