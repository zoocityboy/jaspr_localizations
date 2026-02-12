// Copyright 2025 zoocityboy. All rights reserved.
// Use of this source code is governed by a MIT that can be
// found in the LICENSE file.

// Jaspr Localization Generator
// Based on Flutter's gen_l10n.dart but adapted for Jaspr framework

import 'dart:io';
import 'base/file_system.dart';
import 'base/logger.dart';
import 'jaspr_l10n_templates.dart';
import 'jaspr_l10n_types.dart';
import 'utils/localizations_utils.dart';
import 'utils/message_parser.dart';

/// Generates Dart localization files from ARB files for Jaspr framework
class LocalizationsGenerator {
  LocalizationsGenerator({
    required this.fileSystem,
    required this.inputsAndOutputsListPath,
    required this.projectPathString,
    required this.outputPathString,
    required this.templateArbPathString,
    required this.outputFileString,
    required this.classNameString,
    this.preferredSupportedLocales,
    this.headerString,
    this.headerFile,
    this.deferredLoading = false,
    this.useRelaxedSyntax = false,
    this.useSyntheticPackage = true,
    this.useEscaping = false,
    this.suppressWarnings = false,
    this.useNamedParameters = false,
    this.outputLocalizationsFile = 'localizations.dart',
    this.untranslatedMessagesFile = 'untranslated_messages.json',
    this.requiredResourceAttributes = false,
    this.nullableGetter = true,
    this.useFormat = true,
    this.logger,
  });

  final JasprFileSystem fileSystem;
  final String inputsAndOutputsListPath;
  final String projectPathString;
  final String outputPathString;
  final String templateArbPathString;
  final String outputFileString;
  final String classNameString;
  final List<LocaleInfo>? preferredSupportedLocales;
  final String? headerString;
  final String? headerFile;
  final bool deferredLoading;
  final bool useRelaxedSyntax;
  final bool useSyntheticPackage;
  final bool useEscaping;
  final bool suppressWarnings;
  final bool useNamedParameters;
  final String outputLocalizationsFile;
  final String untranslatedMessagesFile;
  final bool requiredResourceAttributes;
  final bool nullableGetter;
  final bool useFormat;
  final Logger? logger;

  late final JasprDirectory projectDirectory;
  late final JasprDirectory outputDirectory;
  late final JasprFile templateArbFile;
  late final JasprFile baseOutputFile;
  late final AppResourceBundleCollection allBundles;
  late final AppResourceBundle templateBundle;
  late final List<Message> allMessages;

  void loadResources() {
    projectDirectory = fileSystem.directory(projectPathString);
    outputDirectory = fileSystem.directory(outputPathString);
    templateArbFile = fileSystem.file(templateArbPathString);

    final String templateBundlePathString = templateArbPathString;
    try {
      templateBundle = AppResourceBundle(templateArbFile);
    } on FileSystemException catch (e) {
      throw JasprL10nException(
        'Unable to find the template ARB file: $templateBundlePathString\n'
        '$e',
      );
    }

    try {
      allBundles = AppResourceBundleCollection(templateArbFile.parent);
    } on FileSystemException catch (e) {
      throw JasprL10nException(
        'An error occurred when reading the ARB files:\n'
        '$e',
      );
    }

    if (allBundles.bundles.isEmpty) {
      throw JasprL10nException(
        'No ARB files found in: ${templateArbFile.parent.path}',
      );
    }

    allMessages = <Message>[];
    for (final String id in templateBundle.resourceIds) {
      allMessages.add(
        Message(
          templateBundle,
          allBundles,
          id,
          requiredResourceAttributes,
          useEscaping: useEscaping,
          useRelaxedSyntax: useRelaxedSyntax,
          logger: logger,
        ),
      );
    }

    baseOutputFile = outputDirectory.childFile(outputFileString);
  }

  String get generatedLocalizationsFile => outputLocalizationsFile;

  String get generatedClassname => classNameString;

  List<LocaleInfo> get supportedLocales =>
      preferredSupportedLocales ?? allBundles.locales.toList();

  String _generateMethod(Message message, LocaleInfo locale) {
    if (message.templatePlaceholders.isEmpty) {
      return _generateGetterMethod(message, locale);
    } else {
      return _generateRegularMethod(message, locale);
    }
  }

