import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/testing_catalog_item.dart';
import 'testing_carousel_indicator.dart';
import 'testing_catalog_card.dart';

/// Carousel widget for tests catalog items.
class TestingCatalogCarousel extends StatefulWidget {
  /// Catalog items displayed in the carousel.
  final List<TestingCatalogItem> items;

  /// Creates an instance of [TestingCatalogCarousel].
  const TestingCatalogCarousel({
    required this.items,
    super.key,
  });

  @override
  State<TestingCatalogCarousel> createState() => _TestingCatalogCarouselState();
}

class _TestingCatalogCarouselState extends State<TestingCatalogCarousel> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CarouselSlider.builder(
              itemCount: widget.items.length,
              itemBuilder: (context, index, _) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  child: TestingCatalogCard(item: widget.items[index]),
                );
              },
              options: CarouselOptions(
                height: constraints.maxWidth + 250,
                viewportFraction: 1,
                enableInfiniteScroll: false,
                onPageChanged: (index, _) => setState(() => _currentPage = index),
              ),
            ),
            const SizedBox(height: 10),
            TestingCarouselIndicator(
              itemCount: widget.items.length,
              currentIndex: _currentPage,
            ),
          ],
        );
      },
    );
  }
}
