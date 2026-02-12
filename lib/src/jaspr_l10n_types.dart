// Copyright 2025 zoocityboy. All rights reserved.
// Use of this source code is governed by a MIT that can be
// found in the LICENSE file.

// Based on Flutter's gen_l10n_types.dart but adapted for Jaspr framework

import 'package:intl/locale.dart';
import 'dart:convert';

import 'base/logger.dart';
import 'base/file_system.dart';
import 'utils/localizations_utils.dart';
import 'utils/message_parser.dart';

// The set of date formats that can be automatically localized.
// Based on Flutter's validDateFormats but adapted for Jaspr
const validDateFormats = <String>{
  'd',
  'E',
  'EEEE',
  'LLL',
  'LLLL',
  'M',
  'Md',
  'MEd',
  'MMM',
  'MMMd',
  'MMMEd',
  'MMMM',
  'MMMMd',
  'MMMMEEEEd',
  'QQQ',
  'QQQQ',
  'y',
  'yM',
  'yMd',
  'yMEd',
  'yMMM',
  'yMMMd',
  'yMMMEd',
  'yMMMM',
  'yMMMMd',
  'yMMMMEEEEd',
  'yQQQ',
  'yQQQQ',
  'H',
  'Hm',
  'Hms',
  'j',
  'jm',
  'jms',
  'jmv',
  'jmz',
  'jv',
  'jz',
  'm',
  'ms',
  's',
};

const _dateFormatPartsDelimiter = '+';

// The set of number formats that can be automatically localized.
const _validNumberFormats = <String>{
  'compact',
  'compactCurrency',
  'compactSimpleCurrency',
  'compactLong',
  'currency',
  'decimalPattern',
  'decimalPatternDigits',
  'decimalPercentPattern',
  'percentPattern',
  'scientificPattern',
  'simpleCurrency',
};

// The names of the NumberFormat factory constructors which have named
// parameters rather than positional parameters.
const _numberFormatsWithNamedParameters = <String>{
  'compact',
  'compactCurrency',
  'compactSimpleCurrency',
  'compactLong',
  'currency',
  'decimalPatternDigits',
  'decimalPercentPattern',
  'simpleCurrency',
};

class JasprL10nException implements Exception {
  JasprL10nException(this.message);

  final String message;

  @override
  String toString() => message;
}

class JasprL10nParserException extends JasprL10nException {
  JasprL10nParserException(
    this.error,
    this.fileName,
    this.messageId,
    this.messageString,
    this.charNumber,
  ) : super('''
[$fileName:$messageId] $error
    $messageString
    ${List<String>.filled(charNumber, ' ').join()}^''');

  final String error;
  final String fileName;
  final String messageId;
  final String messageString;
  // Position of character within the "messageString" where the error is.
  final int charNumber;
}

class JasprL10nMissingPlaceholderException extends JasprL10nParserException {
  JasprL10nMissingPlaceholderException(
    super.error,
    super.fileName,
    super.messageId,
    super.messageString,
    super.charNumber,
    this.placeholderName,
  );

  final String placeholderName;
}

// One optional named parameter to be used by a NumberFormat.
class OptionalParameter {
  const OptionalParameter(this.name, this.value);

  final String name;
  final Object value;
}

// One message parameter: one placeholder from an @foo entry in the template ARB file.
class Placeholder {
  Placeholder(this.resourceId, this.name, Map<String, Object?> attributes)
    : example = _stringAttribute(resourceId, name, attributes, 'example'),
      type = _stringAttribute(resourceId, name, attributes, 'type'),
      format = _stringAttribute(resourceId, name, attributes, 'format'),
      optionalParameters = _optionalParameters(resourceId, name, attributes),
      isCustomDateFormat = _boolAttribute(
        resourceId,
        name,
        attributes,
        'isCustomDateFormat',
      );

  final String resourceId;
  final String name;
  final String? example;
  final String? format;
  final List<OptionalParameter> optionalParameters;
  final bool? isCustomDateFormat;
  // The following will be initialized after all messages are parsed in the Message constructor.
  String? type;
  var isPlural = false;
  var isSelect = false;
  var isDateTime = false;
  var requiresDateFormatting = false;

