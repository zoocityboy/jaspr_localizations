# Jaspr Localizations

[![Pub Version](https://img.shields.io/pub/v/jaspr_localizations?style=flat-square)](https://pub.dev/packages/jaspr_localizations)
[![License](https://img.shields.io/badge/License-MIT-blue?style=flat-square)](LICENSE)
[![Dart](https://img.shields.io/badge/Dart-3.9+-blue?style=flat-square&logo=dart)](https://dart.dev)
[![Jaspr](https://img.shields.io/badge/Jaspr-0.21+-orange?style=flat-square)](https://docs.page/schultek/jaspr)

Internationalization and localization support for Jaspr applications with ARB file generation and Flutter-like APIs.

> [!NOTE]
> Jaspr Localizations brings Flutter's proven localization patterns to Jaspr web applications, making it easy to build multilingual web experiences.

## Overview

Jaspr Localizations provides a comprehensive solution for internationalizing Jaspr applications. It combines the power of ARB (Application Resource Bundle) files with automatic code generation to deliver type-safe, efficient localization that follows Flutter's established patterns.

The package leverages Jaspr's InheritedComponent pattern for optimal performance and provides a familiar API for developers coming from Flutter while being perfectly optimized for web applications.

## Features

- **Type-Safe Localization**: Compile-time safety with generated Dart classes
- **ARB File Support**: Industry-standard format compatible with Flutter tooling
- **Automatic Code Generation**: Build-time generation of localization classes
- **InheritedComponent Pattern**: Efficient state management using Jaspr's architecture
- **ICU MessageFormat**: Support for plurals, selects, and complex formatting
- **Locale Management**: Comprehensive locale switching and validation
- **Performance Optimized**: Minimal runtime overhead and efficient updates
- **Flutter-Compatible**: Easy migration path for Flutter developers

## Getting started

### Prerequisites

- Dart SDK 3.9.0 or later
- Jaspr 0.21.6 or later

### Installation

Add `jaspr_localizations` to your `pubspec.yaml`:

```yaml
dependencies:
  jaspr_localizations: ^1.0.0

dev_dependencies:
  build_runner: ^2.4.0
```

### Quick Setup

Configure localization in your `pubspec.yaml`:

```yaml
jaspr_localizations:
  arb-dir: lib/l10n
  template-arb-file: app_en.arb
  output-localization-file: lib/generated/l10n.dart
  output-class: L10n
```

## Basic Usage

### 1. Create ARB Files

Create your localization files in `lib/l10n/`:

**lib/l10n/app_en.arb**:

```json
{
  "@@locale": "en",
  "appTitle": "My Application",
  "welcomeMessage": "Welcome to {appName}!",
  "@welcomeMessage": {
    "placeholders": {
      "appName": {"type": "String"}
    }
  }
}
```

**lib/l10n/app_es.arb**:

```json
{
  "@@locale": "es", 
  "appTitle": "Mi Aplicación",
  "welcomeMessage": "¡Bienvenido a {appName}!"
}
```

### 2. Generate Localization Code

Run the code generator:

```bash
dart run build_runner build
```

### 3. Set Up Your App

Wrap your application with localization providers:

```dart
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_localizations/jaspr_localizations.dart';
import 'generated/l10n.dart';

class App extends StatelessComponent {
  @override
  Component build(BuildContext context) {
    return LocalizationApp(
      supportedLocales: L10nDelegate.supportedLocales,
      initialLocale: L10nDelegate.supportedLocales.first,
      delegates: const [L10nDelegate()],
      builder: (context, locale) => div([
        // Your app content here
        const HomePage(),
      ]),
    );
  }
}
```

### 4. Use Localizations in Components

Access localized strings in your components:

```dart
class HomePage extends StatelessComponent {
  @override
  Component build(BuildContext context) {
    final l10n = L10n.from(LocaleProvider.of(context).currentLocale.toLanguageTag());
    
    return div([
      h1([text(l10n.appTitle)]),
      p([text(l10n.welcomeMessage('Jaspr'))]),
    ]);
  }
}
```

## Advanced Features

### Dynamic Locale Switching

Create interactive language switchers:

```dart
class LanguageSwitcher extends StatelessComponent {
  @override
  Component build(BuildContext context) {
    final provider = LocaleProvider.of(context);
    final currentLocale = provider.currentLocale;
    
    return div([
      ...provider.supportedLocales.map((locale) {
        final isActive = currentLocale == locale;
        return button(
          classes: isActive ? 'active' : '',
          onClick: () => LocaleProvider.setLocale(context, locale),
          [text(_getLanguageName(locale))],
        );
      }),
    ]);
  }
}
```

### ICU MessageFormat Support

Handle complex localization scenarios with plurals and selects:

```json
{
  "itemCount": "{count, plural, =0{No items} =1{One item} other{{count} items}}",
  "genderMessage": "{gender, select, male{He likes Jaspr} female{She likes Jaspr} other{They like Jaspr}}"
}
```

### Custom Locale Management

For advanced use cases, create your own locale controller:

```dart
class CustomApp extends StatefulComponent {
  @override
  State<CustomApp> createState() => _CustomAppState();
}

class _CustomAppState extends State<CustomApp> {
  late LocaleController _controller;

  @override
  void initState() {
    super.initState();
    _controller = LocaleController(
      initialLocale: const Locale('en'),
      supportedLocales: [
        const Locale('en'),
        const Locale('es'),
        const Locale('fr'),
      ],
    );
  }

  @override
  Component build(BuildContext context) {
    return LocaleProvider.withController(
      controller: _controller,
      child: LocaleBuilder(
        controller: _controller,
        builder: (context, locale) => MyAppContent(),
      ),
    );
  }
}
```

## Configuration Options

### ARB Directory Structure

Organize your localization files:

```
```text
lib/
  l10n/
    app_en.arb    # Template file (required)
    app_es.arb    # Spanish translations
    app_fr.arb    # French translations
    app_de.arb    # German translations
  generated/
    l10n.dart     # Generated code (auto-created)
```
```

### Pubspec Configuration

Full configuration options:

```yaml
jaspr_localizations:
  enabled: true                                    # Enable/disable generation
  arb-dir: lib/l10n                               # ARB files directory
  template-arb-file: app_en.arb                   # Template ARB file
  output-localization-file: lib/generated/l10n.dart  # Output file path
  output-class: L10n                              # Generated class name
```

## ICU MessageFormat Reference

### Pluralization

Handle different plural forms across languages:

```json
{
  "itemCount": "{count, plural, =0{No items} =1{One item} other{{count} items}}",
  "@itemCount": {
    "placeholders": {
      "count": {"type": "num"}
    }
  }
}
```

**Supported plural forms:**

- **Exact values**: `=0`, `=1`, `=2`, etc. - Match specific numbers
- **Named forms**: `zero`, `one`, `two`, `few`, `many`, `other`
- **Required**: The `other` form is always required as a fallback

### Selection

Create conditional messages based on variables:

```json
{
  "genderMessage": "{gender, select, male{He codes} female{She codes} other{They code}}",
  "@genderMessage": {
    "placeholders": {
      "gender": {"type": "String"}
    }
  }
}
```

### Number and Date Formatting

Use type-safe placeholders for formatted values:

```json
{
  "priceDisplay": "Price: {amount}",
  "lastUpdated": "Updated: {date}",
  "@priceDisplay": {
    "placeholders": {
      "amount": {"type": "num", "format": "currency"}
    }
  },
  "@lastUpdated": {
    "placeholders": {
      "date": {"type": "DateTime"}
    }
  }
}
```

## Migration Guide

### From String-based Localization

If you're migrating from a string-based localization system:

1. Replace string locale identifiers with `Locale` objects
2. Update provider access patterns
3. Migrate to ARB files for better tooling support

```dart
// Before
final locale = 'en_US';
final provider = LocaleProvider.of(context);

// After  
final locale = const Locale('en', 'US');
final provider = LocaleProvider.of(context);
final localeString = provider.currentLocale.toLanguageTag();
```

### From Flutter Localizations

Jaspr Localizations uses nearly identical APIs to Flutter:

1. ARB files are compatible
2. Generated classes follow the same patterns
3. Delegate pattern is preserved

## Performance Considerations

### Build-time Generation

- Localizations are generated at build time for zero runtime overhead
- Type safety prevents common localization errors
- Dead code elimination removes unused translations

### Runtime Efficiency

- InheritedComponent pattern ensures minimal rebuilds
- Locale changes only affect dependent components
- Optimized string interpolation and formatting

### Best Practices

```dart
// ✅ Good: Cache localization instance
class MyComponent extends StatelessComponent {
  @override
  Component build(BuildContext context) {
    final l10n = L10n.from(LocaleProvider.of(context).currentLocale.toLanguageTag());
    return div([
      h1([text(l10n.title)]),
      p([text(l10n.description)]),
    ]);
  }
}

// ❌ Avoid: Multiple provider lookups
class BadComponent extends StatelessComponent {
  @override
  Component build(BuildContext context) {
    return div([
      h1([text(L10n.from(LocaleProvider.of(context).currentLocale.toLanguageTag()).title)]),
      p([text(L10n.from(LocaleProvider.of(context).currentLocale.toLanguageTag()).description)]),
    ]);
  }
}
```

## API Documentation

### Core Classes

#### `Locale`

Represents a locale with language and optional country code.

```dart
const locale = Locale('en', 'US');
final tag = locale.toLanguageTag(); // 'en_US'
```

#### `LocaleProvider`

InheritedComponent for providing locale context.

```dart
LocaleProvider.of(context);        // Get provider (throws if not found)
LocaleProvider.maybeOf(context);   // Get provider (returns null if not found)
LocaleProvider.setLocale(context, locale); // Change locale
```

#### `LocaleController`

Manages locale state and notifications.

```dart
final controller = LocaleController(
  initialLocale: const Locale('en'),
  supportedLocales: [const Locale('en'), const Locale('es')],
);
controller.setLocale(const Locale('es'));
controller.nextLocale(); // Cycle to next supported locale
```

### Generated Classes

#### Localization Delegate

```dart
class L10nDelegate extends LocalizationsDelegate<L10n> {
  static const List<Locale> supportedLocales = [...];
  bool isSupported(Locale locale) => ...;
  Future<L10n> load(Locale locale) async => ...;
}
```

#### Localization Class

```dart
abstract class L10n {
  static L10n from(String locale) => ...;
  String get appTitle;
  String welcomeMessage(String name);
}
```

## Troubleshooting

### Common Issues

**Build generation fails:**

```bash
# Clean and rebuild
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

**Locale not found errors:**

- Verify ARB files exist for all supported locales
- Check locale codes match between ARB files and code
- Ensure template ARB file is specified correctly

**Missing translations:**

- All ARB files must contain the same message keys
- Template ARB file defines the complete message set
- Run build_runner after adding new messages

### Performance Issues

If you experience slow locale switching:

- Use `LocaleBuilder` for targeted rebuilds
- Avoid frequent locale changes
- Consider caching heavy localization computations

## Resources

- [Jaspr Documentation](https://docs.page/schultek/jaspr)
- [Flutter Internationalization](https://docs.flutter.dev/development/accessibility-and-localization/internationalization)
- [ICU MessageFormat Guide](http://userguide.icu-project.org/formatparse/messages)
- [ARB File Specification](https://github.com/google/app-resource-bundle)

## Example Projects

Check out the `/example` directory for a complete working example showing:

- Multi-language support (8 languages)
- Dynamic locale switching
- Complex ICU MessageFormat usage
- Performance optimizations

## Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Development Setup

1. Fork the repository
2. Clone your fork: `git clone <your-fork-url>`
3. Install dependencies: `dart pub get`
4. Run tests: `dart test`
5. Make your changes and submit a pull request

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a detailed history of changes.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

**Example:**

```json
{
  "itemCount": "{count, plural, =0{No items} =1{1 item} other{{count} items}}",
  "@itemCount": {
    "description": "Number of items with proper pluralization",
    "placeholders": {
      "count": {
        "type": "num"
      }
    }
  }
}
```

**Generated code:**

```dart
String itemCount(num count) {
  switch (count) {
    case 0:
      return 'No items';
    case 1:
      return '1 item';
    default:
      return '$count items';
  }
}
```

**Usage:**

```dart
final l10n = AppLocalizations.of(locale);
print(l10n.itemCount(0));  // "No items"
print(l10n.itemCount(1));  // "1 item"
print(l10n.itemCount(5));  // "5 items"
```

**Complex plural example (many languages):**

```json
{
  "@@locale": "pl",
  "itemCount": "{count, plural, =0{Brak elementów} one{1 element} few{{count} elementy} many{{count} elementów} other{{count} elementów}}",
  "@itemCount": {
    "placeholders": {
      "count": {
        "type": "num"
      }
    }
  }
}
```

### Select Messages

Use select messages for gender, choices, or any categorical selection.

**Syntax:** `{variable, select, choice1{message1} choice2{message2} other{default}}`

**Required**: The `other` form is always required as a fallback.

**Example:**

```json
{
  "genderMessage": "{gender, select, male{He likes Flutter} female{She likes Flutter} other{They like Flutter}}",
  "@genderMessage": {
    "description": "Gender-specific message",
    "placeholders": {
      "gender": {
        "type": "String"
      }
    }
  }
}
```

**Generated code:**

```dart
String genderMessage(String gender) {
  switch (gender) {
    case 'male':
      return 'He likes Flutter';
    case 'female':
      return 'She likes Flutter';
    default:
      return 'They like Flutter';
  }
}
```

**Usage:**

```dart
final l10n = AppLocalizations.of(locale);
print(l10n.genderMessage('male'));    // "He likes Flutter"
print(l10n.genderMessage('female'));  // "She likes Flutter"
print(l10n.genderMessage('other'));   // "They like Flutter"
```

**Multi-language select example:**

```json
{
  "@@locale": "es",
  "genderMessage": "{gender, select, male{A él le gusta Flutter} female{A ella le gusta Flutter} other{A ellos les gusta Flutter}}"
}
```

```json
{
  "@@locale": "fr",
  "genderMessage": "{gender, select, male{Il aime Flutter} female{Elle aime Flutter} other{Ils aiment Flutter}}"
}
```

### ICU MessageFormat Guidelines

1. **Always include the 'other' form** in plural and select messages
2. **Use exact values (`=0`, `=1`)** for common cases like "no items" and "1 item"
3. **Use appropriate placeholder types**: `num` for plurals, `String` for select
4. **Test with multiple languages** to ensure proper pluralization rules
5. **Keep messages simple** - avoid nesting plural/select in most cases
6. **Use descriptive keys** - e.g., `itemCount` not `msg1`
7. **Add descriptions** to all messages for context

### Common Patterns

**Items in a cart:**

```json
{
  "cartItems": "{count, plural, =0{Your cart is empty} =1{1 item in cart} other{{count} items in cart}}",
  "@cartItems": {
    "placeholders": {
      "count": {
        "type": "num"
      }
    }
  }
}
```

**User greeting with name and gender:**

```json
{
  "greeting": "Hello {name}, {gender, select, male{welcome back sir} female{welcome back madam} other{welcome back}}!",
  "@greeting": {
    "placeholders": {
      "name": {
        "type": "String"
      },
      "gender": {
        "type": "String"
      }
    }
  }
}
```

## LocalizationsDelegate Pattern

jaspr_localizations generates a LocalizationsDelegate class similar to Flutter's flutter_localizations.

### Using the Generated Delegate

The code generator creates a delegate class that can be used to load localizations:

```dart
import 'package:jaspr_localizations/jaspr_localizations.dart';
import 'l10n/app_localizations.g.dart';

// Use the delegate to check if a locale is supported
final delegate = const AppLocalizationsDelegate();

// Check if locale is supported
if (delegate.isSupported(Locale('es'))) {
  print('Spanish is supported!');
}

// Load localizations for a locale
final localizations = await delegate.load(Locale('es'));
print(localizations.appTitle); // "Mi Aplicación"
```

### Delegate with DelegatedLocalizations

You can use the `DelegatedLocalizations` InheritedComponent to manage multiple localization delegates:

```dart
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_localizations/jaspr_localizations.dart';
import 'generated/app_localizations.g.dart';

class MyApp extends StatelessComponent {
  @override
  Component build(BuildContext context) {
    return LocaleProvider(
      locale: const Locale('en'),
      delegates: const [
        AppLocalizationsDelegate(),
        // Add more delegates here if needed
      ],
      child: const HomePage(),
    );
  }
}

// Access localizations in descendant components
class HomePage extends StatelessComponent {
  @override
  Component build(BuildContext context) {
    // Use the Flutter-like API with BuildContext
    final l10n = AppLocalizations.of(context);
    
    return div([
      h1([text(l10n.appTitle)]),
      p([text(l10n.itemCount(5))]),
    ]);
  }
}
```

### Generated Delegate API

The generated `AppLocalizationsDelegate` class extends `LocalizationsDelegate<AppLocalizations>` and provides:

**Static Properties:**

- `static const List<Locale> supportedLocales`: List of all supported locales from ARB files

**Methods:**

- `bool isSupported(Locale locale)`: Returns true if the locale is supported
- `Future<AppLocalizations> load(Locale locale)`: Loads and returns the localizations for the given locale
- `bool shouldReload(AppLocalizationsDelegate old)`: Returns false (localizations don't need reloading)

**Example generated delegate:**

```dart
class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();
  
  // Automatically includes all locales from ARB files
  static const List<Locale> supportedLocales = [
    Locale.fromLanguageTag('en'),
    Locale.fromLanguageTag('es'),
    Locale.fromLanguageTag('fr'),
  ];

  @override
  bool isSupported(Locale locale) {
    return ['en', 'es', 'fr'].contains(locale.toLanguageTag());
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return _lookup(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
```

### API Reference

### Locale

Represents a locale with language code and optional country code.

**Constructor:**

```dart
const Locale(String languageCode, [String? countryCode])
```

**Factory Constructor:**

```dart
factory Locale.fromLanguageTag(String tag)
```

**Properties:****

- `languageCode`: The primary language subtag (e.g., 'en', 'es', 'fr')
- `countryCode`: The region subtag (e.g., 'US', 'GB', 'FR') - optional

**Methods:**

- `toLanguageTag()`: Returns the locale identifier (e.g., 'en_US' or 'en')
- `toString()`: Same as `toLanguageTag()`

### LocaleProvider

An `InheritedComponent` that provides locale information to descendant components.

**Constructor:**

```dart
LocaleProvider({
  required Locale locale,
  required Set<Locale> supportedLocales,
  required Component child,
  Key? key,
})
```

**Static Methods:**

- `LocaleProvider.of(BuildContext context)`: Returns the nearest `LocaleProvider` instance. Throws an assertion error if not found.
- `LocaleProvider.maybeOf(BuildContext context)`: Returns the nearest `LocaleProvider` instance or `null` if not found.

**Properties:**

- `locale`: The current `Locale` object
- `supportedLocales`: A `Set<Locale>` of all supported locales in the application

## Additional information

This package follows the InheritedComponent pattern recommended for Jaspr applications. The `of()` method uses assertions instead of throwing `FlutterError` for a cleaner Jaspr-specific implementation.

For issues, feature requests, or contributions, please visit the [GitHub repository](https://github.com/zoocityboy/devbox).

