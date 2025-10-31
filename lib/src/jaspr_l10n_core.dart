import 'package:jaspr/jaspr.dart';
import 'package:jaspr_localizations/src/base/locale.dart';
import 'package:jaspr_localizations/src/base/locale_change_notifier.dart';
import 'package:jaspr_localizations/src/base/localizations_delegate.dart';

/// An inherited component that provides locale information to descendant components.
///
/// [JasprLocalizationProvider] makes locale information available throughout
/// the widget tree using Jaspr's [InheritedComponent] mechanism. This allows
/// descendant components to access and react to locale changes without
/// explicit prop drilling.
///
/// ### Usage Patterns
///
/// **1. Static Locale (No Switching)**
///
/// ```dart
/// JasprLocalizationProvider(
///   locale: const Locale('en', 'US'),
///   delegates: [AppLocalizations.delegate],
///   child: MyApp(),
/// )
/// ```
///
/// **2. Dynamic Locale (With Controller)**
///
/// ```dart
/// final controller = LocaleChangeNotifier(
///   initialLocale: const Locale('en'),
///   supportedLocales: [Locale('en'), Locale('es')],
/// );
///
/// JasprLocalizationProvider.withController(
///   controller: controller,
///   delegates: [AppLocalizations.delegate],
///   child: MyApp(),
/// )
/// ```
///
/// **3. Accessing the Provider**
///
/// ```dart
/// // In descendant components
/// final provider = JasprLocalizationProvider.of(context);
/// final currentLocale = provider.currentLocale;
/// final supportedLocales = provider.supportedLocales;
/// ```
///
/// **4. Changing Locale**
///
/// ```dart
/// // Using static method
/// JasprLocalizationProvider.setLocale(context, Locale('es'));
///
/// // Or with language code
/// JasprLocalizationProvider.setLanguage(context, 'es', 'ES');
/// ```
///
/// See also:
/// * [LocaleChangeNotifier], for managing locale state
/// * [JasprLocalizations], for a higher-level component with built-in rebuilding
/// * [LocalizationsDelegate], for providing localized resources
class JasprLocalizationProvider extends InheritedComponent {
  /// Creates a [JasprLocalizationProvider] with a specific locale.
  ///
  /// Use this constructor when you have a static locale that won't change,
  /// or when you want to manually control locale updates by rebuilding
  /// the widget tree.
  ///
  /// ### Parameters
  ///
  /// * [locale]: The current locale to use throughout the widget tree.
  ///   This is required and should be one of the [supportedLocales].
  ///
  /// * [delegates]: A list of [LocalizationsDelegate] objects that provide
  ///   localized resources. These delegates load and provide translations,
  ///   formatted strings, and other locale-specific data.
  ///
  /// * [supportedLocales]: An explicit set of supported locales. If not provided,
  ///   the supported locales will be derived from the delegates.
  ///
  /// * [controller]: An optional [LocaleChangeNotifier] for managing locale
  ///   changes. If provided, the locale parameter should be null.
  ///
  /// * [child]: The widget subtree that can access this provider.
  ///
  /// ### Example
  ///
  /// ```dart
  /// JasprLocalizationProvider(
  ///   locale: const Locale('en', 'US'),
  ///   delegates: [AppLocalizations.delegate],
  ///   supportedLocales: [
  ///     Locale('en', 'US'),
  ///     Locale('es', 'ES'),
  ///   ],
  ///   child: MyApp(),
  /// )
  /// ```
  const JasprLocalizationProvider({
    required this.locale,
    this.delegates = const [],
    Iterable<Locale>? supportedLocales,
    this.controller,
    required super.child,
    super.key,
  }) : _supportedLocales = supportedLocales;