  bool get requiresFormatting =>
      requiresDateFormatting || requiresNumFormatting;
  bool get requiresNumFormatting =>
      <String>['int', 'num', 'double'].contains(type) && format != null;
  bool get hasValidNumberFormat => _validNumberFormats.contains(format);
  bool get hasNumberFormatWithParameters =>
      _numberFormatsWithNamedParameters.contains(format);
  // 'format' can contain a number of date time formats separated by `dateFormatPartsDelimiter`.
  List<String> get dateFormatParts =>
      format?.split(_dateFormatPartsDelimiter) ?? <String>[];
  bool get hasValidDateFormat =>
      dateFormatParts.every(validDateFormats.contains);

  static String? _stringAttribute(
    String resourceId,
    String name,
    Map<String, Object?> attributes,
    String attributeName,
  ) {
    final Object? value = attributes[attributeName];
    if (value == null) {
      return null;
    }
    if (value is! String || value.isEmpty) {
      throw JasprL10nException(
        'The "$attributeName" value of the "$name" placeholder in message $resourceId '
        'must be a non-empty string.',
      );
    }
    return value;
  }

  static bool? _boolAttribute(
    String resourceId,
    String name,
    Map<String, Object?> attributes,
    String attributeName,
  ) {
    final Object? value = attributes[attributeName];
    if (value == null) {
      return null;
    }
    if (value is bool) {
      return value;
    }
    if (value != 'true' && value != 'false') {
      throw JasprL10nException(
        'The "$attributeName" value of the "$name" placeholder in message $resourceId '
        'must be a boolean value.',
      );
    }
    return value == 'true';
  }

  static List<OptionalParameter> _optionalParameters(
    String resourceId,
    String name,
    Map<String, Object?> attributes,
  ) {
    final Object? value = attributes['optionalParameters'];
    if (value == null) {
      return <OptionalParameter>[];
    }
    if (value is! Map<String, Object?>) {
      throw JasprL10nException(
        'The "optionalParameters" value of the "$name" placeholder in message '
        '$resourceId is not a properly formatted Map. Ensure that it is a map '
        'with keys that are strings.',
      );
    }
    final Map<String, Object?> optionalParameterMap = value;
    return optionalParameterMap.keys.map<OptionalParameter>((
      String parameterName,
    ) {
      return OptionalParameter(
        parameterName,
        optionalParameterMap[parameterName]!,
      );
    }).toList();
  }
}

// All translations for a given message specified by a resource id.
class Message {
  Message(
    AppResourceBundle templateBundle,
    AppResourceBundleCollection allBundles,
    this.resourceId,
    bool isResourceAttributeRequired, {
    this.useRelaxedSyntax = false,
    this.useEscaping = false,
    this.logger,
  }) : assert(resourceId.isNotEmpty),
       value = _value(templateBundle.resources, resourceId),
       description = _description(
         templateBundle.resources,
         resourceId,
         isResourceAttributeRequired,
       ),
       context = _context(
         templateBundle.resources,
         resourceId,
         isResourceAttributeRequired,
       ),
       templatePlaceholders = _placeholders(
         templateBundle.resources,
         resourceId,
         isResourceAttributeRequired,
       ),
       localePlaceholders = <LocaleInfo, Map<String, Placeholder>>{},
       messages = <LocaleInfo, String?>{},
       parsedMessages = <LocaleInfo, Node?>{} {
    // Filenames for error handling.
    final filenames = <LocaleInfo, String>{};
    // Collect all translations from allBundles and parse them.
    for (final AppResourceBundle bundle in allBundles.bundles) {
      filenames[bundle.locale] = bundle.file.basename;
      final String? translation = bundle.translationFor(resourceId);
      messages[bundle.locale] = translation;

      localePlaceholders[bundle.locale] = templateBundle.locale == bundle.locale
          ? templatePlaceholders
          : _placeholders(bundle.resources, resourceId, false);

      List<String>? validPlaceholders;
      if (useRelaxedSyntax) {
        validPlaceholders = templatePlaceholders.entries
            .map((MapEntry<String, Placeholder> e) => e.key)
            .toList();
      }

      try {
        parsedMessages[bundle.locale] = translation == null
            ? null
            : Parser(
                resourceId,
                bundle.file.basename,
                translation,
                useEscaping: useEscaping,
                placeholders: validPlaceholders,
                logger: logger,
              ).parse();
      } on JasprL10nParserException catch (error) {
        logger?.printError(error.toString());
        // Treat it as an untranslated message in case we can't parse.
        parsedMessages[bundle.locale] = null;
        hadErrors = true;
      }
    }
    // Infer the placeholders
    _inferPlaceholders();
  }

