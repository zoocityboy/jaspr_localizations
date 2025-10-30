import 'package:jaspr/jaspr.dart';

import 'localizations_delegate.dart';

/// A controller for managing locale changes
class LocaleController extends ChangeNotifier {
  LocaleController({required Locale initialLocale, required this.supportedLocales}) : _currentLocale = initialLocale;

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
      print('LocaleController.setLocale: ERROR - Locale $newLocale is not supported');
      throw ArgumentError('Locale $newLocale is not supported');
    }
    if (_currentLocale != newLocale) {
      final oldLocale = _currentLocale;
      _currentLocale = newLocale;
      print(
        'LocaleController.setLocale: Changed from ${oldLocale.toLanguageTag()} to ${_currentLocale.toLanguageTag()}',
      );
      print('LocaleController.setLocale: Notifying ${hasListeners ? 'listeners' : 'no listeners'}');
      notifyListeners();
    } else {
      print('LocaleController.setLocale: Locale unchanged (already ${_currentLocale.toLanguageTag()})');
    }
  }

  /// Changes the locale by language code (e.g., 'en', 'es', 'fr')
  void setLanguage(String languageCode, [String? countryCode]) {
    print('LocaleController.setLanguage: languageCode=$languageCode, countryCode=$countryCode');
    final locale = Locale(languageCode, countryCode);
    print('LocaleController.setLanguage: Created locale: ${locale.toLanguageTag()}');
    setLocale(locale);
  }

  /// Cycles to the next supported locale
  void nextLocale() {
    final currentIndex = supportedLocales.indexOf(_currentLocale);
    final nextIndex = (currentIndex + 1) % supportedLocales.length;
    setLocale(supportedLocales[nextIndex]);
  }

  /// Gets the next locale in the supported list (without changing current)
  Locale getNextLocale() {
    final currentIndex = supportedLocales.indexOf(_currentLocale);
    final nextIndex = (currentIndex + 1) % supportedLocales.length;
    return supportedLocales[nextIndex];
  }

  /// Checks if a locale is supported
  bool isSupported(Locale locale) {
    return supportedLocales.contains(locale);
  }
}

/// Represents a locale with language code and optional country code
class Locale {
  /// Creates a Locale with a language code and optional country code
  const Locale(this.languageCode, [this.countryCode]);

  /// The primary language subtag for the locale
  final String languageCode;

  /// The region subtag for the locale (optional)
  final String? countryCode;

  /// Returns the locale identifier in the form 'languageCode_COUNTRYCODE'
  /// or just 'languageCode' if no country code is specified
  String toLanguageTag() {
    return countryCode != null ? '${languageCode}_$countryCode' : languageCode;
  }

  /// Creates a Locale from a language tag (e.g., 'en_US' or 'en')
  factory Locale.fromLanguageTag(String tag) {
    final parts = tag.split('_');
    if (parts.length == 1) {
      return Locale(parts[0]);
    } else if (parts.length == 2) {
      return Locale(parts[0], parts[1]);
    }
    throw ArgumentError('Invalid language tag: $tag');
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Locale && other.languageCode == languageCode && other.countryCode == countryCode;
  }

  @override
  int get hashCode => Object.hash(languageCode, countryCode);

  @override
  String toString() => toLanguageTag();
}

/// An inherited component that provides locale information to descendant components
class LocaleProvider extends InheritedComponent {
  /// Creates a LocaleProvider with a specific locale and delegates
  ///
  /// The [locale] is the current locale to use.
  /// The [delegates] are used to determine supported locales.
  /// If [supportedLocales] is provided, it overrides the locales from delegates.
  /// The [controller] can be provided to enable locale switching.
  const LocaleProvider({
    required this.locale,
    this.delegates = const [],
    Set<Locale>? supportedLocales,
    this.controller,
    required super.child,
    super.key,
  }) : _supportedLocales = supportedLocales;

  /// Creates a LocaleProvider with a controller for managing locale changes
  const LocaleProvider.withController({
    required this.controller,
    this.delegates = const [],
    Set<Locale>? supportedLocales,
    required super.child,
    super.key,
  }) : _supportedLocales = supportedLocales,
       locale = null;

  /// The current locale (may be null if using controller)
  final Locale? locale;

  /// The locale controller for managing locale changes
  final LocaleController? controller;

  /// The localization delegates
  final List<LocalizationsDelegate> delegates;

  /// Explicitly provided supported locales
  final Set<Locale>? _supportedLocales;

  /// Gets the current locale from either the locale field or controller
  Locale get currentLocale => locale ?? controller?.currentLocale ?? const Locale('en');

