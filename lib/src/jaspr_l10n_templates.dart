// Copyright 2025 zoocityboy. All rights reserved.
// Use of this source code is governed by a MIT that can be
// found in the LICENSE file.

// Code generation templates for Jaspr localization
// Based on Flutter's gen_l10n_templates.dart but adapted for Jaspr framework

const fileTemplate = '''
// ignore_for_file: type=lint

import 'package:intl/intl.dart' as intl;

import '@{importFile}';

// ignore_for_file: type=lint

/// The translations for @{locale} (`@{locale}`).
class @{class} extends @{baseClass} {
  @{class}([String locale = '@{locale}']) : super(locale);

@{classMethods}
}
''';

const classMethodTemplate = '''

  @override
  String @{methodName}(@{methodParameters}) {
    @{dateFormatting}
    @{numberFormatting}
    return @{message};
  }
''';

const getterMethodTemplate = '''

  @override
  String get @{methodName} => @{message};
''';

const constructorParametersTemplate = '''
{
    String localeName = '@{locale}',
    @{parameters}
  }''';

const delegateClassTemplate = '''

class @{delegateClass} extends LocalizationsDelegate<@{class}> {
  const @{delegateClass}();

  @override
  Future<@{class}> load(Locale locale) {
    return SynchronousFuture<@{class}>(@{class}.fromSTring(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[@{supportedLanguageCodes}].contains(locale.languageCode);

  @override
  bool shouldReload(@{delegateClass} old) => false;
}
''';

const baseClassTemplate = '''
abstract class @{class} {
  @{class}(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static @{class} of(BuildContext context) {
    return Localizations.of(context, @{class})!;
  }

  static const LocalizationsDelegate<@{class}> delegate = @{delegateClass}();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list is useful when a region has a language that
  /// Flutter does not support by default or when you have custom
  /// localizations of your own.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
@{supportedLocales}
  ];

@{classMethods}
}
''';

const supportedLocalesTemplate = '''
    Locale('@{languageCode}'@{countryCode})@{commaOrEmpty}''';

const baseClassMethodTemplate = '''

  /// No description provided for @{methodName}.
  ///
  /// In @{localeVar}, this message translates to:
  /// **'@{message}'**
  String @{methodName}(@{methodParameters});
''';

const baseClassGetterTemplate = '''

  /// No description provided for @{methodName}.
  ///
  /// In @{localeVar}, this message translates to:
  /// **'@{message}'**
  String get @{methodName};
''';

const dateFormattingTemplate = '''
    final intl.DateFormat @{formatterName} = intl.DateFormat@{constructorCall}(@{parameters});''';

const numberFormattingTemplate = '''
    final intl.NumberFormat @{formatterName} = intl.NumberFormat@{constructorCall}(@{parameters});''';

const pluralMethodTemplate = '''

  @override
  String @{methodName}(@{methodParameters}) {
    @{dateFormatting}
    @{numberFormatting}
    return intl.Intl.plural(
      @{countParameter},
      @{pluralLogicArgs}
      name: '@{methodName}',
      desc: '@{desc}',
      args: <Object>[@{methodParametersWithoutTypes}],
    );
  }
''';

const selectMethodTemplate = '''

  @override
  String @{methodName}(@{methodParameters}) {
    @{dateFormatting}
    @{numberFormatting}
    return intl.Intl.select(
      @{selectParameter},
      <String, String>{
        @{selectCases}
      },
      name: '@{methodName}',
      desc: '@{desc}',
      args: <Object>[@{methodParametersWithoutTypes}],
    );
  }
''';

const dateMethodTemplate = '''

  @override
  String @{methodName}(@{methodParameters}) {
    @{dateFormatting}
    @{numberFormatting}
    return @{message};
  }
''';

// Simpler templates for Jaspr framework without Flutter's Localizations system
const jasprFileTemplate = '''
// ignore_for_file: type=lint

import 'package:intl/intl.dart' as intl;

/// The translations for @{locale} (`@{locale}`).
class @{class} extends @{baseClass} {
  @{class}([String locale = '@{locale}']) : super(locale);

  @{classMethods}
}
''';

const jasprBaseClassTemplate = '''
// ignore_for_file: type=lint

import 'package:intl/intl.dart' as intl;
import 'package:jaspr_localizations/jaspr_localizations.dart';

abstract class @{class} {
  @{class}(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  /// Retrieve the [@{class}] instance from the context.
  static @{class}? of(dynamic context) {
    // For Jaspr, we can't use Localizations.of() like Flutter
    // This would need to be implemented using Jaspr's provider system
    // For now, return null and let consumers handle this
    return null;
  }

  /// The delegate for this localizations class.
  static const @{class}Delegate delegate = @{class}Delegate();

  /// A list of this localizations delegate along with default delegates.
  static const List<dynamic> localizationsDelegates = <dynamic>[
    delegate,
    // Additional delegates would go here for Jaspr framework
  ];

  /// A list of supported locales.
  static const List<String> supportedLocales = <String>[
@{supportedLocalesStringList}
  ];

  /// A factory constructor to construct specific subclasses base on a locale.
  static @{class} from(String locale) {
    switch (locale) {
@{fromSwitchCases}
      default:
        return @{defaultClass}();
    }
  }

@{classMethods}
}

/// Delegate class for @{class} localizations.
class @{class}Delegate extends LocalizationsDelegate<@{class}> {
  const @{class}Delegate();

  /// A list of supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    @{supportedLocalesList}
  ];

  /// Whether this delegate supports the given locale.
  @override
  bool isSupported(Locale locale) {
    return supportedLocales.any((l) => l.languageCode == locale.languageCode);
  }

  /// Load the localizations for the given locale.
  @override
  Future<@{class}> load(Locale locale) async {
    return @{class}.from(locale.toLanguageTag());
  }
}
''';

const jasprFromSwitchCaseTemplate = '''
      case '@{locale}':
        return @{class}();''';