  final String resourceId;
  final String value;
  final String? description;
  final String? context;
  late final Map<LocaleInfo, String?> messages;
  final Map<LocaleInfo, Node?> parsedMessages;
  final Map<LocaleInfo, Map<String, Placeholder>> localePlaceholders;
  final Map<String, Placeholder> templatePlaceholders;
  final bool useEscaping;
  final bool useRelaxedSyntax;
  final Logger? logger;
  var hadErrors = false;

  Iterable<Placeholder> getPlaceholders(LocaleInfo locale) {
    final Map<String, Placeholder>? placeholders = localePlaceholders[locale];
    if (placeholders == null) {
      return templatePlaceholders.values;
    }
    return templatePlaceholders.values.map(
      (Placeholder templatePlaceholder) =>
          placeholders[templatePlaceholder.name] ?? templatePlaceholder,
    );
  }

  static String _value(Map<String, Object?> bundle, String resourceId) {
    final Object? value = bundle[resourceId];
    if (value == null) {
      throw JasprL10nException(
        'A value for resource "$resourceId" was not found.',
      );
    }
    if (value is! String) {
      throw JasprL10nException('The value of "$resourceId" is not a string.');
    }
    return value;
  }

  static Map<String, Object?>? _attributes(
    Map<String, Object?> bundle,
    String resourceId,
    bool isResourceAttributeRequired,
  ) {
    final Object? attributes = bundle['@$resourceId'];
    if (isResourceAttributeRequired) {
      if (attributes == null) {
        throw JasprL10nException(
          'Resource attribute "@$resourceId" was not found. Please '
          'ensure that each resource has a corresponding @resource.',
        );
      }
    }

    if (attributes != null && attributes is! Map<String, Object?>) {
      throw JasprL10nException(
        'The resource attribute "@$resourceId" is not a properly formatted Map. '
        'Ensure that it is a map with keys that are strings.',
      );
    }

    return attributes as Map<String, Object?>?;
  }

  static String? _description(
    Map<String, Object?> bundle,
    String resourceId,
    bool isResourceAttributeRequired,
  ) {
    final Map<String, Object?>? resourceAttributes = _attributes(
      bundle,
      resourceId,
      isResourceAttributeRequired,
    );
    if (resourceAttributes == null) {
      return null;
    }

    final Object? value = resourceAttributes['description'];
    if (value == null) {
      return null;
    }
    if (value is! String) {
      throw JasprL10nException(
        'The description for "@$resourceId" is not a properly formatted String.',
      );
    }
    return value;
  }

  static String? _context(
    Map<String, Object?> bundle,
    String resourceId,
    bool isResourceAttributeRequired,
  ) {
    final Map<String, Object?>? resourceAttributes = _attributes(
      bundle,
      resourceId,
      isResourceAttributeRequired,
    );
    if (resourceAttributes == null) {
      return null;
    }

    final Object? value = resourceAttributes['context'];
    if (value == null) {
      return null;
    }
    if (value is! String) {
      throw JasprL10nException(
        'The context for "@$resourceId" is not a properly formatted String.',
      );
    }
    return value;
  }

  static Map<String, Placeholder> _placeholders(
    Map<String, Object?> bundle,
    String resourceId,
    bool isResourceAttributeRequired,
  ) {
    final Map<String, Object?>? resourceAttributes = _attributes(
      bundle,
      resourceId,
      isResourceAttributeRequired,
    );
    if (resourceAttributes == null) {
      return <String, Placeholder>{};
    }
    final Object? allPlaceholdersMap = resourceAttributes['placeholders'];
    if (allPlaceholdersMap == null) {
      return <String, Placeholder>{};
    }
    if (allPlaceholdersMap is! Map<String, Object?>) {
      throw JasprL10nException(
        'The "placeholders" attribute for message "$resourceId", is not '
        'properly formatted. Ensure that it is a map with string valued keys.',
      );
    }
    return Map<String, Placeholder>.fromEntries(
      allPlaceholdersMap.keys.map((String placeholderName) {
        final Object? value = allPlaceholdersMap[placeholderName];
        if (value is! Map<String, Object?>) {
          throw JasprL10nException(
            'The value of the "$placeholderName" placeholder attribute for message '
            '"$resourceId", is not properly formatted. Ensure that it is a map '
            'with string valued keys.',
          );
        }
        return MapEntry<String, Placeholder>(
          placeholderName,
          Placeholder(resourceId, placeholderName, value),
        );
      }),
    );
  }

