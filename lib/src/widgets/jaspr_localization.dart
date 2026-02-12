import 'package:jaspr/jaspr.dart';
import '../utils/locale_data_initializer.dart';
import 'package:jaspr_localizations/src/base/locale.dart';
import 'package:jaspr_localizations/src/base/locale_change_notifier.dart';
import 'package:jaspr_localizations/src/base/localizations_delegate.dart';
import 'package:jaspr_localizations/src/jaspr_l10n_core.dart';
import 'package:jaspr_localizations/src/widgets/jaspr_locale_builder.dart';

/// A widget that manages locale state and rebuilds the UI when the locale changes.
///
/// [JasprLocalizations] is the primary entry point for adding localization to a Jaspr app.
/// It wraps the application in a [JasprLocalizationProvider] and a [JasprLocaleBuilder],
/// ensuring the UI updates automatically.
///
///
class JasprLocalizations extends StatefulComponent {
  /// Creates a [JasprLocalizations] widget.
  ///
  /// Requires the list of [supportedLocales] and a [builder] function that returns
  /// the app's root component.
  const JasprLocalizations({
    required this.supportedLocales,
    Locale? initialLocale,
    this.delegates = const [],
    required this.builder,
    super.key,
  }) : _initialLocale = initialLocale;

  /// Creates a scoped localization override.
  ///
  /// Useful for displaying a part of the UI in a specific [locale] (e.g., a preview).
  /// The [locale] must be one of the supported locales from the parent provider.
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

  /// The list of supported locales.
  final List<Locale> supportedLocales;

  final Locale? _initialLocale;

  /// Localization delegates.
  final List<LocalizationsDelegate> delegates;

  /// The builder function for the widget tree.
  final Component Function(BuildContext, Locale) builder;

  /// The initial locale, defaulting to the first supported locale.
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

    // Initialize Intl date formatting data for the supported locales.
    // On the web, the browser provides Intl data so we don't need to load
    // it. On server-side rendering, initialize for all supported locales
    // (cached) to avoid LocaleDataException when DateFormat is used.
    LocaleDataInitializer.initializeForLocales(
          component.supportedLocales.map((l) => l.toLanguageTag()),
        )
        .then((_) {
          if (kIsWeb) setState(() {});
        })
        .catchError((e) {
          if (kIsWeb) setState(() {});
        });
    // Listen for locale changes
    _controller.addListener(_onLocaleChanged);
  }

  // Initialization now handled via LocaleDataInitializer

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
