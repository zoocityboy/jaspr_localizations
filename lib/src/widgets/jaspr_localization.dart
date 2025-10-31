import 'package:jaspr/jaspr.dart';
import 'package:jaspr_localizations/src/base/locale.dart';
import 'package:jaspr_localizations/src/base/locale_change_notifier.dart';
import 'package:jaspr_localizations/src/base/localizations_delegate.dart';
import 'package:jaspr_localizations/src/jaspr_l10n_core.dart';
import 'package:jaspr_localizations/src/widgets/jaspr_locale_builder.dart';

/// A convenience component that combines LocaleProvider with automatic rebuilding
class JasprLocalizations extends StatefulComponent {
  /// Creates a LocalizationApp with locale switching capabilities
  const JasprLocalizations({
    required this.supportedLocales,
    Locale? initialLocale,
    this.delegates = const [],
    required this.builder,
    super.key,
  }) : _initialLocale = initialLocale;

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
  State<JasprLocalizations> createState() => _LocalizationAppState();
}

class _LocalizationAppState extends State<JasprLocalizations> {
  late LocaleChangeNotifier _controller;

  void _onLocaleChanged() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _controller = LocaleChangeNotifier(
      initialLocale: component.initialLocale,
      supportedLocales: component.supportedLocales,
    );
    _controller.addListener(_onLocaleChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
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