  // Using parsed translations, attempt to infer types of placeholders used by plurals and selects.
  // For undeclared placeholders, create a new placeholder.
  void _inferPlaceholders() {
    // We keep the undeclared placeholders separate so that we can sort them alphabetically afterwards.
    final undeclaredPlaceholders = <String, Placeholder>{};
    // Helper for getting placeholder by name.
    for (final LocaleInfo locale in parsedMessages.keys) {
      Placeholder? getPlaceholder(String name) =>
          localePlaceholders[locale]?[name] ??
          templatePlaceholders[name] ??
          undeclaredPlaceholders[name];
      if (parsedMessages[locale] == null) {
        continue;
      }
      final traversalStack = <Node>[parsedMessages[locale]!];
      while (traversalStack.isNotEmpty) {
        final Node node = traversalStack.removeLast();
        if (<ST>[
          ST.placeholderExpr,
          ST.pluralExpr,
          ST.selectExpr,
          ST.argumentExpr,
        ].contains(node.type)) {
          final String identifier = node.children[1].value!;
          Placeholder? placeholder = getPlaceholder(identifier);
          if (placeholder == null) {
            placeholder = Placeholder(
              resourceId,
              identifier,
              <String, Object?>{},
            );
            undeclaredPlaceholders[identifier] = placeholder;
          }
          if (node.type == ST.pluralExpr) {
            placeholder.isPlural = true;
          } else if (node.type == ST.selectExpr) {
            placeholder.isSelect = true;
          } else if (node.type == ST.argumentExpr) {
            placeholder.isDateTime = true;
          } else {
            // Here the node type must be ST.placeholderExpr.
            // A DateTime placeholder must require date formatting.
            if (placeholder.type == 'DateTime') {
              placeholder.requiresDateFormatting = true;
            }
          }
        }
        traversalStack.addAll(node.children);
      }
    }
    templatePlaceholders.addEntries(
      undeclaredPlaceholders.entries.toList()..sort(
        (MapEntry<String, Placeholder> p1, MapEntry<String, Placeholder> p2) =>
            p1.key.compareTo(p2.key),
      ),
    );

    bool atMostOneOf(bool x, bool y, bool z) {
      return x && !y && !z || !x && y && !z || !x && !y && z || !x && !y && !z;
    }

    for (final Placeholder placeholder
        in templatePlaceholders.values.followedBy(
          localePlaceholders.values.expand(
            (Map<String, Placeholder> e) => e.values,
          ),
        )) {
      if (!atMostOneOf(
        placeholder.isPlural,
        placeholder.isDateTime,
        placeholder.isSelect,
      )) {
        throw JasprL10nException(
          'Placeholder is used as plural/select/datetime in certain languages.',
        );
      } else if (placeholder.isPlural) {
        if (placeholder.type == null) {
          placeholder.type = 'num';
        } else if (!<String>['num', 'int'].contains(placeholder.type)) {
          throw JasprL10nException(
            "Placeholders used in plurals must be of type 'num' or 'int'",
          );
        }
      } else if (placeholder.isSelect) {
        if (placeholder.type == null) {
          placeholder.type = 'String';
        } else if (placeholder.type != 'String') {
          throw JasprL10nException(
            "Placeholders used in selects must be of type 'String'",
          );
        }
      } else if (placeholder.isDateTime) {
        if (placeholder.type == null) {
          placeholder.type = 'DateTime';
        } else if (placeholder.type != 'DateTime') {
          throw JasprL10nException(
            "Placeholders used in datetime expressions much be of type 'DateTime'",
          );
        }
      }
      placeholder.type ??= 'Object';
    }
  }
}

