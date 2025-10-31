import 'package:jaspr/jaspr.dart';
import 'package:jaspr_localizations/src/base/locale.dart';
import 'package:jaspr_localizations/src/base/locale_change_notifier.dart';
import 'package:jaspr_localizations/src/base/localizations_delegate.dart';

/// An inherited component that provides locale information to descendant components
class JasprLocalizationProvider extends InheritedComponent {
  /// Creates a LocaleProvider with a specific locale and delegates
  ///
  /// The [locale] is the current locale to use.
  /// The [delegates] are used to determine supported locales.
  /// If [supportedLocales] is provided, it overrides the locales from delegates.
  /// The [controller] can be provided to enable locale switching.
  const JasprLocalizationProvider({
    required this.locale,
    this.delegates = const [],
    Iterable<Locale>? supportedLocales,
    this.controller,
    required super.child,
    super.key,
  }) : _supportedLocales = supportedLocales;

  /// Creates a LocaleProvider with a controller for managing locale changes
  const JasprLocalizationProvider.withController({
    required this.controller,
    this.delegates = const [],
    Iterable<Locale>? supportedLocales,
    required super.child,
    super.key,
  }) : _supportedLocales = supportedLocales,
       locale = null;

  /// The current locale (may be null if using controller)
  final Locale? locale;

  /// The locale controller for managing locale changes
  final LocaleChangeNotifier? controller;

  /// The localization delegates
  final List<LocalizationsDelegate> delegates;

  /// Explicitly provided supported locales
  final Iterable<Locale>? _supportedLocales;

  /// Gets the current locale from either the locale field or controller
  Locale get currentLocale =>
      locale ?? controller?.currentLocale ?? const Locale('en');

  /// The set of supported locales
  ///
  /// If explicitly provided in constructor, returns that.
  /// Otherwise, returns all locales supported by at least one delegate.
  Iterable<Locale> get supportedLocales {
    if (_supportedLocales != null) {
      return _supportedLocales;
    }

    // If using controller, return its supported locales
    if (controller != null) {
      return controller!.supportedLocales.toSet();
    }

    // Collect supported locales from all delegates
    final locales = <Locale>{};
    // This is a simplified approach - in a real implementation,
    // we'd query each delegate's supported locales
    return locales;
  }

  /// Get the LocaleProvider from the widget tree
  static JasprLocalizationProvider of(BuildContext context) {
    final JasprLocalizationProvider? result = maybeOf(context);
    assert(result != null, 'No LocaleProvider found in context');
    return result!;
  }

  /// Get the LocaleProvider from the widget tree, returning null if not found
  static JasprLocalizationProvider? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedComponentOfExactType<JasprLocalizationProvider>();
  }

  /// Get the LocaleController from the widget tree, if available
  static LocaleChangeNotifier? controllerOf(BuildContext context) {
    final provider = maybeOf(context);
    return provider?.controller;
  }

  /// Sets the locale using the controller, if available
  static void setLocale(BuildContext context, Locale newLocale) {
    final controller = controllerOf(context);
    if (controller != null) {
      controller.setLocale(newLocale);
    } else {
      throw StateError(
        'No LocaleController found in context. Use LocaleProvider.withController().',
      );
    }
  }

  /// Sets the language using the controller, if available
  static void setLanguage(
    BuildContext context,
    String languageCode, [
    String? countryCode,
  ]) {
    final controller = controllerOf(context);
    print(
      'LocaleProvider.setLanguage: languageCode=$languageCode, countryCode=$countryCode, controller=${controller != null}',
    );
    if (controller != null) {
      controller.setLanguage(languageCode, countryCode);
    } else {
      throw StateError(
        'No LocaleController found in context. Use LocaleProvider.withController().',
      );
    }
  }

  @override
  bool updateShouldNotify(covariant JasprLocalizationProvider oldComponent) {
    return currentLocale != oldComponent.currentLocale ||
        delegates != oldComponent.delegates ||
        _supportedLocales != oldComponent._supportedLocales ||
        controller != oldComponent.controller;
  }
}
