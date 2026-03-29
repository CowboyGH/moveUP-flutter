import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/router/router_paths.dart';
import '../../../../../uikit/buttons/main_button.dart';
import '../../../../../uikit/images/app_decorative_figure.dart';
import '../../../../../uikit/inputs/app_search_field.dart';
import '../../../../../uikit/menus/app_selection_dropdown.dart';
import '../../../../../uikit/themes/colors/app_color_theme.dart';
import '../../../../../uikit/themes/text/app_text_theme.dart';
import '../../domain/entities/testing_catalog_item.dart';
import '../../domain/entities/testing_category.dart';
import '../cubits/tests_catalog_cubit.dart';
import '../widgets/testing_catalog_card.dart';
import '../widgets/tests_catalog_filter_button.dart';

/// Authenticated tests catalog page shown in the root tab shell.
class TestsCatalogPage extends StatefulWidget {
  /// Creates an instance of [TestsCatalogPage].
  const TestsCatalogPage({super.key});

  @override
  State<TestsCatalogPage> createState() => _TestsCatalogPageState();
}

class _TestsCatalogPageState extends State<TestsCatalogPage> {
  final _searchController = TextEditingController();
  final _filterLayerLink = LayerLink();
  final _filterTapRegionGroupId = Object();
  final Set<int> _selectedCategoryIds = <int>{};

  bool _isFilterOpen = false;

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

  void _toggleFilter() => setState(() => _isFilterOpen = !_isFilterOpen);

  void _closeFilter() {
    if (!_isFilterOpen) return;
    setState(() => _isFilterOpen = false);
  }

  List<TestingCategory> _extractCategories(List<TestingCatalogItem> items) {
    final categories = <TestingCategory>[];
    final seenIds = <int>{};

    for (final item in items) {
      for (final category in item.categories) {
        if (seenIds.add(category.id)) {
          categories.add(category);
        }
      }
    }
    categories.sort((left, right) => left.name.toLowerCase().compareTo(right.name.toLowerCase()));
    return categories;
  }

  List<AppSelectionDropdownItem<int>> _buildCategoryItems(List<TestingCategory> categories) {
    return categories
        .map(
          (category) => AppSelectionDropdownItem<int>(
            value: category.id,
            label: category.name,
          ),
        )
        .toList(growable: false);
  }

  List<TestingCatalogItem> _filterItems(List<TestingCatalogItem> items) {
    final itemsByCategory = _selectedCategoryIds.isEmpty
        ? items
        : items
              .where((item) {
                return item.categories.any(
                  (category) => _selectedCategoryIds.contains(category.id),
                );
              })
              .toList(growable: false);

    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return itemsByCategory;

    return itemsByCategory
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
          AppStrings.testsCatalogTitle,
          style: textTheme.appBarTitle,
        ),
      ),
      body: BlocBuilder<TestsCatalogCubit, TestsCatalogState>(
        builder: (context, state) {
          final allItems = state.maybeWhen(
            loaded: (items) => items,
            orElse: () => const <TestingCatalogItem>[],
          );
          final categories = _extractCategories(allItems);
          final categoryItems = _buildCategoryItems(categories);

          if (_isFilterOpen && categories.isEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _closeFilter();
            });
          }

          return Stack(
            children: [
              const Positioned(
                right: -65,
                bottom: 55,
                child: AppDecorativeFigure(tone: FigureTone.primary),
              ),
              CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
                    sliver: SliverList.list(
                      children: [
                        Text(
                          AppStrings.testsCatalogDescription,
                          textAlign: TextAlign.center,
                          style: textTheme.bodyMedium.copyWith(
                            fontWeight: FontWeight.w500,
                            color: colorTheme.darkHint,
                          ),
                        ),
                        const SizedBox(height: 20),
                        AppSearchField(
                          controller: _searchController,
                          hintText: AppStrings.testsCatalogSearchHint,
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TapRegion(
                            groupId: _filterTapRegionGroupId,
                            onTapOutside: (_) => _closeFilter(),
                            child: CompositedTransformTarget(
                              link: _filterLayerLink,
                              child: TestsCatalogFilterButton(
                                onPressed: categories.isEmpty ? null : _toggleFilter,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                  ..._buildStateSlivers(
                    context,
                    state,
                    fullItems: allItems,
                    filteredItems: _filterItems(allItems),
                  ),
                ],
              ),
              if (_isFilterOpen && categories.isNotEmpty)
                CompositedTransformFollower(
                  link: _filterLayerLink,
                  showWhenUnlinked: false,
                  targetAnchor: Alignment.bottomLeft,
                  offset: const Offset(0, 2),
                  child: TapRegion(
                    groupId: _filterTapRegionGroupId,
                    onTapOutside: (_) => _closeFilter(),
                    child: AppSelectionDropdown<int>(
                      items: categoryItems,
                      selectedValues: _selectedCategoryIds,
                      onChanged: (selectedValues) {
                        setState(
                          () => _selectedCategoryIds
                            ..clear()
                            ..addAll(selectedValues),
                        );
                      },
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildStateSlivers(
    BuildContext context,
    TestsCatalogState state, {
    required List<TestingCatalogItem> fullItems,
    required List<TestingCatalogItem> filteredItems,
  }) {
    return state.when(
      initial: () => const <Widget>[SliverToBoxAdapter(child: SizedBox.shrink())],
      inProgress: () => <Widget>[_buildBoxStateSliver(_buildLoadingState())],
      loaded: (_) => _buildLoadedStateSlivers(
        context,
        fullItems: fullItems,
        filteredItems: filteredItems,
      ),
      failed: (_) => <Widget>[_buildBoxStateSliver(_buildRetryState(context))],
    );
  }

  Widget _buildBoxStateSliver(Widget child) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 132),
      sliver: SliverToBoxAdapter(child: child),
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

  List<Widget> _buildLoadedStateSlivers(
    BuildContext context, {
    required List<TestingCatalogItem> fullItems,
    required List<TestingCatalogItem> filteredItems,
  }) {
    if (fullItems.isEmpty) {
      return const [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(24, 0, 24, 132),
          sliver: SliverToBoxAdapter(
            child: Center(
              child: Text(
                AppStrings.testsEmpty,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ];
    }

    if (filteredItems.isEmpty) {
      return const [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(24, 0, 24, 132),
          sliver: SliverToBoxAdapter(
            child: Center(
              child: Text(
                AppStrings.testsSearchEmpty,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ];
    }

    return [
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 132),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final item = filteredItems[index];
            return Padding(
              padding: EdgeInsets.only(bottom: index == filteredItems.length - 1 ? 0 : 20),
              child: TestingCatalogCard(
                item: item,
                onPressed: () => context.push(AppRoutePaths.testsAttemptDetailsPath(item.id)),
              ),
            );
          }, childCount: filteredItems.length),
        ),
      ),
    ];
  }

  Widget _buildRetryState(BuildContext context) {
    final textTheme = AppTextTheme.of(context);
    final colorTheme = AppColorTheme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppStrings.testsLoadFailed,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium.copyWith(color: colorTheme.onSurface),
          ),
          const SizedBox(height: 24),
          MainButton(
            onPressed: context.read<TestsCatalogCubit>().loadTestings,
            child: const Text(AppStrings.retryButton),
          ),
        ],
      ),
    );
  }
}
