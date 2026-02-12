## 1.0.0-beta.4
- Feature: DateTime placeholder formatting in generator
- Build: localization builder ordering to avoid import failures
- Fix: SSR Intl initialization (avoids LocaleDataException)
- UX: small layout/style adjustments; “Flutter” -> “Jaspr” wording in examples
- Example: DateTime ARB entries and regenerated example localization

## 1.0.0

- Initial version with InheritedComponent-based LocaleProvider
- **Features**:
  - Added `Locale` class with `languageCode` and optional `countryCode`
  - `Locale.fromLanguageTag()` factory for parsing language tags
  - Support for `Set<Locale>` in `supportedLocales` property
  - `updateShouldNotify` tracks both locale and supportedLocales changes
  - **ARB File Support**: Industry-standard Application Resource Bundle format
  - **Code Generation**: Automatic generation of type-safe localization classes
  - **l10n.yaml Configuration**: Similar to flutter_localizations setup
  - **Build Runner Integration**: Generate localization code with `dart run build_runner build`
  - **Placeholder Support**: Type-safe placeholders in messages (String, int, double, DateTime)
- **Breaking Changes**:
  - `LocaleProvider.of()` now returns `LocaleProvider` instance instead of `String`
  - `locale` property is now a `Locale` object instead of `String`
  - `supportedLocales` is now `Set<Locale>` instead of `Set<String>`
  - Use `locale.toLanguageTag()` to get the string representation
  - Removed `FlutterError` in favor of assertions for cleaner Jaspr implementation
- Added comprehensive tests for Locale and LocaleProvider functionality
- Updated documentation and examples with ARB file generation guide