  /// Creates a [JasprLocalizationProvider] with a controller for managing locale changes.
  ///
  /// Use this constructor when you want runtime locale switching capabilities.
  /// The controller manages the current locale and notifies listeners when
  /// it changes.
  ///
  /// ### Parameters
  ///
  /// * [controller]: A [LocaleChangeNotifier] that manages the current locale
  ///   and handles locale changes. This is required.
  ///
  /// * [delegates]: A list of [LocalizationsDelegate] objects that provide
  ///   localized resources.
  ///
  /// * [supportedLocales]: An explicit set of supported locales. If not provided,
  ///   the supported locales will be taken from the controller.
  ///
  /// * [child]: The widget subtree that can access this provider.
  ///
  /// ### Example
  ///
  /// ```dart
  /// final controller = LocaleChangeNotifier(
  ///   initialLocale: const Locale('en'),
  ///   supportedLocales: [Locale('en'), Locale('es'), Locale('fr')],
  /// );
  ///
  /// JasprLocalizationProvider.withController(
  ///   controller: controller,
  ///   delegates: [AppLocalizations.delegate],
  ///   child: MyApp(),
  /// )
  /// ```
  const JasprLocalizationProvider.withController({
    required this.controller,
    this.delegates = const [],
    Iterable<Locale>? supportedLocales,
    required super.child,
    super.key,
  }) : _supportedLocales = supportedLocales,
       locale = null;

  /// The current locale (may be null if using controller).
  ///
  /// When using the standard constructor, this contains the fixed locale.
  /// When using [JasprLocalizationProvider.withController], this is null
  /// and the locale comes from the [controller].
  final Locale? locale;

  /// The locale controller for managing locale changes.
  ///
  /// When provided, this controller manages the current locale and enables
  /// runtime locale switching through methods like [setLocale] and [setLanguage].
  ///
  /// See also:
  /// * [LocaleChangeNotifier], the controller class
  /// * [controllerOf], for accessing the controller from context
  final LocaleChangeNotifier? controller;

  /// The localization delegates that provide localized resources.
  ///
  /// Delegates are responsible for loading and providing translations,
  /// date/time formatting, number formatting, and other locale-specific
  /// resources to the application.
  ///
  /// Each delegate should implement the [LocalizationsDelegate] interface
  /// and provide resources for a specific set of locales.
  final List<LocalizationsDelegate> delegates;

  /// Explicitly provided supported locales.
  final Iterable<Locale>? _supportedLocales;

  /// Gets the current locale from either the [locale] field or [controller].
  ///
  /// ### Priority
  ///
  /// 1. Returns [locale] if it's not null
  /// 2. Returns [controller.currentLocale] if controller is available
  /// 3. Falls back to `Locale('en')` if neither is available
  ///
  /// ### Example
  ///
  /// ```dart
  /// final provider = JasprLocalizationProvider.of(context);
  /// final currentLocale = provider.currentLocale;
  /// print('Current language: ${currentLocale.languageCode}');
  /// ```
  Locale get currentLocale =>
      locale ?? controller?.currentLocale ?? const Locale('en');

  /// The set of locales supported by this provider.
  ///
  /// ### Resolution Strategy
  ///
  /// 1. If [supportedLocales] was explicitly provided in the constructor,
  ///    returns that set
  /// 2. If using a controller, returns the controller's supported locales
  /// 3. Otherwise, returns an empty set (delegates would need to be queried)
  ///
  /// ### Example
  ///
  /// ```dart
  /// final provider = JasprLocalizationProvider.of(context);
  /// for (final locale in provider.supportedLocales) {
  ///   print('Supported: ${locale.toLanguageTag()}');
  /// }
  /// ```
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

  /// Gets the [JasprLocalizationProvider] from the widget tree.
  ///
  /// This method searches up the widget tree for the nearest
  /// [JasprLocalizationProvider] and returns it. It also registers
  /// the calling component as a dependent, so it will rebuild when
  /// the provider's locale changes.
  ///
  /// Throws an [AssertionError] if no provider is found in the tree.
  ///
  /// ### Example
  ///
  /// ```dart
  /// class MyComponent extends StatelessComponent {
  ///   @override
  ///   Component build(BuildContext context) sync* {
  ///     final provider = JasprLocalizationProvider.of(context);
  ///     final locale = provider.currentLocale;
  ///
  ///     return Text('Current language: ${locale.languageCode}');
  ///   }
  /// }
  /// ```
  ///
  /// See also:
  /// * [maybeOf], which returns null instead of throwing when not found
  /// * [controllerOf], for accessing just the controller
  static JasprLocalizationProvider of(BuildContext context) {
    final JasprLocalizationProvider? result = maybeOf(context);
    assert(result != null, 'No LocaleProvider found in context');
    return result!;
  }

