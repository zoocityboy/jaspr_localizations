import 'package:jaspr_localizations/src/base/locale.dart';

/// A delegate for loading localized resources.
///
/// Implementations define how to load specific localizations (e.g., generated [L10n] classes)
/// for a supported locale.
abstract class LocalizationsDelegate<T> {
  const LocalizationsDelegate();

  /// Whether resources for the [locale] are supported by this delegate.
  bool isSupported(Locale locale);

  /// Loads the resources for the [locale].
  Future<T> load(Locale locale);
}
