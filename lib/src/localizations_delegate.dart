import 'jaspr_localizations_base.dart';

/// Localization delegate base class for Jaspr applications
///
/// This is a simplified version of Flutter's LocalizationsDelegate, adapted for Jaspr.
/// It defines how to load localized resources for a specific type.
abstract class LocalizationsDelegate<T> {
  const LocalizationsDelegate();

  /// Whether this delegate supports the given locale.
  bool isSupported(Locale locale);

  /// Load the localizations for the given locale.
  ///
  /// This method is called when the system locale changes or when the app
  /// starts up. It should return a Future that completes with the localized
  /// resources for the given locale.
  Future<T> load(Locale locale);
}