  /// The set of supported locales
  ///
  /// If explicitly provided in constructor, returns that.
  /// Otherwise, returns all locales supported by at least one delegate.
  Set<Locale> get supportedLocales {
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
  static LocaleProvider of(BuildContext context) {
    final LocaleProvider? result = maybeOf(context);
    assert(result != null, 'No LocaleProvider found in context');
    return result!;
  }

  /// Get the LocaleProvider from the widget tree, returning null if not found
  static LocaleProvider? maybeOf(BuildContext context) {
    return context.dependOnInheritedComponentOfExactType<LocaleProvider>();
  }

  /// Get the LocaleController from the widget tree, if available
  static LocaleController? controllerOf(BuildContext context) {
    final provider = maybeOf(context);
    return provider?.controller;
  }

  /// Sets the locale using the controller, if available
  static void setLocale(BuildContext context, Locale newLocale) {
    final controller = controllerOf(context);
    if (controller != null) {
      controller.setLocale(newLocale);
    } else {
      throw StateError('No LocaleController found in context. Use LocaleProvider.withController().');
    }
  }

  /// Sets the language using the controller, if available
  static void setLanguage(BuildContext context, String languageCode, [String? countryCode]) {
    final controller = controllerOf(context);
    print(
      'LocaleProvider.setLanguage: languageCode=$languageCode, countryCode=$countryCode, controller=${controller != null}',
    );
    if (controller != null) {
      controller.setLanguage(languageCode, countryCode);
    } else {
      throw StateError('No LocaleController found in context. Use LocaleProvider.withController().');
    }
  }

  @override
  bool updateShouldNotify(covariant LocaleProvider oldComponent) {
    return currentLocale != oldComponent.currentLocale ||
        delegates != oldComponent.delegates ||
        _supportedLocales != oldComponent._supportedLocales ||
        controller != oldComponent.controller;
  }
}

/// A builder component that rebuilds when the locale changes
class LocaleBuilder extends StatefulComponent {
  /// Creates a LocaleBuilder that rebuilds when locale changes
  const LocaleBuilder({required this.builder, this.controller, super.key});

  /// The builder function that creates the component
  final Component Function(BuildContext context, Locale locale) builder;

  /// Optional controller to listen to. If not provided, uses the one from context
  final LocaleController? controller;

  @override
  State<LocaleBuilder> createState() => _LocaleBuilderState();
}

class _LocaleBuilderState extends State<LocaleBuilder> {
  LocaleController? _controller;
  Locale? _currentLocale;

  @override
  void initState() {
    super.initState();
    _setupController();
  }

  @override
  void didUpdateComponent(LocaleBuilder oldComponent) {
    super.didUpdateComponent(oldComponent);
    if (oldComponent.controller != component.controller) {
      _teardownController();
      _setupController();
    }
  }

  @override
  void dispose() {
    _teardownController();
    super.dispose();
  }

  void _setupController() {
    _controller = component.controller ?? LocaleProvider.controllerOf(context);
    if (_controller != null) {
      _currentLocale = _controller!.currentLocale;
      _controller!.addListener(_onLocaleChanged);
    }
  }

  void _teardownController() {
    _controller?.removeListener(_onLocaleChanged);
    _controller = null;
  }

  void _onLocaleChanged() {
    print('_LocaleBuilderState: _onLocaleChanged called, mounted=$mounted, controller=${_controller != null}');
    if (mounted && _controller != null) {
      final newLocale = _controller!.currentLocale;
      print('_LocaleBuilderState: Setting state with new locale: ${newLocale.toLanguageTag()}');
      setState(() {
        _currentLocale = newLocale;
      });
      print('_LocaleBuilderState: State updated, currentLocale=${_currentLocale?.toLanguageTag()}');
    }
  }

  @override
  Component build(BuildContext context) {
    final locale = _currentLocale ?? LocaleProvider.of(context).currentLocale;
    return component.builder(context, locale);
  }
}

/// A convenience component that combines LocaleProvider with automatic rebuilding
class LocalizationApp extends StatefulComponent {
  /// Creates a LocalizationApp with locale switching capabilities
  const LocalizationApp({
    required this.supportedLocales,
    Locale? initialLocale,
    this.delegates = const [],
    required this.builder,
    super.key,
  }) : _initialLocale = initialLocale;

  /// The list of supported locales
  final List<Locale> supportedLocales;

  /// The initial locale (defaults to first supported locale)
  final Locale? _initialLocale;

  /// The localization delegates
  final List<LocalizationsDelegate> delegates;

  /// The builder function that creates the app component
  final Component Function(BuildContext context, Locale locale) builder;

  /// Gets the initial locale, defaulting to the first supported locale
  Locale get initialLocale => _initialLocale ?? supportedLocales.first;

  @override
  State<LocalizationApp> createState() => _LocalizationAppState();
}

class _LocalizationAppState extends State<LocalizationApp> {
  late LocaleController _controller;

  void _onLocaleChanged() {
    print('_LocalizationAppState: Locale changed to ${_controller.currentLocale.toLanguageTag()}');
    print('_LocalizationAppState: Triggering rebuild...');
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    print('_LocalizationAppState: Initializing with locale: ${component.initialLocale.toLanguageTag()}');
    print(
      '_LocalizationAppState: Supported locales: ${component.supportedLocales.map((l) => l.toLanguageTag()).join(', ')}',
    );
    _controller = LocaleController(
      initialLocale: component.initialLocale,
      supportedLocales: component.supportedLocales,
    );
    _controller.addListener(_onLocaleChanged);
    print(
      '_LocalizationAppState: Controller initialized, current locale: ${_controller.currentLocale.toLanguageTag()}',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    return LocaleProvider.withController(
      controller: _controller,
      delegates: component.delegates,
      supportedLocales: component.supportedLocales.toSet(),
      child: LocaleBuilder(controller: _controller, builder: component.builder),
    );
  }
}
