
![Jaspr Localizations](https://raw.githubusercontent.com/zoocityboy/jaspr_localizations/refs/heads/feat/language_switcher/docs/jaspr_localizations.png "Resource")

** Made by 🦏 [zoocityboy](https://zoocityboy.github.io/) with ❤️ for the Jaspr community **


[![Pub Version](https://img.shields.io/pub/v/jaspr_localizations?style=flat-square)](https://pub.dev/packages/jaspr_localizations)
[![License](https://img.shields.io/badge/License-MIT-blue?style=flat-square)](LICENSE)
[![Dart](https://img.shields.io/badge/Dart-3.9+-blue?style=flat-square&logo=dart)](https://dart.dev)
[![Jaspr](https://img.shields.io/badge/Jaspr-0.21+-orange?style=flat-square)](https://docs.page/schultek/jaspr)



# Jaspr Localizations

Internationalization and localization support for Jaspr applications with ARB file generation and Flutter-like APIs.

## Features

- 🔒 **Type-Safe Localization** - Compile-time safety with generated Dart classes
- 📦 **ARB File Support** - Industry-standard format compatible with Flutter
- 🌐 **Platform-Aware Detection** - Automatic language detection from browser/system
- 🔄 **Dynamic Locale Switching** - Runtime locale changes with automatic UI rebuilding
- 📝 **ICU MessageFormat** - Support for plurals, selects, and complex formatting
- ⚡ **Performance Optimized** - Minimal runtime overhead using InheritedComponent

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  jaspr_localizations: ^1.0.0

dev_dependencies:
  build_runner: ^2.4.0
```

Install dependencies:

```bash
dart pub get
```

## Quick Start

### 1. Configure Localization

Create `l10n.yaml` in your project root:

```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: generated/l10n.dart
output-class: AppLocalizations
```

### 2. Create ARB Files

Create translation files in `lib/l10n/`:

**lib/l10n/app_en.arb**:
```json
{
  "@@locale": "en",
  "appTitle": "My Application",
  "welcomeMessage": "Welcome, {name}!",
  "@welcomeMessage": {
    "placeholders": {
      "name": {"type": "String"}
    }
  }
}
```

**lib/l10n/app_es.arb**:
```json
{
  "@@locale": "es",
  "appTitle": "Mi Aplicación",
  "welcomeMessage": "¡Bienvenido, {name}!"
}
```

### 3. Generate Code

```bash
dart run build_runner build
```

## Usage

### Basic Setup

Wrap your app with `JasprLocalizations`:

```dart
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_localizations/jaspr_localizations.dart';
import 'generated/l10n.dart';

class App extends StatelessComponent {
  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield JasprLocalizations(
      supportedLocales: [
        Locale('en', 'US'),
        Locale('es', 'ES'),
        Locale('fr', 'FR'),
      ],
      initialLocale: getCurrentLocale(), // Auto-detect user's language
      delegates: [AppLocalizations.delegate],
      builder: (context, locale) => HomePage(),
    );
  }
}
```

### Accessing Translations

Use the generated localization class:

```dart
class HomePage extends StatelessComponent {
  @override
  Iterable<Component> build(BuildContext context) sync* {
    final l10n = AppLocalizations.of(context);
    
    yield div([
      h1([text(l10n.appTitle)]),
      p([text(l10n.welcomeMessage('Jaspr'))]),
    ]);
  }
}
```

### Changing Locale

Create a language switcher:

```dart
class LanguageSwitcher extends StatelessComponent {
  @override
  Iterable<Component> build(BuildContext context) sync* {
    final provider = JasprLocalizationProvider.of(context);
    final currentLocale = provider.currentLocale;
    
    for (final locale in provider.supportedLocales) {
      yield button(
        classes: currentLocale == locale ? 'active' : '',
        onClick: () => JasprLocalizationProvider.setLocale(context, locale),
        [text(locale.languageCode.toUpperCase())],
      );
    }
  }
}
```

## Locale Override with `withLocale`

The `JasprLocalizations.withLocale` method allows you to display specific content in a different locale without changing the app's global locale.

### Use Cases

- **Previews** - Show content in multiple languages simultaneously
- **Side-by-side translations** - Compare translations
- **Testing** - Verify translations without app-wide changes

### Example: Multi-Language Preview

```dart
class LanguagePreview extends StatelessComponent {
  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield div([
      h2([text('Preview in Multiple Languages')]),
      
      // English
      div([
        h3([text('English')]),
        JasprLocalizations.withLocale(
          locale: Locale('en', 'US'),
          child: WelcomeMessage(),
        ),
      ]),
      
      // Spanish
      div([
        h3([text('Spanish')]),
        JasprLocalizations.withLocale(
          locale: Locale('es', 'ES'),
          child: WelcomeMessage(),
        ),
      ]),
      
      // French
      div([
        h3([text('French')]),
        JasprLocalizations.withLocale(
          locale: Locale('fr', 'FR'),
          child: WelcomeMessage(),
        ),
      ]),
    ]);
  }
}

class WelcomeMessage extends StatelessComponent {
  @override
  Iterable<Component> build(BuildContext context) sync* {
    final l10n = AppLocalizations.of(context);
    yield p([text(l10n.welcomeMessage('User'))]);
  }
}
```

### Example: Side-by-Side Translation

```dart
class TranslationComparison extends StatelessComponent {
  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield div([
      // Current language
      div([
        h4([text('Current')]),
        ProductDescription(),
      ]),
      
      // Preview in another language
      div([
        h4([text('Translation')]),
        JasprLocalizations.withLocale(
          locale: Locale('es', 'ES'),
          child: ProductDescription(),
        ),
      ]),
    ]);
  }
}
```

**Important**: The overridden locale must be in the `supportedLocales` list.

## Platform-Aware Detection

Automatically detect user's language:

```dart
// Get current locale
final locale = getCurrentLocale();

// Use in app
JasprLocalizations(
  initialLocale: getCurrentLocale(),
  ...
)
```

Detection sources:
- **Browser**: `navigator.language`
- **Server**: `Intl.getCurrentLocale()`
- **Fallback**: `'en'`

## ICU MessageFormat

### Pluralization

```json
{
  "itemCount": "{count, plural, =0{No items} =1{One item} other{{count} items}}"
}
```

```dart
l10n.itemCount(0);  // "No items"
l10n.itemCount(1);  // "One item"
l10n.itemCount(5);  // "5 items"
```

### Select Messages

```json
{
  "greeting": "{gender, select, male{Mr.} female{Ms.} other{}} Hello"
}
```

```dart
l10n.greeting('male');    // "Mr. Hello"
l10n.greeting('female');  // "Ms. Hello"
```

## Troubleshooting

**Build fails:**
```bash
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

**Translations missing:**
- All ARB files must have the same keys
- Run `build_runner` after changes

**Locale not changing:**
- Use `JasprLocalizations`, not just `JasprLocalizationProvider`
- Verify locale is in `supportedLocales`

## Resources

- [Jaspr Documentation](https://docs.page/schultek/jaspr)
- [Flutter i18n Guide](https://docs.flutter.dev/ui/internationalization)
- [ICU MessageFormat](http://userguide.icu-project.org/formatparse/messages)
- [ARB Specification](https://github.com/google/app-resource-bundle)

## License

MIT License - see [LICENSE](LICENSE)


