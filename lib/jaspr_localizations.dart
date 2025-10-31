/// Jaspr Localizations - Internationalization and localization for Jaspr applications.
///
/// A comprehensive localization solution for Jaspr applications that provides
/// locale management, automatic UI rebuilding on locale changes, and ARB file
/// processing for translations.
///
/// ## Features
///
/// * **Locale Management**: Built-in locale switching with [JasprLocalizations]
/// * **Platform Detection**: Automatic language detection from browser or system
/// * **ARB Processing**: Flutter-aligned ARB file processing with code generation
/// * **Reactive Updates**: Automatic UI rebuilding when locale changes
/// * **Type Safety**: Generated classes provide compile-time safety for translations
///
/// ## Quick Start
///
/// ### 1. Add ARB Files
///
/// Create ARB (Application Resource Bundle) files in `lib/l10n/`:
///
/// ```
/// lib/l10n/
///   ├── app_en.arb  (template - required)
///   ├── app_es.arb
///   ├── app_fr.arb
///   └── app_de.arb
/// ```
///
/// Example `app_en.arb`:
/// ```json
/// {
///   "@@locale": "en",
///   "welcomeMessage": "Welcome to our app!",
///   "greeting": "Hello, {name}!",
///   "@greeting": {
///     "placeholders": {
///       "name": {
///         "type": "String"
///       }
///     }
///   }
/// }
/// ```
///
/// ### 2. Configure l10n.yaml
///
/// Create `l10n.yaml` in your project root:
/// ```yaml
/// arb-dir: lib/l10n
/// template-arb-file: app_en.arb
/// output-localization-file: l10n.dart
/// output-class: AppLocalizations
/// ```
///
/// ### 3. Wrap Your App
///
/// Use [JasprLocalizations] to add localization to your app:
///
/// ```dart
/// import 'package:jaspr/jaspr.dart';
/// import 'package:jaspr_localizations/jaspr_localizations.dart';
/// import 'package:example/generated/l10n.dart';
///
/// class App extends StatelessComponent {
///   @override
///   Component build(BuildContext context) {
///     return JasprLocalizations(
///       supportedLocales: [
///         Locale('en', 'US'),
///         Locale('es', 'ES'),
///         Locale('fr', 'FR'),
///       ],
///       delegates: [AppLocalizations.delegate],
///       builder: (context, locale) {
///         return MyHomePage();
///       },
///     );
///   }
/// }
/// ```
///
/// ### 4. Access Localized Strings
///
/// ```dart
/// class MyComponent extends StatelessComponent {
///   @override
///   Component build(BuildContext context) {
///     final l10n = AppLocalizations.of(context);
///
///     return div([
///       text(l10n.welcomeMessage),
///       text(l10n.greeting('Alice')),
///     ]);
///   }
/// }
/// ```
///
/// ### 5. Change Locale at Runtime
///
/// ```dart
/// // Switch to Spanish
/// JasprLocalizationProvider.setLanguage(context, 'es', 'ES');
///
/// // Or use Locale object
/// JasprLocalizationProvider.setLocale(context, Locale('fr', 'FR'));
/// ```
///
/// ## Advanced Usage
///
/// ### Platform-Aware Language Detection
///
/// Detect the user's preferred language from browser or system:
///
/// ```dart
/// import 'package:jaspr_localizations/jaspr_localizations.dart';
///
/// void main() {
///   // Get current locale from browser/platform
///   final locale = getCurrentLocale();
///
///   runApp(
///     JasprLocalizations(
///       supportedLocales: supportedLocales,
///       initialLocale: locale,  // Use detected locale
///       delegates: [AppLocalizations.delegate],
///       builder: (context, locale) => MyApp(),
///     ),
///   );
/// }
/// ```
///
/// ### Scoped Locale Override
///
/// Display specific content in a different locale:
///
/// ```dart
/// JasprLocalizations.withLocale(
///   locale: Locale('es', 'ES'),
///   child: PreviewWidget(),
/// )
/// ```
///
/// ### Listen to Locale Changes
///
/// ```dart
/// class LocaleListener extends StatefulComponent {
///   @override
///   State createState() => _LocaleListenerState();
/// }
///
/// class _LocaleListenerState extends State<LocaleListener> {
///   @override
///   void didChangeDependencies() {
///     super.didChangeDependencies();
///     final locale = JasprLocalizationProvider.of(context).currentLocale;
///     print('Locale changed to: ${locale.toLanguageTag()}');
///   }
///
///   @override
///   Component build(BuildContext context) {
///     return div([text('Locale: ${JasprLocalizationProvider.of(context).currentLocale}')]);
///   }
/// }
/// ```
///
/// ## Core Components
///
/// * [JasprLocalizations] - High-level component with automatic rebuilding
/// * [JasprLocalizationProvider] - Low-level provider for locale information
/// * [Locale] - Represents a language/country combination
/// * [LocaleChangeNotifier] - Controller for managing locale state
/// * [getCurrentLocale] - Detects user's preferred locale
/// * [getCurrentLanguageCode] - Gets language code from browser/platform
/// * [languageCodeToLocale] - Parses language code strings to Locale objects
///
/// ## See Also
///
/// * [Jaspr Documentation](https://docs.page/schultek/jaspr)
/// * [Flutter Internationalization](https://docs.flutter.dev/development/accessibility-and-localization/internationalization)
/// * [ARB Format Specification](https://github.com/google/app-resource-bundle)
library;

// export 'package:intl/intl.dart';

export 'src/jaspr_l10n_core.dart';
export 'src/jaspr_l10n_types.dart';
export 'src/utils/localizations_utils.dart';
export 'src/utils/current_language.dart';
export 'src/widgets/jaspr_localization.dart';
export 'src/base/locale.dart';
export 'src/base/locale_change_notifier.dart';
export 'src/base/localizations_delegate.dart';
export 'src/base/builder.dart';
