import 'package:jaspr/jaspr.dart';
import 'package:jaspr_localizations/src/base/locale.dart';
import 'package:jaspr_localizations/src/base/locale_change_notifier.dart';
import 'package:jaspr_localizations/src/base/localizations_delegate.dart';
import 'package:jaspr_localizations/src/jaspr_l10n_core.dart';
import 'package:jaspr_localizations/src/widgets/jaspr_locale_builder.dart';

/// A high-level component that combines locale provision with automatic rebuilding.
///
/// [JasprLocalizations] is the recommended way to add localization to your
/// Jaspr application. It handles both locale management and automatic UI
/// updates when the locale changes.
///
/// ### Features
///
/// * **Locale Management**: Maintains current locale state with a built-in controller
/// * **Automatic Rebuilding**: Rebuilds the UI when locale changes
/// * **Delegate Integration**: Works with localization delegates for resource loading
/// * **Flexible Initialization**: Supports custom initial locale or defaults to first supported
///
/// ### Basic Usage
///
/// ```dart
/// class App extends StatelessComponent {
///   @override
///   Component build(BuildContext context) sync* {
///     return JasprLocalizations(
///       supportedLocales: [
///         Locale('en', 'US'),
///         Locale('es', 'ES'),
///         Locale('fr', 'FR'),
///       ],
///       initialLocale: Locale('en', 'US'),
///       delegates: [AppLocalizations.delegate],
///       builder: (context, locale) {
///         return MyHomePage();
///       },
///     );
///   }
/// }
/// ```
///
/// ### Changing Locale at Runtime
///
/// ```dart
/// // From anywhere in the widget tree
/// JasprLocalizationProvider.setLanguage(context, 'es', 'ES');
/// ```
///
/// ### Accessing Current Locale
///
/// ```dart
/// final provider = JasprLocalizationProvider.of(context);
/// final currentLocale = provider.currentLocale;
/// print('Current: ${currentLocale.languageCode}');
/// ```
///
/// See also:
/// * [JasprLocalizationProvider], the underlying provider component
/// * [LocaleChangeNotifier], the controller for locale state
/// * [withLocale], for creating scoped locale overrides
class JasprLocalizations extends StatefulComponent {
  /// Creates a [JasprLocalizations] with locale switching capabilities.
  ///
  /// ### Parameters
  ///
  /// * [supportedLocales]: A list of all locales that your application supports.
  ///   This is required and must contain at least one locale.
  ///
  /// * [initialLocale]: The locale to use when the app first starts. If not provided,
  ///   defaults to the first locale in [supportedLocales].
  ///
  /// * [delegates]: A list of [LocalizationsDelegate] objects that load and provide
  ///   localized resources. Each delegate handles a specific type of localization
  ///   (e.g., app-specific translations, date formatting, etc.).
  ///
  /// * [builder]: A function that builds your app's UI. It receives the current
  ///   [BuildContext] and active [Locale], allowing you to access localized
  ///   resources and build locale-aware UI.
  ///
  /// * [key]: An optional key to use for the component.
  ///
  /// ### Example
  ///
  /// ```dart
  /// JasprLocalizations(
  ///   supportedLocales: [
  ///     Locale('en', 'US'),
  ///     Locale('es', 'ES'),
  ///     Locale('fr', 'FR'),
  ///     Locale('de', 'DE'),
  ///   ],
  ///   initialLocale: Locale('en', 'US'),
  ///   delegates: [
  ///     AppLocalizations.delegate,
  ///     // Add more delegates as needed
  ///   ],
  ///   builder: (context, locale) {
  ///     // Build your app UI here
  ///     // The UI will rebuild automatically when locale changes
  ///     return MaterialApp(
  ///       home: HomePage(),
  ///     );
  ///   },
  /// )
  /// ```
  const JasprLocalizations({
    required this.supportedLocales,
    Locale? initialLocale,
    this.delegates = const [],
    required this.builder,
    super.key,
  }) : _initialLocale = initialLocale;

