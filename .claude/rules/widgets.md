---
paths:
  - "lib/**/*_page.dart"
  - "lib/**/*_widget.dart"
  - "lib/**/presentation/**/*.dart"
  - "lib/uikit/**/*.dart"
---

# Widget rules

## Naming
- Screens are `_page.dart` in `lib/features/<feature>/presentation/pages/` (this repo does **not** use `_screen.dart`).
- Reusable widgets local to a feature: `lib/features/<feature>/presentation/widgets/<name>_widget.dart`.
- Cross-feature reusable widgets / design-system: `lib/uikit/<category>/` (`buttons/`, `dialogs/`, `inputs/`, `cards/`, `images/`, `menus/`, `themes/`).
- A page that needs DI/BlocProvider wiring uses a separate `<name>_page_builder.dart` next to the page (see `sign_up_page_builder.dart`, `verify_reset_code_page_builder.dart`).
- Route argument holders live next to the page: `<name>_route_args.dart`.

## Widget construction
- `StatelessWidget` by default. Use `StatefulWidget` only for local-only state that can't live in a cubit (focus nodes, controllers, animations).
- `const` constructors everywhere possible — analyzer warns on `prefer_const_constructors` / `prefer_const_literals_to_create_immutables`.
- Use `super.key` (`use_super_parameters` lint enforced).
- Constructor params: named, `required` for non-nullable, no positional booleans (`avoid_positional_boolean_parameters`).
- Single quotes for strings (`prefer_single_quotes`).
- Imports inside `lib/` are relative (`prefer_relative_imports`).
- Every public member needs a dartdoc (`///`) — `public_member_api_docs` is enabled.
- `flutter_hooks` is **not** a dependency — do not use hooks.

## Composition
- If a sub-widget is used in only one place, make it a private `class _Foo extends StatelessWidget` in the same file.
- Split `build()` when it exceeds ~100 lines into private sub-widgets or factory methods.
- Wire cubits with `BlocProvider` / `BlocBuilder` / `BlocListener` / `BlocConsumer`. Read repositories from `di<T>()` (get_it) inside the page builder, not inside `build()`.
- Do not pass `BuildContext` through fields. Do not capture it across `await` without an `if (!context.mounted) return;` check.

## Navigation
- Use `context.go(...)` / `context.push(...)` / `context.pop()` only. Route paths come from `AppRoutePaths` in `lib/core/router/router_paths.dart`.
- New routes go through `lib/core/router/router.dart` — do not call `Navigator` directly.

## Theming / assets
- Colors, gradients, text styles live under `lib/uikit/themes/`. Don't hardcode `Color(0x...)` or `TextStyle(...)` in feature widgets.
- Image assets via `flutter_svg` (`SvgPicture.asset`) or `cached_network_image` for network. Asset paths come from `lib/core/constants/`.