  String _generateGetterMethod(Message message, LocaleInfo locale) {
    String translationForMessage = _generateTranslationForMessage(
      message,
      locale,
    );
    return getterMethodTemplate
        .replaceAll('@{methodName}', message.resourceId)
        .replaceAll('@{message}', translationForMessage);
  }

  String _generateRegularMethod(Message message, LocaleInfo locale) {
    // Use template placeholders to ensure consistent parameter types across all locales
    final Iterable<Placeholder> placeholders =
        message.templatePlaceholders.values;
    final String methodParameters = placeholders
        .map((Placeholder placeholder) {
          final String placeholderType = placeholder.type!;
          return '$placeholderType ${placeholder.name}';
        })
        .join(', ');

    String translationForMessage = _generateTranslationForMessage(
      message,
      locale,
    );

    final String dateFormatting = _dateFormattingStatements(placeholders);
    final String numberFormatting = _numberFormattingStatements(placeholders);

    return classMethodTemplate
        .replaceAll('@{methodName}', message.resourceId)
        .replaceAll('@{methodParameters}', methodParameters)
        .replaceAll('@{dateFormatting}', dateFormatting)
        .replaceAll('@{numberFormatting}', numberFormatting)
        .replaceAll('@{message}', translationForMessage);
  }

  String _generateTranslationForMessage(Message message, LocaleInfo locale) {
    final Node? messageNode = message.parsedMessages[locale];
    if (messageNode == null) {
      return 'throw UnimplementedError();';
    }
    return _generateCodeFromNode(messageNode, message, locale);
  }

  String _generateCodeFromNode(Node node, Message message, LocaleInfo locale) {
    switch (node.type) {
      case ST.string:
        return _escapeString(node.value!);
      case ST.placeholderExpr:
        final String identifier = node.children[1].value!;
        // Use template placeholders to ensure consistent types
        final Placeholder placeholder =
            message.templatePlaceholders[identifier]!;
        return _generatePlaceholderCode(placeholder);
      case ST.pluralExpr:
        return _generatePluralCode(node, message, locale);
      case ST.selectExpr:
        return _generateSelectCode(node, message, locale);
      case ST.message:
        if (node.children.isEmpty) {
          return "''";
        }
        // Generate string interpolation instead of concatenation
        final parts = node.children.map(
          (Node child) => _generateCodeFromNode(child, message, locale),
        );
        final interpolatedParts = <String>[];

        for (final part in parts) {
          if (part.startsWith("'") && part.endsWith("'")) {
            // This is a string literal, extract content without quotes
            final content = part.substring(1, part.length - 1);
            interpolatedParts.add(content);
          } else {
            // This is a variable or expression, wrap in interpolation
            interpolatedParts.add('\${$part}');
          }
        }

        return "'${interpolatedParts.join('')}'";
      case ST.openBrace:
        return "'{'"; // Literal open brace
      case ST.closeBrace:
        return "'}'"; // Literal close brace
      default:
        throw JasprL10nException('Unsupported node type: ${node.type}');
    }
  }

  String _generatePlaceholderCode(Placeholder placeholder) {
    if (placeholder.requiresFormatting) {
      if (placeholder.isDateTime) {
        return '${placeholder.name}Formatter.format(${placeholder.name})';
      } else if (placeholder.requiresNumFormatting) {
        return '${placeholder.name}Formatter.format(${placeholder.name})';
      }
    }

    // For numeric types, convert to string when used in concatenation
    if (placeholder.type == 'num' ||
        placeholder.type == 'int' ||
        placeholder.type == 'double') {
      return '${placeholder.name}.toString()';
    }

    return placeholder.name; // Just return the variable name for string types
  }

