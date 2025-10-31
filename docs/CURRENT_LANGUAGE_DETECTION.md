# Current Language Detection

This document explains how to use the automatic language detection features in `jaspr_localizations`.

## Overview

The package provides functions to automatically detect the user's preferred language based on whether the code is running on the client (browser) or server (platform).

## Functions

### `getCurrentLanguageCode()`

Returns the current language code as a string.

**Behavior:**
- **On client (browser):** Retrieves the language from `navigator.language` or the first item in `navigator.languages`
- **On server:** Uses `Intl.getCurrentLocale()` to get the system locale
- **Fallback:** Returns `'en'` if detection fails

**Returns:** A language code string (e.g., `'en-US'`, `'es'`, `'fr-FR'`)

**Example:**
```dart
import 'package:jaspr_localizations/jaspr_localizations.dart';

void example() {
  final languageCode = getCurrentLanguageCode();
  print('Current language: $languageCode');
  // Output: "Current language: en-US" (or whatever the browser/platform language is)
}
```

### `getCurrentLocale()`

Returns the current locale as a `Locale` object.

**Behavior:**
- Calls `getCurrentLanguageCode()` internally
- Converts the language code to a `Locale` object using `languageCodeToLocale()`

**Returns:** A `Locale` object

**Example:**
```dart
import 'package:jaspr_localizations/jaspr_localizations.dart';

void example() {
  final locale = getCurrentLocale();
  print('Language: ${locale.languageCode}');
  print('Country: ${locale.countryCode}');
  print('Tag: ${locale.toLanguageTag()}');
}
```

### `languageCodeToLocale(String)`

Converts a language code string to a `Locale` object.

**Parameters:**
- `languageCode`: A language code string (e.g., `'en'`, `'en-US'`, `'zh-Hans-CN'`)

**Supports:**
- Simple language codes: `'en'` → `Locale('en')`
- Language with country: `'en-US'` → `Locale('en', 'US')`
- Both hyphen and underscore separators: `'en-US'` or `'en_US'`
- Complex tags with script codes: `'zh-Hans-CN'` → `Locale('zh', 'CN')`

**Returns:** A `Locale` object

**Example:**
```dart
import 'package:jaspr_localizations/jaspr_localizations.dart';

void example() {
  // Simple language code
  final en = languageCodeToLocale('en');
  // Returns: Locale('en')
  
  // Language with country
  final enUS = languageCodeToLocale('en-US');
  // Returns: Locale('en', 'US')
  
  // Underscore separator works too
  final esES = languageCodeToLocale('es_ES');
  // Returns: Locale('es', 'ES')
  
  // Complex language tags
  final zhCN = languageCodeToLocale('zh-Hans-CN');
  // Returns: Locale('zh', 'CN')
}
```

## Usage Examples

### Basic Usage

```dart
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_localizations/jaspr_localizations.dart';

@client
class MyComponent extends StatelessComponent {
  const MyComponent({super.key});

  @override
  Component build(BuildContext context) {
    // Get the current language
    final languageCode = getCurrentLanguageCode();
    
    return div([
      text('Your browser language is: $languageCode'),
    ]);
  }
}
```

### Auto-Detect Initial Locale

```dart
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_localizations/jaspr_localizations.dart';

class App extends StatelessComponent {
  const App({super.key});

  @override
  Component build(BuildContext context) {
    // Auto-detect the user's locale
    final detectedLocale = getCurrentLocale();
    
    // Define supported locales
    final supportedLocales = [
      const Locale('en'),
      const Locale('es'),
      const Locale('fr'),
      const Locale('de'),
    ];
    
    // Use detected locale if supported, otherwise default to first
    final initialLocale = supportedLocales.contains(detectedLocale)
        ? detectedLocale
        : supportedLocales.first;
    
    return JasprLocalization(
      supportedLocales: supportedLocales,
      initialLocale: initialLocale,
      builder: (context, locale) {
        return div([
          text('Current locale: ${locale.toLanguageTag()}'),
        ]);
      },
    );
  }
}
```

### Smart Locale Matching

```dart
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_localizations/jaspr_localizations.dart';

Locale findBestMatch(Locale detected, List<Locale> supported) {
  // Try exact match first
  if (supported.contains(detected)) {
    return detected;
  }
  
  // Try matching just the language code
  final languageMatch = supported.where(
    (locale) => locale.languageCode == detected.languageCode
  ).firstOrNull;
  
  if (languageMatch != null) {
    return languageMatch;
  }
  
  // Fallback to first supported locale
  return supported.first;
}

class SmartLanguageApp extends StatelessComponent {
  const SmartLanguageApp({super.key});

  @override
  Component build(BuildContext context) {
    final detectedLocale = getCurrentLocale();
    
    final supportedLocales = [
      const Locale('en', 'US'),
      const Locale('es', 'ES'),
      const Locale('fr', 'FR'),
    ];
    
    // Find the best matching locale
    final initialLocale = findBestMatch(detectedLocale, supportedLocales);
    
    return JasprLocalization(
      supportedLocales: supportedLocales,
      initialLocale: initialLocale,
      builder: (context, locale) {
        return div([
          text('Matched locale: ${locale.toLanguageTag()}'),
        ]);
      },
    );
  }
}
```

## How It Works

### Client-Side (Browser)

On the client side, the function uses the `universal_web` package to access browser APIs:

1. Tries to get `navigator.language` (the user's primary preferred language)
2. Falls back to `navigator.languages[0]` (first item in the array of preferred languages)
3. If both fail, defaults to `'en'`

### Server-Side (Platform)

On the server side, the function uses Dart's `Intl` package:

1. Calls `Intl.getCurrentLocale()` to get the system's current locale
2. If that fails or returns null/empty, defaults to `'en'`

### Detection Logic

The package uses Jaspr's `kIsWeb` constant to determine the runtime environment:

```dart
if (kIsWeb) {
  // Running on client - use browser APIs
  return _getBrowserLanguage();
} else {
  // Running on server - use platform APIs
  return _getPlatformLanguage();
}
```

## Best Practices

1. **Always provide a fallback:** Don't assume the detected language is supported
2. **Match flexibly:** Consider matching just the language code if exact match fails
3. **Respect user choice:** Allow users to override the detected language
4. **Test both environments:** Test on both client and server to ensure proper detection

## Error Handling

All detection functions include error handling:

```dart
try {
  // Try to detect language
  final language = navigator.language;
  return language;
} catch (e) {
  // Log error and return fallback
  print('Error getting browser language: $e');
  return 'en';
}
```

This ensures your app always has a valid language code even if detection fails.
