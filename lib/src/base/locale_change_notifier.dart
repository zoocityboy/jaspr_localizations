import 'package:jaspr/jaspr.dart';
import 'package:jaspr_localizations/src/base/locale.dart';

/// Manages the current locale and notifies listeners of changes.
class LocaleChangeNotifier extends ChangeNotifier {
  /// Creates a notifier with an [initialLocale] and [supportedLocales].
  LocaleChangeNotifier({
    required Locale initialLocale,
    required this.supportedLocales,
  }) : _currentLocale = initialLocale;

  Locale _currentLocale;

  /// The supported locales.
  final List<Locale> supportedLocales;

  /// The current locale.
  Locale get currentLocale => _currentLocale;

  /// Updates the locale and notifies listeners.
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

  /// Updates the locale by language code.
  void setLanguage(String languageCode, [String? countryCode]) {
    final locale = Locale(languageCode, countryCode);
    setLocale(locale);
  }

  /// Checks if a locale is supported.
  bool isSupported(Locale locale) {
    return supportedLocales.contains(locale);
  }
}