  String _generatePluralCode(Node node, Message message, LocaleInfo locale) {
    final String identifier = node.children[1].value!;
    final List<String> pluralCases = <String>[];

    for (final Node pluralPart in node.children[5].children) {
      String caseKey;
      Node messageNode;

      // Handle different plural part structures based on grammar:
      // [ST.identifier, ST.openBrace, ST.message, ST.closeBrace] - e.g., "other"
      // [ST.equalSign, ST.number, ST.openBrace, ST.message, ST.closeBrace] - e.g., "=0", "=1"
      // [ST.other, ST.openBrace, ST.message, ST.closeBrace] - specifically "other"

      if (pluralPart.children.length >= 4) {
        if (pluralPart.children[0].type == ST.equalSign &&
            pluralPart.children[1].type == ST.number) {
          // Structure: [=, number, {, message, }]
          final String numberValue = pluralPart.children[1].value!;
          caseKey = _mapExplicitPluralForm(numberValue);
          messageNode = pluralPart.children[3]; // Skip the openBrace at index 2
        } else {
          // Structure: [identifier/other, {, message, }]
          caseKey = pluralPart.children[0].value!;
          messageNode = pluralPart.children[2]; // Skip the openBrace at index 1
        }
      } else {
        throw JasprL10nException(
          'Invalid plural part structure: ${pluralPart.children.length} children',
        );
      }

      final String caseValue = _generateCodeFromNode(
        messageNode,
        message,
        locale,
      );
      pluralCases.add("$caseKey: $caseValue");
    }

    final String pluralLogic = pluralCases.join(',\n        ');

    return '''intl.Intl.plural(
      $identifier,
      $pluralLogic,
      name: '${message.resourceId}',
      locale: localeName,
    )''';
  }

  /// Maps explicit plural forms (like "0", "1") to Intl.plural named parameters
  String _mapExplicitPluralForm(String value) {
    switch (value) {
      case '0':
        return 'zero';
      case '1':
        return 'one';
      case '2':
        return 'two';
      default:
        // For other explicit numbers, we'd need special handling
        // For now, map them to 'other' which is the fallback
        return 'other';
    }
  }

  String _generateSelectCode(Node node, Message message, LocaleInfo locale) {
    final String identifier = node.children[1].value!;
    final List<String> selectCases = <String>[];

    for (final Node selectPart in node.children[5].children) {
      final String caseKey = selectPart.children[0].value!;
      final String caseValue = _generateCodeFromNode(
        selectPart.children[2],
        message,
        locale,
      );
      selectCases.add("'$caseKey': $caseValue");
    }

    final String selectLogic = selectCases.join(',\n        ');

    return '''intl.Intl.select(
      $identifier,
      {
        $selectLogic
      },
      name: '${message.resourceId}',
    )''';
  }

  String _dateFormattingStatements(Iterable<Placeholder> placeholders) {
    return placeholders
        .where((Placeholder placeholder) => placeholder.isDateTime)
        .map((Placeholder placeholder) {
          final String? format = placeholder.format;
          if (format != null) {
            return dateFormattingTemplate
                .replaceAll('@{formatterName}', '${placeholder.name}Formatter')
                // ignore: unnecessary_brace_in_string_interps
                .replaceAll('@{constructorCall}', '.${format}')
                .replaceAll('@{parameters}', 'localeName');
          } else {
            return dateFormattingTemplate
                .replaceAll('@{formatterName}', '${placeholder.name}Formatter')
                .replaceAll('@{constructorCall}', '')
                .replaceAll('@{parameters}', 'localeName');
          }
        })
        .join('\n    ');
  }

  String _numberFormattingStatements(Iterable<Placeholder> placeholders) {
    return placeholders
        .where((Placeholder placeholder) => placeholder.requiresNumFormatting)
        .map((Placeholder placeholder) {
          final String format = placeholder.format!;
          return numberFormattingTemplate
              .replaceAll('@{formatterName}', '${placeholder.name}Formatter')
              // ignore: unnecessary_brace_in_string_interps
              .replaceAll('@{constructorCall}', '.${format}')
              .replaceAll('@{parameters}', 'locale: localeName');
        })
        .join('\n    ');
  }

  String _escapeString(String value) {
    return "'${value.replaceAll("'", "\\'").replaceAll(r'$', r'\$')}'";
  }

  String _generateBaseClassMethods() {
    final StringBuffer sb = StringBuffer();
    for (final Message message in allMessages) {
      String comment =
          message.description ?? 'No description provided for @{methodName}.';
      if (message.context != null) {
        comment = '$comment\n  ///\n  /// context: ${message.context}';
      }

      if (message.templatePlaceholders.isEmpty) {
        sb.writeln(
          baseClassGetterTemplate
              .replaceAll('@{comment}', comment)
              .replaceAll('@{methodName}', message.resourceId)
              .replaceAll('@{localeVar}', templateBundle.locale.toString())
              .replaceAll('@{message}', message.value),
        );
      } else {
        final String methodParameters = message.templatePlaceholders.values
            .map((Placeholder placeholder) {
              return '${placeholder.type!} ${placeholder.name}';
            })
            .join(', ');

        sb.writeln(
          baseClassMethodTemplate
              .replaceAll('@{comment}', comment)
              .replaceAll('@{methodName}', message.resourceId)
              .replaceAll('@{methodParameters}', methodParameters)
              .replaceAll('@{localeVar}', templateBundle.locale.toString())
              .replaceAll('@{message}', message.value),
        );
      }
    }
    return sb.toString();
  }

