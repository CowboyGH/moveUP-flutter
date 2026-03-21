import 'package:flutter/material.dart';

import '../../../../../uikit/cards/app_card.dart';
import '../../../../../uikit/images/network_image_widget.dart';
import '../../../../../uikit/themes/colors/app_color_theme.dart';
import '../../../../../uikit/themes/text/app_text_theme.dart';
import '../../domain/entities/testing_catalog_item.dart';
import 'testing_category_chip.dart';

/// Card widget for a tests catalog item.
class TestingCatalogCard extends StatelessWidget {
  /// Catalog item displayed inside the card.
  final TestingCatalogItem item;

  /// Creates an instance of [TestingCatalogCard].
  const TestingCatalogCard({
    required this.item,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextTheme.of(context);
    final colorTheme = AppColorTheme.of(context);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: NetworkImageWidget(
                  imageUrl: item.imageUrl,
                  height: constraints.maxWidth,
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Text(
            item.title,
            textAlign: TextAlign.end,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodyMedium.copyWith(
              fontSize: 16,
              height: 24 / 16,
              fontWeight: FontWeight.w500,
              color: colorTheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '(${item.durationMinutes} минут)',
            textAlign: TextAlign.end,
            style: textTheme.bodyMedium.copyWith(color: colorTheme.onSurface),
          ),
          const SizedBox(height: 20),
          Wrap(
            alignment: WrapAlignment.end,
            spacing: 6,
            runSpacing: 8,
            children: item.categories
                .map((category) => TestingCategoryChip(label: category.name))
                .toList(growable: false),
          ),
          const SizedBox(height: 16),
          Text(
            item.description,
            textAlign: TextAlign.right,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: textTheme.body.copyWith(color: colorTheme.hint),
          ),
        ],
      ),
    );
  }
}
