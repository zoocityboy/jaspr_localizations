import 'package:example/generated/l10n.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_localizations/jaspr_localizations.dart';

@client
class LanguageComponent extends StatelessComponent {
  const LanguageComponent({super.key});

  /// Helper method to get display name for a locale
  String _getLanguageDisplayName(Locale locale) {
    final languageTag = locale.toLanguageTag();
    switch (languageTag) {
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      case 'fr':
        return 'Français';
      case 'de':
        return 'Deutsch';
      case 'zh-CN':
        return '中文 (简体)';
      case 'zh-TW':
        return '中文 (繁體)';
      case 'ja':
        return '日本語';
      case 'ko':
        return '한국어';
      case 'it':
        return 'Italiano';
      case 'pt':
        return 'Português';
      case 'pt-BR':
        return 'Português (Brasil)';
      case 'ru':
        return 'Русский';
      case 'ar':
        return 'العربية';
      case 'hi':
        return 'हिन्दी';
      case 'nl':
        return 'Nederlands';
      case 'pl':
        return 'Polski';
      case 'cs':
        return 'Čeština';
      case 'sk':
        return 'Slovenčina';
      default:
        // Fallback: capitalize the language code
        return locale.languageCode.toUpperCase();
    }
  }

  @override
  Component build(BuildContext context) {
    if (!kIsWeb) return div([text('LanguageComponent is only available on web.')]);
    final provider = LocaleProvider.of(context);
    final currentLocale = provider.currentLocale;

    // Get localized strings using direct instantiation from current locale
    final l10n = L10n.from(currentLocale.toLanguageTag());

    return div([
      h1([text(l10n.appTitle)]),
      p([text(l10n.welcomeMessage('Jaspr'))]),
      p([text(l10n.itemCount(5))]),
      p([text(l10n.currentLocale(currentLocale.toLanguageTag()))]),

      div(classes: 'mt-4', [
        h2([text('Language Switcher')]),
        div(classes: 'flex gap-2', [
          // Generate buttons dynamically for all supported locales
          ...provider.supportedLocales.map((locale) {
            final isActive = currentLocale == locale;
            final languageCode = locale.languageCode;
            final displayName = _getLanguageDisplayName(locale);

            return button(
              classes: isActive ? 'btn btn-primary' : 'btn btn-outline',
              onClick: () {
                print('🌍 $displayName button clicked (${locale.toLanguageTag()})');
                if (locale.countryCode != null) {
                  LocaleProvider.setLanguage(context, languageCode, locale.countryCode);
                } else {
                  LocaleProvider.setLanguage(context, languageCode);
                }
              },
              [text(displayName)],
            );
          }),
        ]),
      ]),

      div(classes: 'mt-4', [
        div(classes: 'flex gap-2', [
          button(classes: 'btn', [text(l10n.loginButton)]),
          button(classes: 'btn', [text(l10n.logoutButton)]),
        ]),
      ]),

      div(classes: 'mt-4', [
        h2([text('Supported Locales:')]),
        ul([
          ...provider.supportedLocales.map(
            (locale) => li(classes: locale == currentLocale ? 'font-bold text-primary' : '', [
              text('${locale.toLanguageTag()} ${locale == currentLocale ? '(current)' : ''}'),
            ]),
          ),
        ]),
      ]),

      div(classes: 'mt-4', [
        h2([text('Gender-specific Messages:')]),
        div(classes: 'space-y-2', [
          p([text('Male: ${l10n.genderMessage('male')}')]),
          p([text('Female: ${l10n.genderMessage('female')}')]),
          p([text('Other: ${l10n.genderMessage('other')}')]),
        ]),
      ]),

      div(classes: 'mt-4', [
        h2([text('Advanced Formatting Examples:')]),
        div(classes: 'space-y-2', [
          div(classes: 'bg-base-200 p-4 rounded', [
            h3(classes: 'font-bold', [text('Currency Formatting:')]),
            p([text(l10n.priceDisplay(123.45))]),
            p([text(l10n.priceDisplay(9999.99))]),
          ]),
          div(classes: 'bg-base-200 p-4 rounded', [
            h3(classes: 'font-bold', [text('Number Formatting:')]),
            p([text(l10n.downloadCount('1,234'))]),
            p([text(l10n.downloadCount('5,678,900'))]),
          ]),
          div(classes: 'bg-base-200 p-4 rounded', [
            h3(classes: 'font-bold', [text('Percentage Formatting:')]),
            p([text(l10n.percentageValue(75))]),
            p([text(l10n.percentageValue(12.5))]),
          ]),
          div(classes: 'bg-base-200 p-4 rounded', [
            h3(classes: 'font-bold', [text('Complex Report:')]),
            p([text(l10n.salesReport(15000.50, 2500, 15))]),
          ]),
          div(classes: 'bg-base-200 p-4 rounded', [
            h3(classes: 'font-bold', [text('Date/Time Formatting:')]),
            p([text(l10n.lastUpdated(DateTime.now()))]),
            p([text(l10n.timeRemaining(DateTime.now().add(const Duration(hours: 2, minutes: 30))))]),
          ]),
        ]),
      ]),

      div(classes: 'mt-4', [
        h2([text('All Translations:')]),
        div(classes: 'space-y-2', [
          p([text('Title: ${l10n.appTitle}')]),
          p([text('Welcome: ${l10n.welcomeMessage('Jaspr')}')]),
          p([text('Items: ${l10n.itemCount(3)}')]),
          p([text('Login: ${l10n.loginButton}')]),
          p([text('Logout: ${l10n.logoutButton}')]),
          p([text('Locale: ${l10n.currentLocale(currentLocale.toLanguageTag())}')]),
        ]),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.mt-4', [
      css('&').styles(margin: Margin.only(top: 1.rem)),
    ]),
    css('.ml-4', [
      css('&').styles(margin: Margin.only(left: 1.rem)),
    ]),
    css('.p-4', [
      css('&').styles(padding: Padding.all(1.rem)),
    ]),
    css('.rounded', [
      css('&').styles(radius: BorderRadius.circular(0.5.rem)),
    ]),
    css('.bg-base-200', [
      css('&').styles(backgroundColor: const Color('#f3f4f6')),
    ]),
    css('.flex', [
      css('&').styles(display: Display.flex),
    ]),
    css('.gap-2 > * + *', [
      css('&').styles(margin: Margin.only(left: 0.5.rem)),
    ]),
    css('.space-y-2 > * + *', [
      css('&').styles(margin: Margin.only(top: 0.5.rem)),
    ]),
    css('.font-bold', [
      css('&').styles(fontWeight: FontWeight.bold),
    ]),
    css('.text-primary', [
      css('&').styles(color: Colors.blue),
    ]),
    css('h3', [
      css('&').styles(
        fontSize: 1.2.em,
        fontWeight: FontWeight.w600,
        margin: Margin.only(bottom: 0.5.rem),
      ),
    ]),
    css('.btn', [
      css('&').styles(
        padding: Padding.symmetric(horizontal: 1.rem, vertical: 0.5.rem),
        border: Border.symmetric(
          horizontal: BorderSide(color: const Color('#ccc'), width: 1.px),
          vertical: BorderSide(color: const Color('#ccc'), width: 1.px),
        ),
        radius: BorderRadius.circular(4.px),
        cursor: Cursor.pointer,
        textDecoration: const TextDecoration(line: TextDecorationLine.none),
        backgroundColor: Colors.white,
      ),
      css('&:hover').styles(
        backgroundColor: const Color('#f0f0f0'),
      ),
    ]),
    css('.btn-primary', [
      css('&').styles(
        border: Border.symmetric(
          horizontal: BorderSide(color: Colors.blue, width: 1.px),
          vertical: BorderSide(color: Colors.blue, width: 1.px),
        ),
        color: Colors.white,
        backgroundColor: Colors.blue,
      ),
      css('&:hover').styles(
        backgroundColor: const Color('#1e40af'),
      ),
    ]),
    css('.btn-outline', [
      css('&').styles(
        border: Border.symmetric(
          horizontal: BorderSide(color: const Color('#6b7280'), width: 1.px),
          vertical: BorderSide(color: const Color('#6b7280'), width: 1.px),
        ),
        color: const Color('#6b7280'),
        backgroundColor: Colors.white,
      ),
      css('&:hover').styles(
        backgroundColor: const Color('#f3f4f6'),
      ),
    ]),
    css('.btn-outline-primary', [
      css('&').styles(
        border: Border.symmetric(
          horizontal: BorderSide(color: Colors.blue, width: 1.px),
          vertical: BorderSide(color: Colors.blue, width: 1.px),
        ),
        color: Colors.blue,
        backgroundColor: Colors.white,
      ),
      css('&:hover').styles(
        backgroundColor: const Color('#dbeafe'),
      ),
    ]),
    css('.btn-outline-secondary', [
      css('&').styles(
        border: Border.symmetric(
          horizontal: BorderSide(color: Colors.green, width: 1.px),
          vertical: BorderSide(color: Colors.green, width: 1.px),
        ),
        color: Colors.green,
        backgroundColor: Colors.white,
      ),
      css('&:hover').styles(
        backgroundColor: const Color('#dcfce7'),
      ),
    ]),
    css('.btn-outline-accent', [
      css('&').styles(
        border: Border.symmetric(
          horizontal: BorderSide(color: Colors.purple, width: 1.px),
          vertical: BorderSide(color: Colors.purple, width: 1.px),
        ),
        color: Colors.purple,
        backgroundColor: Colors.white,
      ),
      css('&:hover').styles(
        backgroundColor: const Color('#faf5ff'),
      ),
    ]),
    css('.btn-info', [
      css('&').styles(
        border: Border.symmetric(
          horizontal: BorderSide(color: Colors.teal, width: 1.px),
          vertical: BorderSide(color: Colors.teal, width: 1.px),
        ),
        color: Colors.white,
        backgroundColor: Colors.teal,
      ),
      css('&:hover').styles(
        backgroundColor: const Color('#0f766e'),
      ),
    ]),
  ];
}
