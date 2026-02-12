import 'package:intl/locale.dart' as intl;

/// Identifies a specific language and region.
///
/// Consists of a [languageCode] (e.g., 'en') and an optional [countryCode] (e.g., 'US'),
/// [scriptCode], and [variants].
class Locale implements intl.Locale {
  /// Creates a [Locale] identifier.
  const Locale(
    this.languageCode, [
    this.countryCode,
    this.scriptCode,
    this.variants = const [],
  ]);

  /// Creates a [Locale] from a language tag string (e.g., 'en' or 'en_US').
  factory Locale.fromLanguageTag(String tag) {
    final parts = tag.split('_');
    if (parts.length == 1) {
      return Locale(parts[0]);
    } else if (parts.length == 2) {
      return Locale(parts[0], parts[1]);
    }
    throw ArgumentError('Invalid language tag: $tag');
  }

  /// Creates a [Locale] from explicit subtags.
  factory Locale.fromSubtags({
    required String languageCode,
    String? scriptCode,
    String? countryCode,
  }) {
    return Locale(languageCode, countryCode);
  }

  /// Returns a valid BCP-47 language tag (e.g. "en-US").
  @override
  String toLanguageTag() {
    return countryCode != null ? '${languageCode}_$countryCode' : languageCode;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Locale &&
        other.languageCode == languageCode &&
        other.countryCode == countryCode &&
        other.scriptCode == scriptCode &&
        other.variants == variants;
  }

  @override
  int get hashCode =>
      Object.hash(languageCode, countryCode, scriptCode, variants);

  @override
  String toString() => toLanguageTag();

  /// The script code (e.g. "Latn").
  @override
  final String? scriptCode;

  /// Any variants (e.g. "POSIX").
  @override
  final Iterable<String> variants;

  /// The country or region code (e.g. "US").
  @override
  final String? countryCode;

  /// The primary language code (e.g. "en").
  @override
  final String languageCode;
}