/// Represents the contents of one ARB file.
class AppResourceBundle {
  /// Assuming that the caller has verified that the file exists and is readable.
  factory AppResourceBundle(JasprFile file) {
    final Map<String, Object?> resources;
    try {
      final String content = file.readAsStringSync().trim();
      if (content.isEmpty) {
        resources = <String, Object?>{};
      } else {
        resources = json.decode(content) as Map<String, Object?>;
      }
    } on FormatException catch (e) {
      throw JasprL10nException(
        'The arb file ${file.path} has the following formatting issue: \n'
        '$e',
      );
    }

    var localeString = resources['@@locale'] as String?;
    // Look for the first instance of an ISO 639-1 language code, matching exactly.
    final String fileName = file.basename;

    for (var index = 0; index < fileName.length; index += 1) {
      // If an underscore was found, check if locale string follows.
      if (fileName[index] == '_') {
        // Extract locale part and remove file extension
        String localePart = fileName.substring(index + 1);
        if (localePart.contains('.')) {
          localePart = localePart.substring(0, localePart.lastIndexOf('.'));
        }

        // If Locale.tryParse fails, it returns null.
        final Locale? parserResult = Locale.tryParse(localePart);
        // If the parserResult is not an actual locale identifier, end the loop.
        if (parserResult != null &&
            _iso639Languages.contains(parserResult.languageCode)) {
          // The parsed result uses dashes ('-'), but we want underscores ('_').
          final String parserLocaleString = parserResult.toString().replaceAll(
            '-',
            '_',
          );

          if (localeString == null) {
            // If @@locale was not defined, use the filename locale suffix.
            localeString = parserLocaleString;
          } else {
            // If the localeString was defined in @@locale and in the filename, verify to
            // see if the parsed locale matches, throw an error if it does not. This
            // prevents developers from confusing issues when both @@locale and
            // "_{locale}" is specified in the filename.
            if (localeString != parserLocaleString) {
              throw JasprL10nException(
                'The locale specified in @@locale and the arb filename do not match.\n'
                'Please make sure that they match, since this prevents any confusion \n'
                'with which locale to use. Otherwise, specify the locale in either the \n'
                'filename or the @@locale key only.\n'
                'Current @@locale value: $localeString\n'
                'Current filename extension: $parserLocaleString',
              );
            }
          }
          break;
        }
      }
    }

    if (localeString == null) {
      throw JasprL10nException(
        "The following .arb file's locale could not be determined: \n"
        '${file.path} \n'
        "Make sure that the locale is specified in the file's '@@locale' "
        'property or as part of the filename (e.g. file_en.arb)',
      );
    }

    final Iterable<String> ids = resources.keys.where(
      (String key) => !key.startsWith('@'),
    );
    return AppResourceBundle._(
      file,
      LocaleInfo.fromString(localeString),
      resources,
      ids,
    );
  }

  const AppResourceBundle._(
    this.file,
    this.locale,
    this.resources,
    this.resourceIds,
  );

  final JasprFile file;
  final LocaleInfo locale;

  /// JSON representation of the contents of the ARB file.
  final Map<String, Object?> resources;
  final Iterable<String> resourceIds;

  String? translationFor(String resourceId) {
    final Object? result = resources[resourceId];
    if (result is! String?) {
      throw JasprL10nException(
        'Localized message for key "$resourceId" in "${file.path}" '
        'is not a string.',
      );
    }
    return result;
  }

  @override
  String toString() {
    return 'AppResourceBundle($locale, ${file.path})';
  }
}

// Represents all of the ARB files in [directory] as [AppResourceBundle]s.
class AppResourceBundleCollection {
  factory AppResourceBundleCollection(JasprDirectory directory) {
    // Assuming that the caller has verified that the directory is readable.

    final filenameRE = RegExp(r'(\w+)\.arb$');
    final localeToBundle = <LocaleInfo, AppResourceBundle>{};
    final languageToLocales = <String, List<LocaleInfo>>{};
    // We require the list of files to be sorted so that
    // "languageToLocales[bundle.locale.languageCode]" is not null
    // by the time we handle locales with country codes.
    final List<JasprFile> files =
        directory
            .listSync()
            .whereType<JasprFile>()
            .where((JasprFile e) => filenameRE.hasMatch(e.path))
            .toList()
          ..sort(sortFilesByPath);
    for (final file in files) {
      final bundle = AppResourceBundle(file);
      if (localeToBundle[bundle.locale] != null) {
        throw JasprL10nException(
          "Multiple arb files with the same '${bundle.locale}' locale detected. \n"
          'Ensure that there is exactly one arb file for each locale.',
        );
      }
      localeToBundle[bundle.locale] = bundle;
      languageToLocales[bundle.locale.languageCode] ??= <LocaleInfo>[];
      languageToLocales[bundle.locale.languageCode]!.add(bundle.locale);
    }

    languageToLocales.forEach((
      String language,
      List<LocaleInfo> listOfCorrespondingLocales,
    ) {
      final List<String> localeStrings = listOfCorrespondingLocales.map((
        LocaleInfo locale,
      ) {
        return locale.toString();
      }).toList();
      if (!localeStrings.contains(language)) {
        throw JasprL10nException(
          'Arb file for a fallback, $language, does not exist, even though \n'
          'the following locale(s) exist: $listOfCorrespondingLocales. \n'
          'When locales specify a script code or country code, a \n'
          'base locale (without the script code or country code) should \n'
          'exist as the fallback. Please create a {fileName}_$language.arb \n'
          'file.',
        );
      }
    });

    return AppResourceBundleCollection._(
      directory,
      localeToBundle,
      languageToLocales,
    );
  }

