import 'package:intl/intl.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_localizations/src/base/locale.dart';
import 'package:universal_web/web.dart' as web;

/// Gets the current language code from the browser or platform.
///
/// This function provides platform-agnostic language detection that works
/// in both client-side (web) and server-side (Jaspr SSR) contexts.
///
/// ### Client-Side Behavior (Web)
///
/// On the client, this function retrieves the user's preferred language from:
/// 1. `navigator.language` - The browser's primary language setting
/// 2. `navigator.languages[0]` - First language from the user's language preferences
/// 3. Falls back to 'en' if neither is available
///
/// ### Server-Side Behavior
///
/// On the server, it retrieves the system locale using `Intl.getCurrentLocale()`,
/// which returns the locale of the Dart runtime environment.
///
/// ### Return Value
///
/// Returns a language code string in one of these formats:
/// * Simple language code: `'en'`, `'es'`, `'fr'`
/// * Language with region: `'en-US'`, `'es-ES'`, `'zh-CN'`
/// * Language with script and region: `'zh-Hans-CN'`
///
/// ### Example
///
/// ```dart
/// // Get the current language code
/// final languageCode = getCurrentLanguageCode();
/// print(languageCode); // e.g., 'en-US'
///
/// // Use with languageCodeToLocale
/// final locale = languageCodeToLocale(languageCode);
/// print(locale.languageCode); // 'en'
/// print(locale.countryCode);  // 'US'
/// ```
///
/// See also:
/// * [getCurrentLocale], which returns a [Locale] object instead of a string
/// * [languageCodeToLocale], for converting language codes to [Locale] objects
String getCurrentLanguageCode() {
  if (kIsWeb) {
    // Client-side: Get language from browser
    return _getBrowserLanguage();
  } else {
    // Server-side: Get language from platform/system
    return _getPlatformLanguage();
  }
}

/// Gets the browser's preferred language (client-side only).
///
/// This internal helper function accesses the browser's navigator API
/// to retrieve the user's language preferences.
///
/// ### Detection Strategy
///
/// 1. Attempts to read `navigator.language`
/// 2. Falls back to `navigator.languages[0]`
/// 3. Returns 'en' as the ultimate fallback
///
/// ### Error Handling
///
/// If there's any error accessing browser APIs (e.g., in non-browser environments
/// or due to security restrictions), the function catches the error and falls back
/// to 'en'.
///
/// Returns a language code string (e.g., 'en-US', 'fr-FR').
String _getBrowserLanguage() {
  try {
    // 1. Check HTML lang attribute (SSR hydration consistency)
    final htmlLang = web.document.documentElement?.getAttribute('lang');
    if (htmlLang != null && htmlLang.isNotEmpty) {
      return htmlLang;
    }

    final navigator = web.window.navigator;

    // 2. Try to get the primary language
    final language = navigator.language;
    if (language.isNotEmpty) {
      return language;
    }

    // 3. Try to get from languages array
    final languages = navigator.languages;
    if (languages.length > 0) {
      return languages[0].toString();
    }
  } catch (e) {
    // If there's any error accessing browser APIs, fall back
    print('Error getting browser language: $e');
  }

  // Ultimate fallback
  return 'en';
}

/// Gets the platform's current language (server-side only).
///
/// This internal helper function retrieves the system locale from the
/// Dart runtime environment using `Intl.getCurrentLocale()`.
///
/// ### Server-Side Detection
///
/// On the server, the locale is determined by:
/// * The system's locale settings
/// * Environment variables (LC_ALL, LC_MESSAGES, LANG)
/// * The Dart VM's default locale
///
/// ### Error Handling
///
/// Returns 'en' if:
/// * `Intl.getCurrentLocale()` returns an empty string
/// * The returned value is 'null' (string)
/// * An exception occurs during locale detection
///
/// Returns a language code string (e.g., 'en_US', 'es_ES').
String _getPlatformLanguage() {
  try {
    final locale = Intl.getCurrentLocale();
    if (locale.isNotEmpty && locale != 'null') {
      return locale;
    }
  } catch (e) {
    print('Error getting platform language: $e');
  }

  // Fallback to English
  return 'en';
}

