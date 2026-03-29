import 'package:flutter/material.dart';

import '../themes/colors/app_color_theme.dart';
import '../themes/text/app_text_theme.dart';

/// Selection behavior supported by [AppSelectionDropdown].
enum AppSelectionDropdownMode {
  /// Allows selecting at most one item at a time.
  single,

  /// Allows selecting multiple items at a time.
  multiple,
}

/// Item shown inside [AppSelectionDropdown].
final class AppSelectionDropdownItem<T extends Object> {
  /// Item identifier.
  final T value;

  /// Item label.
  final String label;

  /// Creates an instance of [AppSelectionDropdownItem].
  const AppSelectionDropdownItem({
    required this.value,
    required this.label,
  });
}

/// Shared dropdown menu with single-select and multi-select modes.
class AppSelectionDropdown<T extends Object> extends StatelessWidget {
  /// Items displayed inside the dropdown.
  final List<AppSelectionDropdownItem<T>> items;

  /// Currently selected values.
  final Set<T> selectedValues;

  /// Selection mode.
  final AppSelectionDropdownMode mode;

  /// Callback fired when selection changes.
  final ValueChanged<Set<T>> onChanged;

  /// Layout constraints for the dropdown surface.
  final BoxConstraints constraints;

  /// Creates an instance of [AppSelectionDropdown].
  const AppSelectionDropdown({
    required this.items,
    required this.selectedValues,
    required this.onChanged,
    this.mode = AppSelectionDropdownMode.multiple,
    this.constraints = const BoxConstraints(maxHeight: 302, maxWidth: 261),
    super.key,
  });

  void _toggleValue(T value) {
    final nextValues = Set<T>.of(selectedValues);
    if (nextValues.contains(value)) {
      if (mode == AppSelectionDropdownMode.single) return;

      nextValues.remove(value);
      onChanged(nextValues);
      return;
    }

    switch (mode) {
      case AppSelectionDropdownMode.single:
        onChanged({value});
      case AppSelectionDropdownMode.multiple:
        nextValues.add(value);
        onChanged(nextValues);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    final textTheme = AppTextTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorTheme.outline),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: ConstrainedBox(
          constraints: constraints,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final isSelected = selectedValues.contains(item.value);
              return Padding(
                padding: EdgeInsets.only(bottom: index == items.length - 1 ? 0 : 2),
                child: Semantics(
                  container: true,
                  button: true,
                  selected: isSelected,
                  label: item.label,
                  child: InkWell(
                    onTap: () => _toggleValue(item.value),
                    borderRadius: BorderRadius.circular(10),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colorTheme.primary.withValues(alpha: 0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                        child: Row(
                          children: [
                            Expanded(
                              child: ExcludeSemantics(
                                child: Text(
                                  item.label,
                                  maxLines: 1,
                                  style: textTheme.body.copyWith(
                                    color: colorTheme.hint,
                                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                            if (isSelected)
                              ExcludeSemantics(
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: colorTheme.primary,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: colorTheme.primary,
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: const SizedBox.square(dimension: 10),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
