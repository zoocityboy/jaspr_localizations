import 'package:jaspr_localizations/jaspr_localizations.dart';
import 'package:jaspr_localizations/src/base/locale.dart';
import 'package:test/test.dart';

void main() {
  group('languageCodeToLocale', () {
    test('converts simple language code', () {
      final locale = languageCodeToLocale('en');
      expect(locale.languageCode, equals('en'));
      expect(locale.countryCode, isNull);
    });

    test('converts language code with hyphen separator', () {
      final locale = languageCodeToLocale('en-US');
      expect(locale.languageCode, equals('en'));
      expect(locale.countryCode, equals('US'));
    });

    test('converts language code with underscore separator', () {
      final locale = languageCodeToLocale('en_US');
      expect(locale.languageCode, equals('en'));
      expect(locale.countryCode, equals('US'));
    });

    test('handles lowercase country codes', () {
      final locale = languageCodeToLocale('en-us');
      expect(locale.languageCode, equals('en'));
      expect(locale.countryCode, equals('US'));
    });

    test('handles uppercase language codes', () {
      final locale = languageCodeToLocale('EN-US');
      expect(locale.languageCode, equals('en'));
      expect(locale.countryCode, equals('US'));
    });

    test('handles complex language tags with script code', () {
      // zh-Hans-CN should extract 'zh' as language and 'CN' as country
      final locale = languageCodeToLocale('zh-Hans-CN');
      expect(locale.languageCode, equals('zh'));
      expect(locale.countryCode, equals('CN'));
    });

    test('handles whitespace in language code', () {
      final locale = languageCodeToLocale(' en-US ');
      expect(locale.languageCode, equals('en'));
      expect(locale.countryCode, equals('US'));
    });

    test('returns default locale for empty string', () {
      final locale = languageCodeToLocale('');
      expect(locale.languageCode, equals('en'));
      expect(locale.countryCode, isNull);
    });
  });

  group('getCurrentLanguageCode', () {
    test('returns a valid language code', () {
      final code = getCurrentLanguageCode();
      expect(code, isNotEmpty);
      expect(code, isNot(equals('null')));
    });
  });

  group('getCurrentLocale', () {
    test('returns a valid Locale object', () {
      final locale = getCurrentLocale();
      expect(locale, isA<Locale>());
      expect(locale.languageCode, isNotEmpty);
    });
  });
}
