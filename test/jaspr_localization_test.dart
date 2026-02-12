import 'package:jaspr/dom.dart';
import 'package:jaspr_localizations/jaspr_localizations.dart';
import 'package:test/test.dart';

void main() {
  final supportedLocales = {
    const Locale('en', 'US'),
    const Locale('es', 'ES'),
    const Locale('fr', 'FR'),
  };

  group('Locale Tests', () {
    test('Locale creates correctly with language code only', () {
      const locale = Locale('en');
      expect(locale.languageCode, equals('en'));
      expect(locale.countryCode, isNull);
      expect(locale.toLanguageTag(), equals('en'));
    });

    test('Locale creates correctly with language and country code', () {
      const locale = Locale('en', 'US');
      expect(locale.languageCode, equals('en'));
      expect(locale.countryCode, equals('US'));
      expect(locale.toLanguageTag(), equals('en_US'));
    });

    test('Locale.fromLanguageTag parses correctly', () {
      final locale1 = Locale.fromLanguageTag('en');
      expect(locale1.languageCode, equals('en'));
      expect(locale1.countryCode, isNull);

      final locale2 = Locale.fromLanguageTag('en_US');
      expect(locale2.languageCode, equals('en'));
      expect(locale2.countryCode, equals('US'));
    });

    test('Locale equality works correctly', () {
      const locale1 = Locale('en', 'US');
      const locale2 = Locale('en', 'US');
      const locale3 = Locale('en', 'GB');

      expect(locale1 == locale2, isTrue);
      expect(locale1 == locale3, isFalse);
    });

    test('Locale toString returns language tag', () {
      const locale = Locale('en', 'US');
      expect(locale.toString(), equals('en_US'));
    });
  });

  group('LocaleProvider Tests', () {
    test('LocaleProvider stores locale correctly', () {
      const testLocale = Locale('en', 'US');
      final provider = JasprLocalizationProvider(
        locale: testLocale,
        supportedLocales: supportedLocales,
        child: div([]),
      );

      expect(provider.locale, equals(testLocale));
    });

    test('LocaleProvider stores supported locales correctly', () {
      const testLocale = Locale('en', 'US');
      final provider = JasprLocalizationProvider(
        locale: testLocale,
        supportedLocales: supportedLocales,
        child: div([]),
      );

      expect(provider.supportedLocales, equals(supportedLocales));
    });

    test('updateShouldNotify returns true when locale changes', () {
      final oldProvider = JasprLocalizationProvider(
        locale: const Locale('en', 'US'),
        supportedLocales: supportedLocales,
        child: div([]),
      );
      final newProvider = JasprLocalizationProvider(
        locale: const Locale('es', 'ES'),
        supportedLocales: supportedLocales,
        child: div([]),
      );

      expect(newProvider.updateShouldNotify(oldProvider), isTrue);
    });

    test('updateShouldNotify returns true when supported locales change', () {
      final oldProvider = JasprLocalizationProvider(
        locale: const Locale('en', 'US'),
        supportedLocales: supportedLocales,
        child: div([]),
      );
      final newProvider = JasprLocalizationProvider(
        locale: const Locale('en', 'US'),
        supportedLocales: {const Locale('en', 'US')},
        child: div([]),
      );

      expect(newProvider.updateShouldNotify(oldProvider), isTrue);
    });

    test(
      'updateShouldNotify returns false when locale and supported locales stay the same',
      () {
        final oldProvider = JasprLocalizationProvider(
          locale: const Locale('en', 'US'),
          supportedLocales: supportedLocales,
          child: div([]),
        );
        final newProvider = JasprLocalizationProvider(
          locale: const Locale('en', 'US'),
          supportedLocales: supportedLocales,
          child: div([]),
        );

        expect(newProvider.updateShouldNotify(oldProvider), isFalse);
      },
    );
  });
}