  String _generateClassMethods(LocaleInfo locale) {
    final StringBuffer sb = StringBuffer();
    for (final Message message in allMessages) {
      sb.writeln(_generateMethod(message, locale));
    }
    return sb.toString();
  }

  String _generateFromSwitchCases() {
    final StringBuffer sb = StringBuffer();
    for (final LocaleInfo locale in supportedLocales) {
      final String className =
          '_$classNameString${_camelCase(locale.toString())}';
      sb.writeln(
        jasprFromSwitchCaseTemplate
            .replaceAll('@{locale}', locale.toString())
            .replaceAll('@{class}', className),
      );
    }
    return sb.toString();
  }

  String _generateSupportedLocalesList() {
    final StringBuffer sb = StringBuffer();
    for (int i = 0; i < supportedLocales.length; i++) {
      final LocaleInfo locale = supportedLocales[i];
      final String localeCode = locale.languageCode;
      final String? scriptCode = locale.scriptCode;
      final String? countryCode = locale.countryCode;

      String localeConstructor = "Locale('$localeCode'";
      if (scriptCode != null && countryCode != null) {
        localeConstructor += ", '$scriptCode', '$countryCode'";
      } else if (countryCode != null) {
        localeConstructor += ", '$countryCode'";
      }
      localeConstructor += ')';

      sb.writeln("    $localeConstructor,");
    }
    return sb.toString();
  }

  String _generateSupportedLocalesStringList() {
    final StringBuffer sb = StringBuffer();
    for (int i = 0; i < supportedLocales.length; i++) {
      final LocaleInfo locale = supportedLocales[i];
      sb.writeln("    '${locale.toString()}',");
    }
    return sb.toString();
  }

  String _camelCase(String text) {
    // Replace hyphens with underscores, then split and camelCase
    return text.replaceAll('-', '_').split('_').map((String part) {
      if (part.isEmpty) return part;
      return part[0].toUpperCase() + part.substring(1);
    }).join();
  }

  String generateLocalizationContent() {
    final String baseClassContent = jasprBaseClassTemplate
        .replaceAll('@{class}', classNameString)
        .replaceAll('@{classMethods}', _generateBaseClassMethods())
        .replaceAll('@{fromSwitchCases}', _generateFromSwitchCases())
        .replaceAll('@{supportedLocalesList}', _generateSupportedLocalesList())
        .replaceAll(
          '@{supportedLocalesStringList}',
          _generateSupportedLocalesStringList(),
        )
        .replaceAll(
          '@{defaultClass}',
          '$classNameString${_camelCase(templateBundle.locale.toString())}',
        );

    final StringBuffer localizationFileContent = StringBuffer();
    localizationFileContent.writeln(baseClassContent);

    // Generate individual locale classes
    for (final LocaleInfo locale in supportedLocales) {
      final String className =
          '_$classNameString${_camelCase(locale.toString())}';
      final String classContent = jasprFileTemplate
          .replaceAll('@{locale}', locale.toString())
          .replaceAll('@{class}', className)
          .replaceAll('@{baseClass}', classNameString)
          .replaceAll('@{classMethods}', _generateClassMethods(locale));

      localizationFileContent.writeln();
      localizationFileContent.writeln(
        classContent.substring(classContent.indexOf('class')),
      );
    }

    return localizationFileContent.toString();
  }

  void generateLocalizationFile() {
    final content = generateLocalizationContent();

    // Ensure output directory exists
    if (!outputDirectory.existsSync()) {
      outputDirectory.createSync(recursive: true);
    }

    baseOutputFile.writeAsStringSync(content);
    logger?.printStatus('Generated: ${baseOutputFile.path}');
  }

  void generateSyntheticPackage() {
    generateLocalizationFile();
  }
}

int sortFilesByPath(JasprFile a, JasprFile b) {
  return a.path.compareTo(b.path);
}
