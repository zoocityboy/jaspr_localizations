// Copyright 2025 zoocityboy. All rights reserved.
// Use of this source code is governed by a MIT that can be
// found in the LICENSE file.

import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';

import 'file_system.dart';
import 'logger.dart';

/// Configuration for jaspr_localizations code generation
class L10nConfig {
  L10nConfig({
    required this.arbDir,
    required this.templateArbFile,
    required this.outputLocalizationFile,
    required this.outputClass,
    this.preferredSupportedLocales,
    this.header,
    this.headerFile,
    this.useDeferredLoading = false,
    this.useRelaxedSyntax = false,
    this.useSyntheticPackage = true,
    this.useEscaping = false,
    this.suppressWarnings = false,
    this.useNamedParameters = false,
    this.nullableGetter = true,
    this.useFormat = true,
    this.requiredResourceAttributes = false,
    this.untranslatedMessagesFile,
  });

  /// Directory containing ARB files
  final String arbDir;

  /// Template ARB file (usually the English version)
  final String templateArbFile;

  /// Output file for generated localizations
  final String outputLocalizationFile;

  /// Name of the generated localizations class
  final String outputClass;

  /// List of preferred supported locales
  final List<String>? preferredSupportedLocales;

  /// Custom header text for generated files
  final String? header;

  /// Path to a file containing the header
  final String? headerFile;

  /// Use deferred loading for localizations
  final bool useDeferredLoading;

  /// Use relaxed syntax for ARB parsing
  final bool useRelaxedSyntax;

  /// Use synthetic package for localization
  final bool useSyntheticPackage;

  /// Use escaping for special characters
  final bool useEscaping;

  /// Suppress warnings during generation
  final bool suppressWarnings;

  /// Use named parameters in generated methods
  final bool useNamedParameters;

  /// Make getters nullable
  final bool nullableGetter;

  /// Use format specifiers
  final bool useFormat;

  /// Require resource attributes in ARB files
  final bool requiredResourceAttributes;

  /// File to write untranslated messages to
  final String? untranslatedMessagesFile;

  /// Load configuration from l10n.yaml file
  static L10nConfig? fromL10nYaml(
    String projectRoot,
    JasprFileSystem fileSystem,
    Logger logger,
  ) {
    final l10nYamlPath = path.join(projectRoot, 'l10n.yaml');
    final l10nFile = fileSystem.file(l10nYamlPath);

    if (!l10nFile.existsSync()) {
      // No l10n.yaml found
      return null;
    }

    try {
      final yamlString = l10nFile.readAsStringSync();
      final yamlMap = loadYaml(yamlString) as YamlMap;

      return L10nConfig(
        arbDir: yamlMap['arb-dir'] as String? ?? 'lib/l10n',
        templateArbFile:
            yamlMap['template-arb-file'] as String? ?? 'app_en.arb',
        outputLocalizationFile:
            yamlMap['output-localization-file'] as String? ??
            'app_localizations.dart',
        outputClass: yamlMap['output-class'] as String? ?? 'AppLocalizations',
        preferredSupportedLocales:
            (yamlMap['preferred-supported-locales'] as YamlList?)
                ?.map((e) => e.toString())
                .toList(),
        header: yamlMap['header'] as String?,
        headerFile: yamlMap['header-file'] as String?,
        useDeferredLoading: yamlMap['use-deferred-loading'] as bool? ?? false,
        useRelaxedSyntax: yamlMap['use-relaxed-syntax'] as bool? ?? false,
        useSyntheticPackage: yamlMap['synthetic-package'] as bool? ?? true,
        useEscaping: yamlMap['use-escaping'] as bool? ?? false,
        suppressWarnings: yamlMap['suppress-warnings'] as bool? ?? false,
        useNamedParameters: yamlMap['use-named-parameters'] as bool? ?? false,
        nullableGetter: yamlMap['nullable-getter'] as bool? ?? true,
        useFormat: yamlMap['format'] as bool? ?? true,
        requiredResourceAttributes:
            yamlMap['required-resource-attributes'] as bool? ?? false,
        untranslatedMessagesFile:
            yamlMap['untranslated-messages-file'] as String?,
      );
    } catch (e) {
      logger.printError('Error parsing l10n.yaml: $e');
      return null;
    }
  }

