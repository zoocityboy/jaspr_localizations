# System Patterns

## Architecture
- **Code Generation**: Uses `build_runner` and a custom generator (`JasprL10nGenerator`) to parse `.arb` files and create Dart classes.
- **Component System**: Integrates with Jaspr's component tree.
  - `JasprLocalizations`: The root component (likely InheritedComponent logic) that holds the state.
  - `JasprLocaleBuilder`: A widget/component that rebuilds when locale changes.
- **Delegate Pattern**: Follows a pattern similar to `LocalizationsDelegate` to load resources, adapted for Jaspr.

## Key Components
- `JasprLocalizations`: The main entry point for setup in `App`.
- `generated/app_l10n.dart`: The generated code containing the `AppLocalizations` class.
- `.arb` files: The source of truth for translations (JSON-based).

## Conventions
- ARB files are typically placed in `lib/l10n/` or `example/lib/l10n/`.
- Generated files are output to `lib/generated/` or similar.
