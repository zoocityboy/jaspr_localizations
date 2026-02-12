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

  /// Load configuration from a map (e.g. from l10n.yaml or build.yaml)
  static L10nConfig fromMap(Map<dynamic, dynamic> map) {
    return L10nConfig(
      arbDir: map['arb-dir'] as String? ?? 'lib/l10n',
      templateArbFile: map['template-arb-file'] as String? ?? 'app_en.arb',
      outputLocalizationFile:
          map['output-localization-file'] as String? ??
          'app_localizations.dart',
      outputClass: map['output-class'] as String? ?? 'AppLocalizations',
      preferredSupportedLocales: (map['preferred-supported-locales'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      header: map['header'] as String?,
      headerFile: map['header-file'] as String?,
      useDeferredLoading: map['use-deferred-loading'] as bool? ?? false,
      useRelaxedSyntax: map['use-relaxed-syntax'] as bool? ?? false,
      useSyntheticPackage: map['synthetic-package'] as bool? ?? true,
      useEscaping: map['use-escaping'] as bool? ?? false,
      suppressWarnings: map['suppress-warnings'] as bool? ?? false,
      useNamedParameters: map['use-named-parameters'] as bool? ?? false,
      nullableGetter: map['nullable-getter'] as bool? ?? true,
      useFormat: map['format'] as bool? ?? true,
      requiredResourceAttributes:
          map['required-resource-attributes'] as bool? ?? false,
      untranslatedMessagesFile: map['untranslated-messages-file'] as String?,
    );
  }

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
      return fromMap(yamlMap);
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

      return fromMap(jasprL10nConfig);
    } catch (e) {
      logger.printError(
        'Error parsing pubspec.yaml jaspr_localizations section: $e',
      );
      return null;
    }
  }

  /// Load configuration with fallback chain:
  /// 1. Try builder options first
  /// 2. Try l10n.yaml (Flutter standard)
  /// 3. Fall back to pubspec.yaml jaspr_localizations section
  /// 4. Use defaults if neither exists
  static L10nConfig load(
    String projectRoot,
    JasprFileSystem fileSystem,
    Logger logger, {
    Map<String, dynamic>? options,
  }) {
    // Try builder options first
    if (options != null && options.isNotEmpty) {
      logger.printStatus('Using configuration from builder options');
      // Merge with defaults logic inside fromMap or similar?
      // fromMap handles defaults for missing keys.
      return fromMap(options);
    }

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