  /// Load configuration from pubspec.yaml jaspr_localizations section
  static L10nConfig? fromPubspecYaml(
    String projectRoot,
    JasprFileSystem fileSystem,
    Logger logger,
  ) {
    final pubspecPath = path.join(projectRoot, 'pubspec.yaml');
    final pubspecFile = fileSystem.file(pubspecPath);

    if (!pubspecFile.existsSync()) {
      // No pubspec.yaml found
      return null;
    }

    try {
      final yamlString = pubspecFile.readAsStringSync();
      final yamlMap = loadYaml(yamlString) as YamlMap;
      final jasprL10nConfig = yamlMap['jaspr_localizations'] as YamlMap?;

      if (jasprL10nConfig == null || jasprL10nConfig['enabled'] != true) {
        // jaspr_localizations not enabled in pubspec.yaml
        return null;
      }

      return L10nConfig(
        arbDir: jasprL10nConfig['arb-dir'] as String? ?? 'lib/l10n',
        templateArbFile:
            jasprL10nConfig['template-arb-file'] as String? ?? 'app_en.arb',
        outputLocalizationFile:
            jasprL10nConfig['output-localization-file'] as String? ??
            'app_localizations.dart',
        outputClass:
            jasprL10nConfig['output-class'] as String? ?? 'AppLocalizations',
        preferredSupportedLocales:
            (jasprL10nConfig['preferred-supported-locales'] as YamlList?)
                ?.map((e) => e.toString())
                .toList(),
        header: jasprL10nConfig['header'] as String?,
        headerFile: jasprL10nConfig['header-file'] as String?,
        useDeferredLoading:
            jasprL10nConfig['use-deferred-loading'] as bool? ?? false,
        useRelaxedSyntax:
            jasprL10nConfig['use-relaxed-syntax'] as bool? ?? false,
        useSyntheticPackage:
            jasprL10nConfig['synthetic-package'] as bool? ?? true,
        useEscaping: jasprL10nConfig['use-escaping'] as bool? ?? false,
        suppressWarnings:
            jasprL10nConfig['suppress-warnings'] as bool? ?? false,
        useNamedParameters:
            jasprL10nConfig['use-named-parameters'] as bool? ?? false,
        nullableGetter: jasprL10nConfig['nullable-getter'] as bool? ?? true,
        useFormat: jasprL10nConfig['format'] as bool? ?? true,
        requiredResourceAttributes:
            jasprL10nConfig['required-resource-attributes'] as bool? ?? false,
        untranslatedMessagesFile:
            jasprL10nConfig['untranslated-messages-file'] as String?,
      );
    } catch (e) {
      logger.printError(
        'Error parsing pubspec.yaml jaspr_localizations section: $e',
      );
      return null;
    }
  }

  /// Load configuration with fallback chain:
  /// 1. Try l10n.yaml first (Flutter standard)
  /// 2. Fall back to pubspec.yaml jaspr_localizations section
  /// 3. Use defaults if neither exists
  static L10nConfig load(
    String projectRoot,
    JasprFileSystem fileSystem,
    Logger logger,
  ) {
    // Try l10n.yaml first (preferred, follows Flutter conventions)
    final l10nConfig = fromL10nYaml(projectRoot, fileSystem, logger);
    if (l10nConfig != null) {
      logger.printStatus('Using configuration from l10n.yaml');
      return l10nConfig;
    }

    // Try pubspec.yaml jaspr_localizations section
    final pubspecConfig = fromPubspecYaml(projectRoot, fileSystem, logger);
    if (pubspecConfig != null) {
      logger.printStatus(
        'Using configuration from pubspec.yaml jaspr_localizations section',
      );
      return pubspecConfig;
    }

    // Use defaults
    logger.printStatus('Using default localization configuration');
    return L10nConfig(
      arbDir: 'lib/l10n',
      templateArbFile: 'app_en.arb',
      outputLocalizationFile: 'app_localizations.dart',
      outputClass: 'AppLocalizations',
    );
  }

  /// Get absolute path for ARB directory
  String getArbDirPath(String projectRoot) {
    return path.isAbsolute(arbDir) ? arbDir : path.join(projectRoot, arbDir);
  }

  /// Get absolute path for template ARB file
  String getTemplateArbPath(String projectRoot) {
    final arbDirPath = getArbDirPath(projectRoot);
    return path.join(arbDirPath, templateArbFile);
  }

  /// Get absolute path for output directory
  String getOutputDirPath(String projectRoot) {
    final outputDir = path.dirname(outputLocalizationFile);
    return path.isAbsolute(outputDir)
        ? outputDir
        : path.join(projectRoot, outputDir);
  }

  /// Get just the filename for output localization file
  String get outputFileName => path.basename(outputLocalizationFile);

  @override
  String toString() {
    return 'L10nConfig('
        'arbDir: $arbDir, '
        'templateArbFile: $templateArbFile, '
        'outputLocalizationFile: $outputLocalizationFile, '
        'outputClass: $outputClass'
        ')';
  }
}
