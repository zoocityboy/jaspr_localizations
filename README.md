# Jaspr Localizations

![Jaspr Localizations](https://raw.githubusercontent.com/zoocityboy/jaspr_localizations/refs/heads/feat/language_switcher/docs/jaspr_localizations.png "Resource")


[![Pub Version](https://img.shields.io/pub/v/jaspr_localizations?style=flat-square)](https://pub.dev/packages/jaspr_localizations)
[![License](https://img.shields.io/badge/License-MIT-blue?style=flat-square)](LICENSE)
[![Dart](https://img.shields.io/badge/Dart-3.9+-blue?style=flat-square&logo=dart)](https://dart.dev)
[![Jaspr](https://img.shields.io/badge/Jaspr-0.21+-orange?style=flat-square)](https://docs.page/schultek/jaspr)

Internationalization and localization support for Jaspr applications with ARB file generation and Flutter-like APIs.

> [!NOTE]
> Jaspr Localizations brings Flutter's proven localization patterns to Jaspr web applications, making it easy to build multilingual web experiences with automatic platform-aware language detection.

## Overview

Jaspr Localizations provides a comprehensive solution for internationalizing Jaspr applications. It combines the power of ARB (Application Resource Bundle) files with automatic code generation to deliver type-safe, efficient localization that follows Flutter's established patterns.

The package leverages Jaspr's InheritedComponent pattern for optimal performance and provides a familiar API for developers coming from Flutter while being perfectly optimized for web applications.

## ✨ Features

- **🔒 Type-Safe Localization**: Compile-time safety with generated Dart classes
- **📦 ARB File Support**: Industry-standard format compatible with Flutter tooling
- **⚡ Automatic Code Generation**: Build-time generation of localization classes
- **🌐 Platform-Aware Detection**: Automatic language detection from browser (client) or system (server)
- **🔄 Dynamic Locale Switching**: Runtime locale changes with automatic UI rebuilding
- **🧩 InheritedComponent Pattern**: Efficient state management using Jaspr's architecture
- **📝 ICU MessageFormat**: Support for plurals, selects, and complex formatting
- **🎯 Locale Management**: Comprehensive locale switching and validation
- **⚡ Performance Optimized**: Minimal runtime overhead and efficient updates
- **🔄 Flutter-Compatible**: Easy migration path for Flutter developers

## 🚀 Getting Started

### Prerequisites

- Dart SDK **3.9.0** or later
- Jaspr **0.21.6** or later

### Installation

Add `jaspr_localizations` to your `pubspec.yaml`:

```yaml
dependencies:
  jaspr_localizations: ^1.0.0

dev_dependencies:
  build_runner: ^2.4.0
```

Then run:

```bash
dart pub get
```

### Quick Setup

1. **Configure localization** in your `l10n.yaml`:

```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: generated/l10n.dart
output-class: AppLocalizations
```

2. **Create ARB files** in `lib/l10n/`:

```
lib/l10n/
  ├── app_en.arb  # Template file (required)
  ├── app_es.arb  # Spanish translations
  ├── app_fr.arb  # French translations
  └── app_de.arb  # German translations
```

3. **Run code generation**:

```bash
dart run build_runner build
```

## 📖 Basic Usage

### 1. Create ARB Files

Create your localization files in `lib/l10n/`:

**lib/l10n/app_en.arb** (Template):

```json
{
  "@@locale": "en",
  "appTitle": "My Application",
  "welcomeMessage": "Welcome to {appName}!",
  "@welcomeMessage": {
    "description": "Welcome message with app name",
    "placeholders": {
      "appName": {
        "type": "String"
      }
    }
  },
  "itemCount": "{count, plural, =0{No items} =1{One item} other{{count} items}}",
  "@itemCount": {
    "description": "Number of items with pluralization",
    "placeholders": {
      "count": {
        "type": "num"
      }
    }
  }
}
```

**lib/l10n/app_es.arb** (Spanish):

```json
{
  "@@locale": "es",
  "appTitle": "Mi Aplicación",
  "welcomeMessage": "¡Bienvenido a {appName}!",
  "itemCount": "{count, plural, =0{Sin elementos} =1{Un elemento} other{{count} elementos}}"
}
```

### 2. Generate Localization Code

Run the build system to generate type-safe localization classes:

```bash
dart run build_runner build

# Or for continuous generation during development
dart run build_runner watch
```

### 3. Set Up Your App

Wrap your application with `JasprLocalizations`:

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
      initialLocale: Locale('en', 'US'), // Or use getCurrentLocale() for auto-detection
      delegates: [AppLocalizations.delegate],
      builder: (context, locale) {
        return HomePage();
      },
    );
  }
}
```

### 4. Use Localizations in Components

Access localized strings in your components:

```dart
class HomePage extends StatelessComponent {
  @override
  Iterable<Component> build(BuildContext context) sync* {
    final l10n = AppLocalizations.of(context);
    
    yield div([
      h1([text(l10n.appTitle)]),
      p([text(l10n.welcomeMessage('Jaspr'))]),
      p([text(l10n.itemCount(5))]), // "5 items" or "5 elementos"
    ]);
  }
}
```

### 5. Change Locale at Runtime

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
        [text('${locale.languageCode.toUpperCase()}')],
      );
    }
  }
}
```

## 🌐 Platform-Aware Language Detection

Jaspr Localizations automatically detects the user's preferred language from the browser (client-side) or system (server-side):

```dart
import 'package:jaspr_localizations/jaspr_localizations.dart';

void main() {
  // Automatically detect user's language
  final userLocale = getCurrentLocale();
  
  runApp(
    JasprLocalizations(
      supportedLocales: [
        Locale('en', 'US'),
        Locale('es', 'ES'),
        Locale('fr', 'FR'),
      ],
      initialLocale: userLocale, // Use detected locale
      delegates: [AppLocalizations.delegate],
      builder: (context, locale) => MyApp(),
    ),
  );
}
```

### Detection Utilities

```dart
// Get language code (e.g., 'en-US', 'es', 'fr-FR')
final languageCode = getCurrentLanguageCode();

// Get Locale object
final locale = getCurrentLocale();

// Convert language code to Locale
final locale = languageCodeToLocale('en-US'); // Locale('en', 'US')
final locale2 = languageCodeToLocale('es');   // Locale('es')
```

### How It Works

- **Client-side (Web)**: Reads `navigator.language` or `navigator.languages[0]`
- **Server-side (SSR)**: Reads `Intl.getCurrentLocale()` from system environment
- **Fallback**: Defaults to `'en'` if detection fails

- **Fallback**: Defaults to `'en'` if detection fails

## 🎯 Advanced Features

### ICU MessageFormat Support

Handle complex localization scenarios with plurals and selects:

#### Pluralization

Different languages have different plural rules. ICU MessageFormat handles them automatically:

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
- `=0`, `=1`, `=2` - Exact values
- `zero`, `one`, `two`, `few`, `many`, `other` - Named forms
- `other` is **required** as fallback

**Usage:**
```dart
final l10n = AppLocalizations.of(context);
print(l10n.itemCount(0));  // "No items"
print(l10n.itemCount(1));  // "One item"
print(l10n.itemCount(5));  // "5 items"
```

#### Select Messages

Create conditional messages based on categories:

```json
{
  "genderMessage": "{gender, select, male{He likes Jaspr} female{She likes Jaspr} other{They like Jaspr}}",
  "@genderMessage": {
    "placeholders": {
      "gender": {"type": "String"}
    }
  }
}
```

**Usage:**
```dart
final l10n = AppLocalizations.of(context);
print(l10n.genderMessage('male'));    // "He likes Jaspr"
print(l10n.genderMessage('female'));  // "She likes Jaspr"
print(l10n.genderMessage('other'));   // "They like Jaspr"
```

### Custom Locale Management

For advanced use cases, manually control the locale:

```dart
class CustomApp extends StatefulComponent {
  @override
  State<CustomApp> createState() => _CustomAppState();
}

class _CustomAppState extends State<CustomApp> {
  late LocaleChangeNotifier _controller;

  @override
  void initState() {
    super.initState();
    _controller = LocaleChangeNotifier(
      initialLocale: Locale('en'),
      supportedLocales: [
        Locale('en'),
        Locale('es'),
        Locale('fr'),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    return JasprLocalizationProvider.withController(
      controller: _controller,
      delegates: [AppLocalizations.delegate],
      child: JasprLocaleBuilder(
        controller: _controller,
        builder: (context, locale) => MyAppContent(),
      ),
    );
  }
}
```

### Scoped Locale Override

Display specific content in a different locale:

```dart
// Main app in English
JasprLocalizations(
  initialLocale: Locale('en'),
  supportedLocales: [Locale('en'), Locale('es'), Locale('fr')],
  delegates: [AppLocalizations.delegate],
  builder: (context, locale) {
    return div([
      h1([text('English Content')]),
      
      // Preview in Spanish
      JasprLocalizations.withLocale(
        locale: Locale('es'),
        child: PreviewWidget(),
      ),
    ]);
  },
)
```

## 📁 Configuration Options

### l10n.yaml Configuration

Full configuration options for ARB processing:

```yaml
# Required: Directory containing ARB files
arb-dir: lib/l10n

# Required: Template ARB file (defines all message keys)
template-arb-file: app_en.arb

# Required: Output file path for generated code
output-localization-file: generated/l10n.dart

# Required: Generated class name
output-class: AppLocalizations

# Optional: Use synthetic package for imports (default: true)
synthetic-package: true

# Optional: Nullable getter (default: true)
nullable-getter: true

# Optional: Generate toString method (default: true)
gen-l10n-dart-doc: true
```

### Directory Structure

Recommended project structure:

```
my_jaspr_app/
├── lib/
│   ├── l10n/
│   │   ├── app_en.arb      # English (template)
│   │   ├── app_es.arb      # Spanish
│   │   ├── app_fr.arb      # French
│   │   ├── app_de.arb      # German
│   │   └── app_zh.arb      # Chinese
│   ├── generated/
│   │   └── l10n.dart       # Auto-generated (don't edit)
│   ├── components/
│   │   └── language_switcher.dart
│   └── main.dart
├── l10n.yaml               # Localization config
├── pubspec.yaml
└── README.md
```

## 📚 API Reference

### Core Classes

#### `Locale`

Represents a locale with language and optional country code.

```dart
// Constructor
const Locale(String languageCode, [String? countryCode, String? scriptCode]);

// Factory
Locale.fromLanguageTag(String tag);
Locale.fromSubtags({
  required String languageCode,
  String? scriptCode,
  String? countryCode,
});

// Properties
String languageCode;  // e.g., 'en', 'es', 'zh'
String? countryCode;  // e.g., 'US', 'GB', 'CN'
String? scriptCode;   // e.g., 'Hans', 'Latn'

// Methods
String toLanguageTag(); // Returns 'en_US' or 'en'
```

**Examples:**
```dart
const enUS = Locale('en', 'US');
const es = Locale('es');
const zhHans = Locale('zh', 'CN', 'Hans');

final locale = Locale.fromLanguageTag('en_US');
print(locale.toLanguageTag()); // 'en_US'
```

#### `JasprLocalizations`

High-level component with automatic rebuilding on locale changes.

```dart
JasprLocalizations({
  required List<Locale> supportedLocales,
  Locale? initialLocale,
  List<LocalizationsDelegate> delegates = const [],
  required Component Function(BuildContext, Locale) builder,
  Key? key,
})

// Factory for scoped locale override
JasprLocalizations.withLocale({
  required Locale locale,
  required Component child,
  Key? key,
})
```

**Properties:**
- `supportedLocales` - List of all supported locales
- `initialLocale` - Starting locale (defaults to first supported)
- `delegates` - Localization delegates for loading resources
- `builder` - Function to build UI with current locale

#### `JasprLocalizationProvider`

Low-level InheritedComponent for locale state management.

```dart
// Static methods
static JasprLocalizationProvider of(BuildContext context);
static JasprLocalizationProvider? maybeOf(BuildContext context);
static LocaleChangeNotifier? controllerOf(BuildContext context);
static void setLocale(BuildContext context, Locale newLocale);
static void setLanguage(BuildContext context, String languageCode, [String? countryCode]);

// Properties
Locale currentLocale;
Iterable<Locale> supportedLocales;
List<LocalizationsDelegate> delegates;
LocaleChangeNotifier? controller;
```

**Examples:**
```dart
// Get provider
final provider = JasprLocalizationProvider.of(context);
final locale = provider.currentLocale;

// Change locale
JasprLocalizationProvider.setLocale(context, Locale('es'));
JasprLocalizationProvider.setLanguage(context, 'fr', 'FR');
```

#### `LocaleChangeNotifier`

Controller for managing locale state with change notifications.

```dart
LocaleChangeNotifier({
  required Locale initialLocale,
  required List<Locale> supportedLocales,
})

// Methods
void setLocale(Locale newLocale);
void setLanguage(String languageCode, [String? countryCode]);
void nextLocale(); // Cycle to next supported locale

// Properties
Locale currentLocale;
List<Locale> supportedLocales;
```

### Utility Functions

#### Language Detection

```dart
// Get current language code from browser/platform
String getCurrentLanguageCode();
// Returns: 'en-US', 'es', 'fr-FR', etc.

// Get current locale object
Locale getCurrentLocale();
// Returns: Locale('en', 'US'), etc.

// Convert language code to Locale
Locale languageCodeToLocale(String languageCode);
// Examples:
//   'en' → Locale('en')
//   'en-US' → Locale('en', 'US')
//   'zh-Hans-CN' → Locale('zh', 'CN')
```

### Generated Classes

The build system generates these classes from your ARB files:

#### AppLocalizations (your generated class)

```dart
abstract class AppLocalizations {
  // Access localizations
  static AppLocalizations of(BuildContext context);
  
  // All your message getters
  String get appTitle;
  String welcomeMessage(String name);
  String itemCount(num count);
  // ... etc.
}
```

#### AppLocalizationsDelegate

```dart
class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();
  
  static const List<Locale> supportedLocales = [...];
  
  bool isSupported(Locale locale);
  Future<AppLocalizations> load(Locale locale);
  bool shouldReload(covariant AppLocalizationsDelegate old);
}
```

## 🎨 Complete Example

Here's a complete working example:

```dart
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_localizations/jaspr_localizations.dart';
import 'generated/l10n.dart';

void main() {
  runApp(App());
}

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

class HomePage extends StatelessComponent {
  @override
  Iterable<Component> build(BuildContext context) sync* {
    final l10n = AppLocalizations.of(context);
    
    yield div([
      LanguageSwitcher(),
      h1([text(l10n.appTitle)]),
      p([text(l10n.welcomeMessage('Jaspr'))]),
      p([text(l10n.itemCount(5))]),
    ]);
  }
}

class LanguageSwitcher extends StatelessComponent {
  @override
  Iterable<Component> build(BuildContext context) sync* {
    final provider = JasprLocalizationProvider.of(context);
    final currentLocale = provider.currentLocale;
    
    yield div(
      classes: 'language-switcher',
      [
        for (final locale in provider.supportedLocales)
          button(
            classes: currentLocale == locale ? 'active' : '',
            onClick: () => JasprLocalizationProvider.setLocale(context, locale),
            [text(locale.languageCode.toUpperCase())],
          ),
      ],
    );
  }
}
```

## 🔧 Troubleshooting

### Common Issues

## 🔧 Troubleshooting

### Common Issues

**Build generation fails:**

```bash
# Clean build cache and regenerate
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

**Locale not found errors:**

- ✅ Verify ARB files exist for all supported locales
- ✅ Check locale codes match between ARB files and code
- ✅ Ensure template ARB file (`app_en.arb`) exists
- ✅ Confirm `l10n.yaml` configuration is correct

**Missing translations:**

- ✅ All ARB files must contain the same message keys
- ✅ Template ARB file defines the complete message set
- ✅ Run `build_runner` after adding new messages
- ✅ Check for typos in message keys

**`dart:isolate` errors in web builds:**

This occurs when generated code conditionally imports `dart:isolate`. To fix:

```dart
// Remove @client annotation from components using l10n
// OR restructure to avoid client-specific code
```

**Locale doesn't change:**

- ✅ Ensure you're using `JasprLocalizations` (not just `JasprLocalizationProvider`)
- ✅ Verify the new locale is in `supportedLocales`
- ✅ Check that components depend on the provider (using `.of(context)`)

### Performance Issues

If you experience slow locale switching:

- Use `JasprLocaleBuilder` for targeted rebuilds
- Avoid frequent locale changes (debounce user input)
- Cache localization instances in component builds
- Profile with Dart DevTools to identify bottlenecks

## 📦 Example Projects

Check out the `/example` directory for complete working examples:

- ✨ **Multi-language support** - 8+ languages (English, Spanish, French, German, Chinese, Czech, Polish, Slovak)
- 🔄 **Dynamic locale switching** - Interactive language selector
- 🌐 **Platform-aware detection** - Auto-detects user's preferred language
- 📝 **ICU MessageFormat** - Plurals, selects, and complex formatting
- ⚡ **Performance optimizations** - Best practices demonstrated

Run the example:

```bash
cd example
dart run build_runner build
jaspr serve
```

## 🤝 Contributing

We welcome contributions! Here's how you can help:

### Reporting Issues

- 🐛 **Bug reports**: Include minimal reproduction steps
- 💡 **Feature requests**: Describe the use case and expected behavior
- 📚 **Documentation**: Suggest improvements or fix typos

### Development Setup

1. **Fork and clone** the repository:
   ```bash
   git clone https://github.com/YOUR_USERNAME/jaspr_localizations.git
   cd jaspr_localizations
   ```

2. **Install dependencies**:
   ```bash
   dart pub get
   ```

3. **Run tests**:
   ```bash
   dart test
   ```

4. **Make changes** and submit a pull request

### Guidelines

- ✅ Follow Dart style guide and use `dart format`
- ✅ Add tests for new features
- ✅ Update documentation for API changes
- ✅ Keep commits atomic and well-described
- ✅ Ensure all tests pass before submitting PR

## 📝 Changelog

See [CHANGELOG.md](CHANGELOG.md) for detailed release history.

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

## 🔗 Resources

- 📖 [Jaspr Documentation](https://docs.page/schultek/jaspr)
- 📖 [Flutter Internationalization Guide](https://docs.flutter.dev/development/accessibility-and-localization/internationalization)
- 📖 [ICU MessageFormat Guide](http://userguide.icu-project.org/formatparse/messages)
- 📖 [ARB File Specification](https://github.com/google/app-resource-bundle)
- 💬 [GitHub Discussions](https://github.com/zoocityboy/jaspr_localizations/discussions)
- 🐛 [Issue Tracker](https://github.com/zoocityboy/jaspr_localizations/issues)

## 🙏 Acknowledgments

- Built on top of the excellent [Jaspr](https://github.com/schultek/jaspr) framework
- Inspired by Flutter's internationalization system
- Uses the industry-standard [intl](https://pub.dev/packages/intl) package

---

<p align="center">
  <strong>Made with ❤️ for the Jaspr community</strong><br>
  If you find this package helpful, please give it a ⭐ on GitHub!
</p>

