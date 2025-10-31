import 'package:jaspr/jaspr.dart';
import 'package:jaspr_localizations/jaspr_localizations.dart';
import 'package:jaspr_localizations/src/base/locale.dart';

/// Example demonstrating how to get the current language from browser or platform
///
/// This example shows how to use the getCurrentLanguageCode() and getCurrentLocale()
/// functions which automatically detect whether the code is running on the client
/// (browser) or server and get the appropriate language preference.

@client
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
      h2([text('Language Detection Example')]),

      p([
        text('Detected language code: '),
        strong([text(languageCode)]),
      ]),

      p([
        text('Detected locale: '),
        strong([text(locale.toLanguageTag())]),
      ]),

      p([
        text('Manual locale conversion (en-US): '),
        strong([text(manualLocale.toLanguageTag())]),
      ]),

      hr(),

      h3([text('How it works:')]),
      ul([
        li([
          text('On the client (browser): Uses '),
          code([text('navigator.language')]),
          text(' or '),
          code([text('navigator.languages[0]')]),
        ]),
        li([
          text('On the server: Uses '),
          code([text('Intl.getCurrentLocale()')]),
          text(' from the platform'),
        ]),
      ]),

      h3([text('Usage in your app:')]),
      pre([
        code([
          text('''
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
          text('App is using locale: ${locale.toLanguageTag()}'),
          const LanguageDetectionExample(),
        ]);
      },
    );
  }
}
