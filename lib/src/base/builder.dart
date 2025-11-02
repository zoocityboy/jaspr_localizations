/// Builder entry point for jaspr_localizations code generation
library;

import 'package:build/build.dart';
import 'package:path/path.dart' as path;

import 'file_system.dart';
import 'logger.dart';
import '../jaspr_l10n_generator.dart';
import 'l10n_config.dart';
import '../utils/localizations_utils.dart';

/// Builder for generating Jaspr localization files from ARB files
/// Now uses Flutter-aligned localization system
class JasprLocalizationBuilder implements Builder {
  JasprLocalizationBuilder(this._buildExtensions);

  final Map<String, List<String>> _buildExtensions;

  @override
  Map<String, List<String>> get buildExtensions => _buildExtensions;

  @override
  Future<void> build(BuildStep buildStep) async {
    final logger = ConsoleLogger();
    final fileSystem = LocalJasprFileSystem();

    // Load configuration from l10n.yaml or pubspec.yaml
    final config = L10nConfig.load('.', fileSystem, logger);
    logger.printStatus('Loaded configuration: $config');

    // For template ARB path, we need lib-relative path
    final arbDirPath = config.arbDir.startsWith('lib/')
        ? config.arbDir
        : path.join('lib', config.arbDir);
    final templateArbPath = path.join(arbDirPath, config.templateArbFile);

    // Output directory and file from config
    final outputDirPath = config.outputLocalizationFile.startsWith('lib/')
        ? path.dirname(config.outputLocalizationFile)
        : path.join('lib', path.dirname(config.outputLocalizationFile));
    final outputFileName = config.outputFileName;

    // Parse preferred supported locales if specified
    List<LocaleInfo>? preferredLocales;
    if (config.preferredSupportedLocales != null &&
        config.preferredSupportedLocales!.isNotEmpty) {
      preferredLocales = config.preferredSupportedLocales!
          .map((locale) => LocaleInfo.fromString(locale))
          .toList();
    }

    try {
      final generator = LocalizationsGenerator(
        fileSystem: fileSystem,
        inputsAndOutputsListPath: '',
        projectPathString: '.',
        outputPathString: outputDirPath,
        templateArbPathString: templateArbPath,
        outputFileString: outputFileName,
        classNameString: config.outputClass,
        preferredSupportedLocales: preferredLocales,
        headerString: config.header,
        headerFile: config.headerFile,
        deferredLoading: config.useDeferredLoading,
        useRelaxedSyntax: config.useRelaxedSyntax,
        useSyntheticPackage: config.useSyntheticPackage,
        useEscaping: config.useEscaping,
        suppressWarnings: config.suppressWarnings,
        useNamedParameters: config.useNamedParameters,
        nullableGetter: config.nullableGetter,
        useFormat: config.useFormat,
        requiredResourceAttributes: config.requiredResourceAttributes,
        untranslatedMessagesFile:
            config.untranslatedMessagesFile ?? 'untranslated_messages.json',
        logger: logger,
      );

      generator.loadResources();
      final generatedCode = generator.generateLocalizationContent();

      // CRITICAL: The output path MUST match exactly what's in buildExtensions
      // buildExtensions is dynamically set based on config
      final outputPath = 'lib/${buildExtensions[r'$lib$']!.first}';
      final outputId = AssetId(buildStep.inputId.package, outputPath);

      await buildStep.writeAsString(outputId, generatedCode);

      logger.printStatus(
        'Jaspr localization files generated successfully to $outputPath',
      );
    } catch (e, stackTrace) {
      logger.printError('Failed to generate localization files: $e');
      logger.printError('Stack trace: $stackTrace');
      rethrow;
    }
  }
}

/// Creates the builder for generating localization code from ARB files
Builder jasprLocalizationsBuilder(BuilderOptions options) {
  // Load configuration to determine output path
  final logger = ConsoleLogger();
  final fileSystem = LocalJasprFileSystem();
  final config = L10nConfig.load('.', fileSystem, logger);

  // Extract the output path relative to lib/
  // If config specifies 'lib/generated/l10n.dart', we need 'generated/l10n.dart'
  String outputPath = config.outputLocalizationFile;
  if (outputPath.startsWith('lib/')) {
    outputPath = outputPath.substring(4); // Remove 'lib/' prefix
  }

  final buildExtensions = {
    r'$lib$': [outputPath],
  };

  logger.printStatus('Build extensions configured: $buildExtensions');

  return JasprLocalizationBuilder(buildExtensions);
}
