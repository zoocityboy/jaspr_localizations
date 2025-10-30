/// Jaspr Localizations - Provides locale management for Jaspr applications
///
/// This package provides an InheritedComponent-based approach to managing
/// localization in Jaspr applications using a dedicated Locale class.
/// Now includes Flutter-aligned ARB file processing and code generation.
///
/// ## Usage
///
/// Wrap your application with [LocaleProvider]:
///
/// ```dart
/// LocaleProvider(
///   locale: const Locale('en', 'US'),
///   supportedLocales: {
///     const Locale('en', 'US'),
///     const Locale('es', 'ES'),
///   },
///   child: MyApp(),
/// )
/// ```
///
/// Access the locale in descendant components:
///
/// ```dart
/// final provider = LocaleProvider.of(context);
/// final locale = provider.locale;
/// final languageTag = locale.toLanguageTag(); // 'en_US'
/// ```
///
/// ## ARB File Processing
///
/// Place ARB files in `lib/l10n/` directory:
/// - `app_en.arb` (template)
/// - `app_es.arb`
/// - etc.
///
/// The build system will generate localization classes automatically.
library;

export 'package:intl/intl.dart';

export 'src/jaspr_localizations_base.dart';
export 'src/jaspr_l10n_types.dart';
export 'src/localizations_utils.dart';
export 'src/localizations_delegate.dart';
