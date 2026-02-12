# Tech Context

## Technologies
- **Language**: Dart (SDK >= 3.0.0)
- **Framework**: Jaspr (Web-focused Dart framework)
- **Build System**: `build_runner`
- **Libraries**:
  - `intl`: For pluralization, date/number formatting.
  - `universal_web`: For browser API access (navigator.languages).
  - `yaml`: For parsing config.

## Development Setup
- **Build Command**: `dart run build_runner build --delete-conflicting-outputs`
- **Watch Command**: `dart run build_runner watch`
- **Configuration**: Uses `build.yaml` or `l10n.yaml` metadata to control generation.

## Dependencies
- `jaspr`
- `intl`
- `build`
- `source_gen` (dev)
