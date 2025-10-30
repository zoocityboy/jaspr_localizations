# Jaspr Localizations

A comprehensive localization package for Jaspr applications with ARB file support and code generation.

## Features

- 🌍 **Locale Object**: Uses a dedicated `Locale` class instead of strings for better type safety
- 🔄 **InheritedComponent Pattern**: Uses Jaspr's InheritedComponent for efficient updates
- ✅ **Type-Safe**: Access locale information with compile-time safety
- 🎯 **Lightweight**: Minimal dependencies and overhead
- 🌐 **Supported Locales**: Track multiple supported locales in your application
- 📝 **ARB File Support**: Industry-standard format for localization (same as Flutter)
- 🔨 **Code Generation**: Automatic generation of type-safe localization classes from ARB files
- 🚀 **Easy Integration**: Similar to flutter_localizations configuration

## Getting started

Add `jaspr_localizations` to your `pubspec.yaml`:

```yaml
dependencies:
  jaspr_localizations: ^1.0.0

dev_dependencies:
  build_runner: ^2.4.0
```

## Usage

### Basic Setup (Flutter-like API)

Wrap your app with `LocaleProvider` and provide localization delegates:

```dart
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_localizations/jaspr_localizations.dart';
import 'generated/app_localizations.g.dart';

class MyApp extends StatelessComponent {
  @override
  Component build(BuildContext context) {
    return LocaleProvider(
      locale: const Locale('en', 'US'),
      delegates: const [AppLocalizationsDelegate()],
      child: HomePage(),
    );
  }
}
```

The delegates automatically provide supported locales - no need to manually specify them!

### Access Localizations Using BuildContext

In your components, access localizations using the Flutter-like `of(BuildContext)` pattern:

```dart
class HomePage extends StatelessComponent {
  @override
  Component build(BuildContext context) {
    // Get localized strings using BuildContext (recommended)
    final l10n = AppLocalizations.of(context);
    
    return div([
      h1([text(l10n.appTitle)]),
      p([text(l10n.welcomeMessage('Jaspr'))]),
    ]);
  }
}
```

### Alternative: Direct Locale Access

If you need to access localizations without a BuildContext (e.g., in business logic):

```dart
// Direct locale-based access
final l10n = AppLocalizations.forLocale(const Locale('en'));
print(l10n.appTitle);
```

### Access Locale Information

```dart
class HomePage extends StatelessComponent {
  @override
  Component build(BuildContext context) {
    // Get the LocaleProvider instance
    final provider = LocaleProvider.of(context);
    final locale = provider.locale;

    return div([
      h1([text('Current Locale: ${locale.toLanguageTag()}')]),
      p([text('Language: ${locale.languageCode}')]),
      p([text('Country: ${locale.countryCode ?? "None"}')]),
    ]);
  }
}
```

### Use maybeOf for nullable access

```dart
class MyComponent extends StatelessComponent {
  @override
  Component build(BuildContext context) {
    // Returns null if no LocaleProvider is found
    final provider = LocaleProvider.maybeOf(context);
    final locale = provider?.locale ?? const Locale('en');

    return div([text('Locale: ${locale.toLanguageTag()}')]);
  }
}
```

### Creating Locale objects

```dart
// Language only
const locale1 = Locale('en');

// Language and country
const locale2 = Locale('en', 'US');

// From language tag
final locale3 = Locale.fromLanguageTag('en_US');
final locale4 = Locale.fromLanguageTag('fr');
```

## ARB File Localization (Code Generation)

The package supports automatic code generation from ARB (Application Resource Bundle) files, similar to Flutter's `gen_l10n`.

### 1. Configure in pubspec.yaml

Add the `jaspr_localizations` configuration to your `pubspec.yaml`:

```yaml
jaspr_localizations:
  arb-dir: lib/l10n
  template-arb-file: app_en.arb
  output-localization-file: generated/app_localizations.g.dart
  output-class: AppLocalizations
```

**Configuration Options:**

- `arb-dir`: Directory containing ARB files (default: `lib/l10n`)
- `template-arb-file`: Template ARB file name (default: `app_en.arb`)
- `output-localization-file`: Generated file path (default: `l10n/AppLocalizations.g.dart`)
- `output-class`: Generated class name (default: `AppLocalizations`)

### 2. Create ARB files

Create ARB files in `lib/l10n/`:

**lib/l10n/app_en.arb:**

```json
{
  "@@locale": "en",
  "appTitle": "My Application",
  "@appTitle": {
    "description": "The title of the application"
  },
  "welcomeMessage": "Welcome to {appName}!",
  "@welcomeMessage": {
    "description": "Welcome message with placeholder",
    "placeholders": {
      "appName": {
        "type": "String"
      }
    }
  }
}
```

**lib/l10n/app_es.arb:**

```json
{
  "@@locale": "es",
  "appTitle": "Mi Aplicación",
  "@appTitle": {
    "description": "El título de la aplicación"
  },
  "welcomeMessage": "¡Bienvenido a {appName}!",
  "@welcomeMessage": {
    "description": "Mensaje de bienvenida con placeholder",
    "placeholders": {
      "appName": {
        "type": "String"
      }
    }
  }
}
```

### 3. Generate localization code

Run the build runner to generate Dart code:

```bash
dart run build_runner build
```

This generates `lib/l10n/AppLocalizations.g.dart` with type-safe localization classes.

### 4. Use generated localizations

```dart
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_localizations/jaspr_localizations.dart';
import 'generated/app_localizations.g.dart';

class MyApp extends StatelessComponent {
  @override
  Component build(BuildContext context) {
    return LocaleProvider(
      locale: const Locale('en'),
      delegates: const [AppLocalizationsDelegate()],
      child: const HomePage(),
    );
  }
}

class HomePage extends StatelessComponent {
  @override
  Component build(BuildContext context) {
    // Access localizations using BuildContext
    final l10n = AppLocalizations.of(context);
    
    return div([
      h1([text(l10n.appTitle)]),
      p([text(l10n.welcomeMessage('Jaspr'))]),
    ]);
  }
}
```

### ARB File Format

- **Message Keys**: Simple string keys (e.g., `"appTitle"`)
- **Metadata Keys**: Prefixed with `@` (e.g., `"@appTitle"`)
- **Placeholders**: Use `{placeholderName}` in messages
- **Placeholder Types**: Supported types are `String`, `int`, `num`, `DateTime`

Example with placeholders:

```json
{
  "itemCount": "You have {count} items",
  "@itemCount": {
    "description": "Shows number of items",
    "placeholders": {
      "count": {
        "type": "int",
        "example": "5"
      }
    }
  }
}
```

Generated method:

```dart
String itemCount(int count) => 'You have $count items';
```

## ICU MessageFormat Support

jaspr_localizations supports ICU MessageFormat syntax for advanced localization features:

### Plural Messages

Use plural forms to handle different quantities correctly in different languages.

**Syntax:** `{variable, plural, form1{message1} form2{message2} ...}`

**Supported plural forms:**
- **Exact values**: `=0`, `=1`, `=2`, etc. - Match specific numbers
- **Named forms**: `zero`, `one`, `two`, `few`, `many`, `other`
- **Required**: The `other` form is always required as a fallback

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

### Best Practices

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

