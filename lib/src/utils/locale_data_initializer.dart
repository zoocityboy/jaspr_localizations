// Utility to initialize intl date formatting data for a set of locales.
// Ensures each locale is initialized only once per process to avoid redundant
// work and race conditions during SSR.
import 'package:intl/date_symbol_data_local.dart';

class LocaleDataInitializer {
  LocaleDataInitializer._();

  static final Map<String, Future<void>> _initializations = {};

  /// Initialize date formatting data for the provided [localeTags].
  ///
  /// This method is idempotent and will only initialize each locale once per
  /// process. It returns when all requested initializations are complete.
  static Future<void> initializeForLocales(Iterable<String> localeTags) async {
    final futures = <Future<void>>[];
    for (final tag in localeTags) {
      final normalized = tag.trim();
      if (normalized.isEmpty) continue;
      // Reuse existing future if already initializing/initialized.
      _initializations[normalized] ??= initializeDateFormatting(normalized);
      futures.add(_initializations[normalized]!);
    }
    if (futures.isEmpty) return;
    await Future.wait(futures);
  }
}
