// TODO: Fix dart:isolate issue with generated l10n
// import 'package:example/generated/l10n.dart';
import 'package:example/l10n/generated/app_l10n.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_localizations/jaspr_localizations.dart';

class LanguageComponent extends StatelessComponent {
  const LanguageComponent({super.key});

  @override
  Component build(BuildContext context) {
    final l10n = AppL10n.of(context)!;
    final provider = JasprLocalizationProvider.of(context);
    final currentLocale = provider.currentLocale;

    return div([
      h2([Component.text(l10n.appTitle)]),
      p([Component.text(l10n.currentLocale(currentLocale.toLanguageTag()))]),

      div(classes: 'mt-4', [
        h3([Component.text(l10n.languageSwitcher)]),
        div(classes: 'flex gap-2', [
          // Generate buttons dynamically for all supported locales
          ...provider.supportedLocales.map((locale) {
            final isActive = currentLocale == locale;
            final languageCode = locale.languageCode;
            final displayName = locale.languageCode;

            return button(
              classes: isActive ? 'btn btn-primary' : 'btn btn-outline',
              onClick: () {
                print('🌍 $displayName button clicked (${locale.toLanguageTag()})');
                JasprLocalizationProvider.setLanguage(
                  context,
                  languageCode,
                  locale.countryCode,
                );
              },
              
              [Component.text(displayName + (isActive ? l10n.currentLabel : ''))],
            );
          }),
        ]),
      ]),

      div(classes: 'mt-4', [
        div(classes: 'flex gap-2', [
          button(classes: 'btn', [Component.text(l10n.loginButton)]),
          button(classes: 'btn', [Component.text(l10n.logoutButton)]),
        ]),
      ]),

      div(classes: 'mt-4', [
        h2([Component.text('Supported Locales:')]),
        ul([
          ...provider.supportedLocales.map(
            (locale) => li(classes: locale == currentLocale ? 'font-bold text-primary' : '', [
              Component.text('${locale.toLanguageTag()} ${locale == currentLocale ? '(current)' : ''}'),
            ]),
          ),
        ]),
      ]),
      div(classes: 'mt-4', [
        h2([Component.text('Basic Translations:')]),
        div(classes: 'space-y-2', [
          p([Component.text('Title: ${l10n.appTitle}')]),
          p([Component.text('Login: ${l10n.loginButton}')]),
          p([Component.text('Logout: ${l10n.logoutButton}')]),
          p([Component.text('Locale: ${currentLocale.toLanguageTag()}')]),
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
        margin: Margin.only(bottom: 0.5.rem),
        fontSize: 1.2.em,
        fontWeight: FontWeight.w600,
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
