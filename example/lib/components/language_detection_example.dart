import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_localizations/jaspr_localizations.dart';

/// Example demonstrating how to get the current language from browser or platform
///
/// This example shows how to use the getCurrentLanguageCode() and getCurrentLocale()
/// functions which automatically detect whether the code is running on the client
/// (browser) or server and get the appropriate language preference.

class LanguageDetectionExample extends StatelessComponent {
  const LanguageDetectionExample({super.key});

  @override
  Component build(BuildContext context) {
    // Get the current language code from the browser (on client) or platform (on server)
    final languageCode = getCurrentLanguageCode();

    // Or get it as a Locale object directly
    final locale = getCurrentLocale();

    // You can also manually convert a language code to a Locale
    final manualLocale = languageCodeToLocale('en-US');

    return div([
      h2([Component.text('Language Detection Example')]),

      p([
        Component.text('Detected language code: '),
        strong([Component.text(languageCode)]),
      ]),

      p([
        Component.text('Detected locale: '),
        strong([Component.text(locale.toLanguageTag())]),
      ]),

      p([
        Component.text('Manual locale conversion (en-US): '),
        strong([Component.text(manualLocale.toLanguageTag())]),
      ]),

      hr(),

      h3([Component.text('How it works:')]),
      ul([
        li([
          Component.text('On the client (browser): Uses '),
          code([Component.text('navigator.language')]),
          Component.text(' or '),
          code([Component.text('navigator.languages[0]')]),
        ]),
        li([
          Component.text('On the server: Uses '),
          code([Component.text('Intl.getCurrentLocale()')]),
          Component.text(' from the platform'),
        ]),
      ]),

      h3([Component.text('Usage in your app:')]),
      pre([
        code([
          Component.text('''
// Get current language code as string
final langCode = getCurrentLanguageCode();
// Returns: 'en-US', 'es', 'fr-FR', etc.

// Get current locale as Locale object
final locale = getCurrentLocale();
// Returns: Locale('en', 'US'), Locale('es'), etc.

// Convert a language code to Locale
final locale = languageCodeToLocale('zh-Hans-CN');
// Returns: Locale('zh', 'CN')
'''),
        ]),
      ]),
    ]);
  }
}

/// Example showing how to use auto-detected language in JasprLocalization
class AutoLanguageApp extends StatelessComponent {
  const AutoLanguageApp({super.key});

  @override
  Component build(BuildContext context) {
    // Auto-detect the current locale
    final detectedLocale = getCurrentLocale();

    // Define your supported locales
    final supportedLocales = [
      const Locale('en'),
      const Locale('es'),
      const Locale('fr'),
      const Locale('de'),
      const Locale('zh', 'CN'),
    ];

    // Check if detected locale is supported, otherwise use default
    final initialLocale = supportedLocales.contains(detectedLocale) ? detectedLocale : supportedLocales.first;

    return JasprLocalizations(
      supportedLocales: supportedLocales,
      initialLocale: initialLocale,
      builder: (context, locale) {
        return div([
          Component.text('App is using locale: ${locale.toLanguageTag()}'),
          const LanguageDetectionExample(),
        ]);
      },
    );
  }
}