/// Converts a language code string to a [Locale] object.
///
/// This function parses language code strings in various formats and
/// creates appropriate [Locale] objects. It handles multiple standard
/// formats used in different systems.
///
/// ### Supported Formats
///
/// * **Simple language code**: `'en'`, `'es'`, `'fr'` → `Locale('en')`
/// * **Language + country**: `'en-US'`, `'en_US'` → `Locale('en', 'US')`
/// * **Language + script + country**: `'zh-Hans-CN'` → `Locale('zh', 'CN')`
///
/// ### Parsing Rules
///
/// * Accepts both hyphen (`-`) and underscore (`_`) as separators
/// * Language codes are converted to lowercase
/// * Country codes are converted to uppercase
/// * Whitespace is trimmed
/// * Empty strings default to `Locale('en')`
///
/// ### Examples
///
/// ```dart
/// languageCodeToLocale('en');         // Locale('en')
/// languageCodeToLocale('en-US');      // Locale('en', 'US')
/// languageCodeToLocale('en_GB');      // Locale('en', 'GB')
/// languageCodeToLocale('zh-Hans-CN'); // Locale('zh', 'CN')
/// languageCodeToLocale('  es-ES  ');  // Locale('es', 'ES')
/// languageCodeToLocale('');           // Locale('en') - fallback
/// ```
///
/// ### Parameters
///
/// * [languageCode]: The language code string to parse
///
/// ### Returns
///
/// A [Locale] object. If parsing fails or the input is invalid,
/// returns `Locale('en')` as a safe fallback.
///
/// See also:
/// * [Locale.fromLanguageTag], for creating locales from IETF tags
/// * [getCurrentLanguageCode], for getting the current language code
Locale languageCodeToLocale(String languageCode) {
  // Remove any whitespace
  languageCode = languageCode.trim();

  // Handle empty string
  if (languageCode.isEmpty) {
    return const Locale('en');
  }

  // Split by hyphen or underscore
  final parts = languageCode.split(RegExp(r'[-_]'));

  if (parts.isEmpty) {
    return const Locale('en');
  }

  final language = parts[0].toLowerCase();

  // Ensure language code is not empty after split
  if (language.isEmpty) {
    return const Locale('en');
  }

  if (parts.length == 1) {
    // Simple language code: 'en', 'es', etc.
    return Locale(language);
  } else if (parts.length == 2) {
    // Language + country: 'en-US', 'es-ES', etc.
    final country = parts[1].toUpperCase();
    return Locale(language, country);
  } else {
    // Multiple parts (e.g., 'zh-Hans-CN')
    // For now, use the last part as country code if it's 2 characters
    // Otherwise, just use language code
    final lastPart = parts.last;
    if (lastPart.length == 2) {
      return Locale(language, lastPart.toUpperCase());
    } else {
      return Locale(language);
    }
  }
}

/// Gets the current locale from the browser or platform.
///
/// This is a convenience function that combines [getCurrentLanguageCode]
/// and [languageCodeToLocale] into a single call.
///
/// ### Usage
///
/// Instead of calling:
/// ```dart
/// final code = getCurrentLanguageCode();
/// final locale = languageCodeToLocale(code);
/// ```
///
/// You can simply call:
/// ```dart
/// final locale = getCurrentLocale();
/// ```
///
/// ### Return Value
///
/// Returns a [Locale] object representing the user's current language
/// preference from the browser (client-side) or system (server-side).
///
/// ### Example
///
/// ```dart
/// // Get current locale
/// final locale = getCurrentLocale();
///
/// // Use with JasprLocalizationProvider
/// JasprLocalizationProvider.setLocale(context, locale);
///
/// // Access locale properties
/// print('Language: ${locale.languageCode}');
/// print('Country: ${locale.countryCode}');
/// print('Language tag: ${locale.toLanguageTag()}');
/// ```
///
/// See also:
/// * [getCurrentLanguageCode], for getting just the language code string
/// * [languageCodeToLocale], for converting codes to locales manually
/// * [JasprLocalizationProvider.setLocale], for setting the app's locale
Locale getCurrentLocale() {
  final languageCode = getCurrentLanguageCode();
  return languageCodeToLocale(languageCode);
}
