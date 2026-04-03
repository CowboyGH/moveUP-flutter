import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../uikit/cards/app_card.dart';
import '../../../../uikit/images/network_image_widget.dart';
import '../../../../uikit/themes/colors/app_color_theme.dart';
import '../../../../uikit/themes/text/app_text_theme.dart';
import '../../domain/entities/subscription_catalog_item.dart';

/// Visual card for a single subscriptions catalog item.
class SubscriptionCard extends StatelessWidget {
  /// Catalog item displayed by this card.
  final SubscriptionCatalogItem item;

  /// Optional tap callback for opening the subscription details screen.
  final VoidCallback? onPressed;

  /// Creates an instance of [SubscriptionCard].
  const SubscriptionCard({
    required this.item,
    this.onPressed,
    super.key,
  });

  static const double _cardHeight = 276;

  /// Formats a backend price string for subscriptions UI.
  static String formatPrice(String value) {
    final normalized = value.trim().replaceAll(',', '.');
    if (normalized.endsWith('.00')) {
      return normalized.substring(0, normalized.length - 3);
    }
    return normalized.replaceAll('.', ',');
  }

  static ({String value, String unit}) _buildPeriodParts(String name) {
    final match = RegExp(r'^\s*(\d+)\s+(.+?)\s*$').firstMatch(name);
    if (match != null) {
      return (
        value: match.group(1)!,
        unit: match.group(2)!,
      );
    }
    return (
      value: name.trim(),
      unit: '',
    );
  }

  static const List<String> _benefits = [
    AppStrings.subscriptionsCatalogBenefitTests,
    AppStrings.subscriptionsCatalogBenefitExercises,
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextTheme.of(context);
    final colorTheme = AppColorTheme.of(context);
    final period = _buildPeriodParts(item.name);
    final content = SizedBox(
      height: 306,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: AppCard(
              height: _cardHeight,
              contentPadding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '${formatPrice(item.price)} ${AppStrings.subscriptionsCatalogRubles}',
                    style: textTheme.bodyMedium.copyWith(
                      fontSize: 16,
                      height: 24 / 16,
                      fontWeight: FontWeight.w600,
                      color: colorTheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _benefits
                        .map(
                          (benefit) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '•',
                                  style: textTheme.body.copyWith(
                                    color: colorTheme.onSurface,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    benefit,
                                    style: textTheme.body.copyWith(
                                      color: colorTheme.onSurface,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 20,
            top: 0,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: period.value,
                    style: textTheme.bodyMedium.copyWith(
                      fontSize: 96,
                      height: 0.85,
                      fontWeight: FontWeight.w100,
                      color: colorTheme.darkHint,
                    ),
                  ),
                  TextSpan(
                    text: period.unit.isEmpty ? '' : ' ${period.unit}',
                    style: textTheme.bodyMedium.copyWith(
                      fontSize: 20,
                      height: 30 / 20,
                      fontWeight: FontWeight.w300,
                      color: colorTheme.darkHint,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: NetworkImageWidget(
              imageUrl: item.imageUrl,
              height: 230,
            ),
          ),
        ],
      ),
    );
    if (onPressed == null) {
      return content;
    }
    return Semantics(
      button: true,
      child: Material(
        color: Colors.transparent,
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onPressed,
          child: content,
        ),
      ),
    );
  }
}
