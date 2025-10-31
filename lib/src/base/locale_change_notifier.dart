import 'package:jaspr/jaspr.dart';
import 'package:jaspr_localizations/src/base/locale.dart';

/// A controller for managing locale changes
class LocaleChangeNotifier extends ChangeNotifier {
  LocaleChangeNotifier({
    required Locale initialLocale,
    required this.supportedLocales,
  }) : _currentLocale = initialLocale;

  /// The current locale
  Locale _currentLocale;

  /// The list of supported locales
  final List<Locale> supportedLocales;

  /// Gets the current locale
  Locale get currentLocale => _currentLocale;

  /// Changes the current locale and notifies listeners
  void setLocale(Locale newLocale) {
    print(
      'LocaleController.setLocale: Attempting to change from ${_currentLocale.toLanguageTag()} to ${newLocale.toLanguageTag()}',
    );
    print(
      'LocaleController.setLocale: Supported locales: ${supportedLocales.map((l) => l.toLanguageTag()).join(', ')}',
    );

    if (!supportedLocales.contains(newLocale)) {
      print(
        'LocaleController.setLocale: ERROR - Locale $newLocale is not supported',
      );
      throw ArgumentError('Locale $newLocale is not supported');
    }
    if (_currentLocale != newLocale) {
      final oldLocale = _currentLocale;
      _currentLocale = newLocale;
      print(
        'LocaleController.setLocale: Changed from ${oldLocale.toLanguageTag()} to ${_currentLocale.toLanguageTag()}',
      );
      print(
        'LocaleController.setLocale: Notifying ${hasListeners ? 'listeners' : 'no listeners'}',
      );
      notifyListeners();
    } else {
      print(
        'LocaleController.setLocale: Locale unchanged (already ${_currentLocale.toLanguageTag()})',
      );
    }
  }

  /// Changes the locale by language code (e.g., 'en', 'es', 'fr')
  void setLanguage(String languageCode, [String? countryCode]) {
    final locale = Locale(languageCode, countryCode);
    setLocale(locale);
  }

  /// Checks if a locale is supported
  bool isSupported(Locale locale) {
    return supportedLocales.contains(locale);
  }
}
