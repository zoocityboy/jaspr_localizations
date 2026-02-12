import 'package:jaspr/jaspr.dart';
import 'package:jaspr_localizations/src/base/locale.dart';
import 'package:jaspr_localizations/src/base/locale_change_notifier.dart';
import 'package:jaspr_localizations/src/base/localizations_delegate.dart';

/// An inherited component that supplies locale information to the widget tree.
///
/// [JasprLocalizationProvider] allows descendants to access the current locale
/// and react to changes. It supports both static locales and dynamic locale switching
/// via a [LocaleChangeNotifier].
class JasprLocalizationProvider extends InheritedComponent {
  /// Creates a provider with a fixed [locale].
  ///
  /// Use this for static localization or when manually managing updates.
  const JasprLocalizationProvider({
    required this.locale,
    this.delegates = const [],
    Iterable<Locale>? supportedLocales,
    this.controller,
    required super.child,
    super.key,
  }) : _supportedLocales = supportedLocales,
       _currentLocaleSnapshot = locale;

  /// Creates a provider backed by a [controller] for dynamic switching.
  JasprLocalizationProvider.withController({
    required this.controller,
    this.delegates = const [],
    Iterable<Locale>? supportedLocales,
    required super.child,
    super.key,
  }) : _supportedLocales = supportedLocales,
       locale = null,
       _currentLocaleSnapshot = controller!.currentLocale;

  /// The current fixed locale, or null if using [controller].
  final Locale? locale;
  
  // Snapshot of the locale at the time of build to detect changes
  final Locale? _currentLocaleSnapshot;

  /// The controller managing the dynamic locale state.
  final LocaleChangeNotifier? controller;

  /// Delegates that load localized resources.
  final List<LocalizationsDelegate> delegates;

  /// Explicitly provided supported locales.
  final Iterable<Locale>? _supportedLocales;

  /// Returns the effective current locale.
  ///
  /// Prioritizes [locale], then [controller.currentLocale], defaulting to English.
  Locale get currentLocale =>
      locale ?? controller?.currentLocale ?? const Locale('en');

  /// Returns the list of supported locales.
  ///
  /// Derived from the constructor argument, controller, or empty if not specified.
  Iterable<Locale> get supportedLocales {
    if (_supportedLocales != null) {
      return _supportedLocales;
    }

    if (controller != null) {
      return controller!.supportedLocales.toSet();
    }

    return {};
  }

  /// Returns the nearest [JasprLocalizationProvider] in the widget tree.
  ///
  /// Throws if not found.
  static JasprLocalizationProvider of(BuildContext context) {
    final JasprLocalizationProvider? result = maybeOf(context);
    assert(result != null, 'No LocaleProvider found in context');
    return result!;
  }

  /// Returns the nearest [JasprLocalizationProvider] in the widget tree, or null.
  static JasprLocalizationProvider? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedComponentOfExactType<JasprLocalizationProvider>();
  }

  /// Returns the [LocaleChangeNotifier] from the nearest provider, or null.
  static LocaleChangeNotifier? controllerOf(BuildContext context) {
    final provider = maybeOf(context);
    return provider?.controller;
  }

  /// Updates the locale via the nearest controller.
  ///
  /// Throws [StateError] if no controller is available.
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

  /// Updates the language via the nearest controller.
  ///
  /// Convenience method for [setLocale].
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

  /// Determines whether the inherited component should notify dependents.
  ///
  /// This method is called by the framework when the provider is rebuilt.
  /// It returns true if the current locale or other key properties have changed,
  /// triggering a rebuild of all dependent components.
  ///
  /// ### Comparison Logic
  ///
  /// Returns true if any of the following changed:
  /// * [currentLocale] - The active locale
  /// * [delegates] - The list of localization delegates
  /// * [_supportedLocales] - The set of supported locales
  /// * [controller] - The locale controller instance
  ///
  /// @override
  @override
  bool updateShouldNotify(covariant JasprLocalizationProvider oldComponent) {
    final shouldNotify =
        _currentLocaleSnapshot != oldComponent._currentLocaleSnapshot ||
        delegates != oldComponent.delegates ||
        _supportedLocales != oldComponent._supportedLocales ||
        controller != oldComponent.controller;
    
    if (shouldNotify) {
      print('JasprLocalizationProvider: updateShouldNotify returned true');
      print(
        '  Old locale: ${oldComponent._currentLocaleSnapshot?.toLanguageTag()}',
      );
      print('  New locale: ${_currentLocaleSnapshot?.toLanguageTag()}');
    }
    return shouldNotify;
  }
}