  const AppResourceBundleCollection._(
    this._directory,
    this._localeToBundle,
    this._languageToLocales,
  );

  final JasprDirectory _directory;
  final Map<LocaleInfo, AppResourceBundle> _localeToBundle;
  final Map<String, List<LocaleInfo>> _languageToLocales;

  Iterable<LocaleInfo> get locales => _localeToBundle.keys;
  Iterable<AppResourceBundle> get bundles => _localeToBundle.values;
  AppResourceBundle? bundleFor(LocaleInfo locale) => _localeToBundle[locale];

  Iterable<String> get languages => _languageToLocales.keys;
  Iterable<LocaleInfo> localesForLanguage(String language) =>
      _languageToLocales[language] ?? <LocaleInfo>[];

  @override
  String toString() {
    return 'AppResourceBundleCollection(${_directory.path}, ${locales.length} locales)';
  }
}

// A set containing all the ISO630-1 languages. This list was pulled from https://datahub.io/core/language-codes.
final _iso639Languages = <String>{
  'aa',
  'ab',
  'ae',
  'af',
  'ak',
  'am',
  'an',
  'ar',
  'as',
  'av',
  'ay',
  'az',
  'ba',
  'be',
  'bg',
  'bh',
  'bi',
  'bm',
  'bn',
  'bo',
  'br',
  'bs',
  'ca',
  'ce',
  'ch',
  'co',
  'cr',
  'cs',
  'cu',
  'cv',
  'cy',
  'da',
  'de',
  'dv',
  'dz',
  'ee',
  'el',
  'en',
  'eo',
  'es',
  'et',
  'eu',
  'fa',
  'ff',
  'fi',
  'fil',
  'fj',
  'fo',
  'fr',
  'fy',
  'ga',
  'gd',
  'gl',
  'gn',
  'gsw',
  'gu',
  'gv',
  'ha',
  'he',
  'hi',
  'ho',
  'hr',
  'ht',
  'hu',
  'hy',
  'hz',
  'ia',
  'id',
  'ie',
  'ig',
  'ii',
  'ik',
  'io',
  'is',
  'it',
  'iu',
  'ja',
  'jv',
  'ka',
  'kg',
  'ki',
  'kj',
  'kk',
  'kl',
  'km',
  'kn',
  'ko',
  'kr',
  'ks',
  'ku',
  'kv',
  'kw',
  'ky',
  'la',
  'lb',
  'lg',
  'li',
  'ln',
  'lo',
  'lt',
  'lu',
  'lv',
  'mg',
  'mh',
  'mi',
  'mk',
  'ml',
  'mn',
  'mr',
  'ms',
  'mt',
  'my',
  'na',
  'nb',
  'nd',
  'ne',
  'ng',
  'nl',
  'nn',
  'no',
  'nr',
  'nv',
  'ny',
  'oc',
  'oj',
  'om',
  'or',
  'os',
  'pa',
  'pi',
  'pl',
  'ps',
  'pt',
  'qu',
  'rm',
  'rn',
  'ro',
  'ru',
  'rw',
  'sa',
  'sc',
  'sd',
  'se',
  'sg',
  'si',
  'sk',
  'sl',
  'sm',
  'sn',
  'so',
  'sq',
  'sr',
  'ss',
  'st',
  'su',
  'sv',
  'sw',
  'ta',
  'te',
  'tg',
  'th',
  'ti',
  'tk',
  'tl',
  'tn',
  'to',
  'tr',
  'ts',
  'tt',
  'tw',
  'ty',
  'ug',
  'uk',
  'ur',
  'uz',
  've',
  'vi',
  'vo',
  'wa',
  'wo',
  'xh',
  'yi',
  'yo',
  'za',
  'zh',
  'zu',
};