  /// Gets the [JasprLocalizationProvider] from the widget tree, or null if not found.
  ///
  /// This is a safer version of [of] that returns null instead of throwing
  /// an assertion error when no provider is found.
  ///
  /// ### Example
  ///
  /// ```dart
  /// final provider = JasprLocalizationProvider.maybeOf(context);
  /// if (provider != null) {
  ///   // Use the provider
  ///   final locale = provider.currentLocale;
  /// } else {
  ///   // Handle missing provider
  ///   print('No localization provider found');
  /// }
  /// ```
  ///
  /// See also:
  /// * [of], which throws an assertion error when not found
  static JasprLocalizationProvider? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedComponentOfExactType<JasprLocalizationProvider>();
  }

  /// Gets the [LocaleChangeNotifier] controller from the widget tree, if available.
  ///
  /// Returns the controller if the provider was created with
  /// [JasprLocalizationProvider.withController], otherwise returns null.
  ///
  /// Use this to access locale control methods without accessing the full provider.
  ///
  /// ### Example
  ///
  /// ```dart
  /// final controller = JasprLocalizationProvider.controllerOf(context);
  /// if (controller != null) {
  ///   // Controller is available - locale switching is enabled
  ///   controller.setLanguage('es');
  /// } else {
  ///   // No controller - locale is static
  ///   print('Locale switching not available');
  /// }
  /// ```
  ///
  /// See also:
  /// * [setLocale], for changing locale via static method
  /// * [setLanguage], for changing locale by language code
  static LocaleChangeNotifier? controllerOf(BuildContext context) {
    final provider = maybeOf(context);
    return provider?.controller;
  }

  /// Sets the locale using the controller, if available.
  ///
  /// Changes the current locale to [newLocale]. The locale must be one of
  /// the supported locales configured in the provider.
  ///
  /// Throws [StateError] if no controller is found in the widget tree.
  /// The provider must have been created with [JasprLocalizationProvider.withController]
  /// for this method to work.
  ///
  /// ### Parameters
  ///
  /// * [context]: The build context from which to find the provider
  /// * [newLocale]: The new locale to switch to
  ///
  /// ### Example
  ///
  /// ```dart
  /// // In a component's event handler
  /// void onLanguageChanged(String languageCode) {
  ///   final locale = Locale(languageCode);
  ///   JasprLocalizationProvider.setLocale(context, locale);
  /// }
  /// ```
  ///
  /// ### Throws
  ///
  /// * [StateError] if no controller is available (provider was created
  ///   without a controller)
  ///
  /// See also:
  /// * [setLanguage], for setting locale by language code
  /// * [LocaleChangeNotifier.setLocale], for the underlying method
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

  /// Sets the language using the controller, if available.
  ///
  /// Changes the current locale by language code and optional country code.
  /// This is a convenience method that creates a [Locale] object internally.
  ///
  /// Throws [StateError] if no controller is found in the widget tree.
  ///
  /// ### Parameters
  ///
  /// * [context]: The build context from which to find the provider
  /// * [languageCode]: The ISO 639-1 language code (e.g., 'en', 'es', 'fr')
  /// * [countryCode]: Optional ISO 3166-1 country code (e.g., 'US', 'GB', 'FR')
  ///
  /// ### Examples
  ///
  /// ```dart
  /// // Change to English
  /// JasprLocalizationProvider.setLanguage(context, 'en');
  ///
  /// // Change to US English
  /// JasprLocalizationProvider.setLanguage(context, 'en', 'US');
  ///
  /// // Change to Spanish (Spain)
  /// JasprLocalizationProvider.setLanguage(context, 'es', 'ES');
  /// ```
  ///
  /// ### Throws
  ///
  /// * [StateError] if no controller is available
  ///
  /// See also:
  /// * [setLocale], for setting locale with a Locale object
  /// * [LocaleChangeNotifier.setLanguage], for the underlying method
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
    return currentLocale != oldComponent.currentLocale ||
        delegates != oldComponent.delegates ||
        _supportedLocales != oldComponent._supportedLocales ||
        controller != oldComponent.controller;
  }
}