  /// Creates a scoped [JasprLocalizations] with a specific locale.
  ///
  /// This static factory method creates a localization scope that overrides
  /// the locale for a specific part of the widget tree, while keeping the
  /// same supported locales and delegates from the parent provider.
  ///
  /// Use this when you need to display specific content in a different
  /// locale than the rest of the app (e.g., showing a preview in another language).
  ///
  /// ### Parameters
  ///
  /// * [locale]: The locale to use for this scoped section. Must be one of
  ///   the supported locales from the parent provider.
  ///
  /// * [child]: The widget subtree to render with the overridden locale.
  ///
  /// * [key]: An optional key for the component.
  ///
  /// ### Example
  ///
  /// ```dart
  /// // Display a preview in Spanish while the rest of the app is in English
  /// JasprLocalizations.withLocale(
  ///   locale: Locale('es', 'ES'),
  ///   child: PreviewWidget(),
  /// )
  /// ```
  ///
  /// ### Assertions
  ///
  /// Throws an [AssertionError] if the provided [locale] is not in the
  /// list of supported locales from the parent provider.
  static StatelessComponent withLocale({
    required Locale locale,
    required Component child,
    Key? key,
  }) {
    return Builder(
      builder: (context) {
        final l10n = JasprLocalizationProvider.of(context);
        assert(
          l10n.supportedLocales.contains(locale),
          'Locale $locale is not supported by the current JasprLocalizationProvider',
        );
        return JasprLocalizations(
          supportedLocales: l10n.supportedLocales.toList(),
          initialLocale: locale,
          delegates: l10n.delegates,
          builder: (context, locale) => child,
          key: key,
        );
      },
    );
  }

  /// The list of locales supported by this application.
  ///
  /// This should include all locales for which you have provided
  /// localized resources through your delegates.
  ///
  /// Users can switch between any of these locales at runtime using
  /// [JasprLocalizationProvider.setLocale] or [JasprLocalizationProvider.setLanguage].
  final List<Locale> supportedLocales;

  /// The initial locale to use when the app starts.
  ///
  /// This is stored privately and accessed through [initialLocale] getter
  /// to provide a default value if not specified.
  final Locale? _initialLocale;

  /// The localization delegates that provide localized resources.
  ///
  /// Each delegate is responsible for loading and providing a specific
  /// type of localized data (translations, date formats, etc.).
  final List<LocalizationsDelegate> delegates;

  /// The builder function that creates the app's UI.
  ///
  /// This function is called with the current [BuildContext] and active [Locale].
  /// It will be called again automatically whenever the locale changes,
  /// allowing the UI to update with new localized content.
  ///
  /// ### Example
  ///
  /// ```dart
  /// builder: (context, locale) {
  ///   final l10n = AppLocalizations.of(context);
  ///   return Text(l10n.welcomeMessage);
  /// }
  /// ```
  final Component Function(BuildContext context, Locale locale) builder;

  /// Gets the initial locale, defaulting to the first supported locale.
  ///
  /// If [initialLocale] was provided in the constructor, returns that.
  /// Otherwise, returns the first locale from [supportedLocales].
  Locale get initialLocale => _initialLocale ?? supportedLocales.first;

  @override
  State<JasprLocalizations> createState() => _JasprLocalizationsState();
}

/// The state for [JasprLocalizations].
///
/// This state class manages the [LocaleChangeNotifier] controller and
/// listens for locale changes, triggering rebuilds when necessary.
class _JasprLocalizationsState extends State<JasprLocalizations> {
  /// The controller that manages the current locale state.
  late LocaleChangeNotifier _controller;

  /// Called when the locale changes in the controller.
  ///
  /// This triggers a rebuild of the widget tree to reflect the new locale.
  void _onLocaleChanged() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    // Create the locale controller with initial settings
    _controller = LocaleChangeNotifier(
      initialLocale: component.initialLocale,
      supportedLocales: component.supportedLocales,
    );

    // Listen for locale changes
    _controller.addListener(_onLocaleChanged);
  }

  @override
  void dispose() {
    // Clean up the listener when the widget is disposed
    _controller.dispose();
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    // Wrap the app with the localization provider and builder
    return JasprLocalizationProvider.withController(
      controller: _controller,
      delegates: component.delegates,
      supportedLocales: component.supportedLocales.toSet(),
      child: JasprLocaleBuilder(
        controller: _controller,
        builder: component.builder,
      ),
    );
  }
}
