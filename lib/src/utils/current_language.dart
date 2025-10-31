import 'package:intl/intl.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_localizations/src/base/locale.dart';
import 'package:universal_web/web.dart' as web;

/// Gets the current language code from the browser or platform.
///
/// On the client (web), this function retrieves the language from the browser's
/// navigator.language property, falling back to navigator.languages if available.
///
/// On the server, it falls back to the system's current locale from Intl.
///
/// Returns a language code string (e.g., 'en-US', 'es', 'fr-FR').
String getCurrentLanguageCode() {
  if (kIsWeb) {
    // Client-side: Get language from browser
    return _getBrowserLanguage();
  } else {
    // Server-side: Get language from platform/system
    return _getPlatformLanguage();
  }
}

/// Gets the browser's preferred language.
///
/// Tries to get the language from:
/// 1. navigator.language (primary language)
/// 2. First item from navigator.languages array
/// 3. Falls back to 'en' if neither is available
String _getBrowserLanguage() {
  try {
    final navigator = web.window.navigator;

    // Try to get the primary language
    final language = navigator.language;
    if (language.isNotEmpty) {
      return language;
    }

    // Try to get from languages array
    final languages = navigator.languages;
    if (languages.length > 0) {
      // Convert JSString to Dart String
      return languages[0].toString();
    }
  } catch (e) {
    // If there's any error accessing browser APIs, fall back
    print('Error getting browser language: $e');
  }

  // Ultimate fallback
  return 'en';
}

/// Gets the platform's current language.
///
/// On the server, this uses Intl.getCurrentLocale() to get the system locale.
/// Falls back to 'en' if the locale cannot be determined.
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

/// Converts a language code to a [Locale] object.
///
/// Handles both simple language codes (e.g., 'en') and full locale codes
/// with country/script codes (e.g., 'en-US', 'zh-Hans-CN').
///
/// Examples:
/// - 'en' -> Locale('en')
/// - 'en-US' -> Locale('en', 'US')
/// - 'zh-Hans-CN' -> Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans', countryCode: 'CN')
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
/// This is a convenience method that combines [getCurrentLanguageCode]
/// and [languageCodeToLocale].
///
/// Returns a [Locale] object representing the current language preference.
Locale getCurrentLocale() {
  final languageCode = getCurrentLanguageCode();
  return languageCodeToLocale(languageCode);
}
